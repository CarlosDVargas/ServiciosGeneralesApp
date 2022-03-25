require "./app/models/dictionary.rb"

class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy change_status request_action_history ]
  before_action :set_dictionary, only: %i[new show edit update index create reports request_filter]
  before_action :set_status, only: %i[index show]
  after_action :register_request_action, only:%i[edit update change_status]

  # GET /requests or /requests.json
  def index
    set_requests
  end

  # GET /requests/1 or /requests/1.json
  def show
    if @request.status == "denied"
      @reasons = DenyReason.where(request_id: @request.id)
    end
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to request_url(@request), notice: "Request was successfully created." }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      reasons_array = deny_reasons
      if reasons_array
        reasons_array.each { |reason|
          DenyReason.create(description: reason[:description], user: User.first, request: @request)
        }
        @request.update(status: "denied")
        format.html { redirect_to requests_url, notice: "Se actualizó el estado de la solicitud" }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @request.errors }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url, notice: "Request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def change_status
    byebug
    status = @request.status
    case status
    when "in_process"
      set_task
      @task.update(completed?: true)
      if analyse_tasks
        @request.update(status: "completed")
      end
      reload_index()
    when "completed"
      if params[:action] == "close"
        @request.update(status: "closed")
      else
        reset_tasks
        @request.update(status: "in_process")
      end
      reload_index()
    else
      @request.update(status: "in_process")
      redirect_to new_task_path(:request => @request)
    end
  end

  def reports
    @requests = []
    @tempRequests = []
    @filter = ""

    #Se agrega un número a la variable filter después de aplicar un filtro determinado, para leerlo en la vista y dejar los filtros activos

    if params[:value]
      if params[:value][0]
        @filter += "0"
        @requests += Request.where(status: "denied")
      end

      if params[:value][1]
        @filter += "1"
        @requests += Request.where(status: "pending")
      end

      if params[:value][2]
        @filter += "2"
        @requests += Request.where(status: "closed")
      end

      if params[:value][3]
        @filter += "3"
        #En la siguiente línea se agregará la manera de filtrado para cuando sean contratación externa
        #@requests += Request.where(status: "closed")
      end
    end

    if @filter == ""
      @requests = Request.all
    end

    if params[:date_start] || params[:date_end]
      (@requests).each do |rqt|
        if validateDate(params[:date_start][0], rqt.created_at.to_date.to_s, "start") && validateDate(params[:date_end][0], rqt.created_at.to_date.to_s, "end")
          @tempRequests.push(rqt)
        end
      end
      @requests = @tempRequests
      @filter += "4"

    end
  end

  def request_filter
    @requests = []
    @tempRequests = []
    @filter = ""

    #Se agrega un número a la variable filter después de aplicar un filtro determinado, para leerlo en la vista y dejar los filtros activos
    
    if params[:value]
      if params[:value][0]
        @filter += "0"
        @requests += Request.where(status: "denied")
      end

      if params[:value][1]
        @filter += "1"
        @requests += Request.where(status: "pending")
      end

      if params[:value][2]
        @filter += "2"
        @requests += Request.where(status: "closed")
      end

      if params[:value][3]
        @filter += "3"
        #En la siguiente línea se agregará la manera de filtrado para cuando sean contratación externa
        #@requests += Request.where(status: "closed")
      end

      if @filter == ""
        @requests = Request.all
      end

      (@requests).each do |rqt|
        if validateDate(params[:filter][4], rqt.created_at.to_date.to_s, "start") && validateDate(params[:filter][5], rqt.created_at.to_date.to_s, "end")
          @tempRequests.push(rqt)
        end
      end
      @requests = @tempRequests
      @filter += "4"
    end
    
    if @filter == ""
      @requests = Request.all
    end

    render partial: 'requests/report_list', locals: { requests: @requests}
  end

  def ask_state
  end

  def search_state
    if params[:session][:request_number] && params[:session][:requester_email]
      @request = Request.where(id: params[:session][:request_number].to_i, requester_mail: params[:session][:requester_email]).first
    end
    if @request != nil
      session[:request_id] = @request.id
      redirect_to request_url(@request)
    else
      render "ask_state"
    end
  end

  def register_request_action
    newAction = ActionController::Parameters.new(request_id: @request.id, user_id: current_user.id).permit(:request_id, :user_id)
    @request_action = RequestAction.new(newAction)
  end

  def request_action_history
    @history = RequestAction.where(request_id: @request.id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  def set_requests
    if current_user.role == "employee"
      employee = Employee.where(user_id: current_user).first
      employee_requests = employee.requests
      case @status
      when "completed"
        @requests = find_requests(employee_requests, "completed")
      when "closed"
        @requests = find_requests(employee_requests, "closed")
      else
        @requests = find_requests(employee_requests, "in_process")
      end
    else
      case @status
      when "in_process"
        @requests = find_requests(Request.all, "in_process")
      when "completed"
        @requests = find_requests(Request.all, "completed")
      when "closed"
        @requests = find_requests(Request.all, "closed")
      when "denied"
        @requests = find_requests(Request.all, "denied")
      else
        @requests = find_requests(Request.all, "pending")
      end
    end
  end

  def find_requests(set, status)
    set.where(status: status)
  end

  def deny_reasons
    if params[:request]
      params[:request][:deny_reasons_attributes].values
    end
  end

  # Initialises the dictionary with the default values
  def set_dictionary
    @dictionary = Dictionary.new()
  end

  def set_status
    @status = params[:status]
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def reload_index()
    redirect_to requests_path, notice: "Se actualizó el estado de la solicitud"
  end

  def analyse_tasks
    tasks = @request.tasks
    tasks.each do |task|
      if !task.completed?
        return false
      end
    end
    return true
  end

  def reset_tasks
    tasks = @request.tasks
    tasks.each do |task|
      task.update(completed?: false)
    end
  end

  # Only allow a list of trusted parameters through.
  def request_params
    params.require(:request).permit(:requester_name, :requester_extension, :requester_phone, :requester_id, :requester_mail, :requester_type, :student_id, :student_assosiation, :work_location, :work_building, :work_type, :work_description, :task_id, :action, deny_reasons: [:_destroy, :description, :request_id, :user_id])
  end

  def validateDate(datePartReaded, datePartDataBase, order)
    if order == "start"
      return datePartReaded == "" || datePartReaded <= datePartDataBase
    elsif order == "end"
      return datePartReaded == "" || datePartReaded >= datePartDataBase
    else
      return false
    end
  end
end

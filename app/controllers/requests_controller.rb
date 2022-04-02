require "./app/models/dictionary.rb"

# Controller for all the actions that require use of a request object
class RequestsController < ApplicationController

  #Mehtods called before every action
  before_action :set_request, only: %i[ show edit update destroy change_status request_action_history ]
  before_action :set_dictionary, only: %i[new show edit update index create reports request_filter]
  before_action :set_status, only: %i[index show]

  # Mehtods called after every action
  after_action :register_request_action, only: %i[update change_status]

  # GET /requests or /requests.json
  def index
    if ask_for_user_logged_in
      set_requests
    end
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

  # Encharged of updating the status of a request depending on the status obtained from the params
  def change_status
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

  # Falta documentación
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

  # Falta documentación
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

    render partial: "requests/report_list", locals: { requests: @requests }
  end

  # Falta documentación
  def ask_state
  end

  # Falta documentación
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

  # Falta documentación
  def register_request_action
    newAction = ActionController::Parameters.new(request_id: @request.id, user_id: current_user.id).permit(:request_id, :user_id)
    @request_action = RequestAction.new(newAction)
    @request_action.save
  end

  # Falta documentación
  def request_action_history
    @history = RequestAction.where(request_id: @request.id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  # Set the requests depending the user role and the status of the request
  def set_requests

    # Case for the employee
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

    # Case for the admin
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

  # Take the requests from given set: <b>set</b> depending the status: <b>status</b> of the request
  def find_requests(set, status)
    set.where(status: status)
  end

  # Return the deny reasons of a request
  def deny_reasons
    if params[:request]
      params[:request][:deny_reasons_attributes].values
    end
  end

  # Initializes the dictionary with the default values
  def set_dictionary
    @dictionary = Dictionary.new()
  end

  # Initializes the status of a request
  def set_status
    @status = params[:status]
  end

  # Takes the tasks from table <b>Task</b>
  def set_task
    @task = Task.find(params[:task_id])
  end

  # Reload the requests listing view, and informs the user that the request was successfully updated
  def reload_index()
    redirect_to requests_path, notice: "Se actualizó el estado de la solicitud"
  end

  # Sets the completed? attribute of the tasks of the request to false
  def reset_tasks
    tasks = @request.tasks
    tasks.each do |task|
      task.update(completed?: false)
    end
  end

  # Depending the value of the completed? attribute of the tasks of the current request,
  # will return true if all the tasks are completed, or false if at least one task is not completed
  def analyse_tasks
    tasks = @request.tasks
    tasks.each do |task|
      if !task.completed?
        return false
      end
    end
    return true
  end

  # Define the elements allowed to be passed by the params
  def request_params
    params.require(:request).permit(:requester_name, :requester_extension, :requester_phone, :requester_id, :requester_mail, :requester_type, :student_id, :student_assosiation, :work_location, :work_building, :work_type, :work_description, :task_id, :action, deny_reasons: [:_destroy, :description, :request_id, :user_id])
  end

  # Falta documentación
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

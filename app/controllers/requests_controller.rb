require "./app/models/dictionary.rb"

class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy change_status ]
  before_action :set_dictionary, only: %i[new show edit update index create reports]
  before_action :set_status, only: %i[index show]

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
    status = @request.status
    case status
    when "in_process"
      @request.update(status: "pending")
      reload_index()
    when "completed"
      @request.update(status: "closed")
      reload_index()
    when "closed"
      @request.update(status: "in_process")
      reload_index()
    when "denied"
    else
      @request.update(status: "in_process")
      if current_user.role == "employee"
      else
        redirect_to new_task_path(:request => @request)
      end
    end
  end

  def reports
    @requests = []
    @tempRequests = []
    @filter = ""

    #Se agrega un número a la variable filter después de aplicar un filtro determinado, para leerlo en la vista y dejar los filtros activos

    if params[:denied]
      @filter += "0"
      @requests += Request.where(status: "denied")
    end

    if params[:pending]
      @filter += "1"
      @requests += Request.where(status: "pending")
    end

    if params[:finished]
      @filter += "2"
      @requests += Request.where(status: "closed")
    end

    if params[:outsourcing]
      @filter += "3"
      #En la siguiente línea se agregará la manera de filtrado para cuando sean contratación externa
      #@requests += Request.where(status: "closed")
    end

    if @filter == ""
      @requests = Request.all
    end

    if params[:request_year]
      @year = params[:request_year].values[0]
      @month = params[:request_year].values[1]
      @day = params[:request_year].values[2]

      if @year != "" || @month != "" || @day != ""
        (@requests).each do |rqt|
          if validateDate(@year.to_i, rqt.created_at.year) && validateDate(@month.to_i, rqt.created_at.month) && validateDate(@day.to_i, rqt.created_at.day)
            @tempRequests.push(rqt)
          end
        end
        @requests = @tempRequests
        @filter += "4"
      end
    end
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
      when "in_process"
        @requests = find_requests(employee_requests, "in_process")
      when "completed"
        @requests = find_requests(employee_requests, "completed")
      when "closed"
        @requests = find_requests(employee_requests, "closed")
      when "denied"
        @requests = find_requests(employee_requests, "denied")
      else
        @requests = find_requests(employee_requests, "pending")
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

  def reload_index()
    redirect_to requests_path, notice: "Se actualizó el estado de la solicitud"
  end

  # Only allow a list of trusted parameters through.
  def request_params
    params.require(:request).permit(:requester_name, :requester_extension, :requester_phone, :requester_id, :requester_mail, :requester_type, :student_id, :student_assosiation, :work_location, :work_building, :work_type, :work_description, deny_reasons: [:_destroy, :description, :request_id, :user_id])
  end

  def validateDate(datePartReaded, datePartDataBase)
    return datePartReaded == 0 || datePartReaded == datePartDataBase
  end
end

require "./app/models/dictionary.rb"
class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show edit update destroy change_status]
  before_action :set_dictionary, only: %i[new show edit update index create]
  before_action :set_status, only: %i[index show]

  # GET /requests or /requests.json
  def index
    case @status
    when 'in_process'
      @requests = Request.where(status: "in_process")
    when 'completed'
      @requests = Request.where(status: "completed")
    when 'closed'
      @requests = Request.where(status: "closed")
    when 'denied'
      @requests = Request.where(status: "denied")
    else
      @requests = Request.where(status: "pending")
    end
  end

  # GET /requests/1 or /requests/1.json
  def show
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
    byebug
    respond_to do |format|

      deny_reasons = request_params[:deny_reasons_attributes]
      
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
    when 'in_process'
      @request.update(status: 'pending')
      reload_index()
    when 'completed'
      @request.update(status: 'closed')
      reload_index()
    when 'closed'
      @request.update(status: 'in_process')
      reload_index()
    when 'denied'
      
    else
      @request.update(status: 'in_process')
      reload_index()
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
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
      params.require(:request).permit(:requester_name, :requester_extension, :requester_phone, :requester_id, :requester_mail, :requester_type, :student_id, :student_assosiation, :work_location, :work_building, :work_type, :work_description, deny_reasons_attributes: [ :_destroy, :description, :request_id, :user_id])
    end
end

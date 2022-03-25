require "./app/models/dictionary.rb"

class TasksController < ApplicationController
  before_action :set_request, only: %i[ new edit ]
  before_action :set_employees, only: %i[ new edit ]
  before_action :set_dictionary, only: %i[ edit ]
  after_action :register_request_action, only: %i[new edit]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/edit
  def edit
    if current_user.role == "employee"
      set_task
      set_observations
    end
  end

  # POST /tasks or /tasks.json
  def create
    set_employees_for_create
    @request = Request.find(params[:request_id])
    if !@employees.nil?
      @employees.each { |employee_id|
        Task.create(employee_id: employee_id, request_id: @request.id)
      }
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if current_user.role == "employee"
      set_task
      description = params[:task][:observations][:description]
      if description.length > 0
        observation = Observation.create(task_id: @task.id, user_id: current_user.id, description: description)
      end
    else
      if !set_employees_for_destroy.nil?
        @request = Request.find(params[:request_id])
        if !@employees.nil?
          @employees.each { |employee_id|
            task = Task.where(employee_id: Integer(employee_id), request_id: @request.id)
            task.destroy_all
          }
        end
      elsif !set_employees_for_create.nil?
        create
      end
    end
    redirect_to edit_task_path(request => @request)
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def register_request_action
    newAction = ActionController::Parameters.new(request_id: @request.id, user_id: current_user.id).permit(:request_id, :user_id)
    @request_action = RequestAction.new(newAction)
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_observations
    @observations = Observation.where(task_id: @task.id, user_id: current_user.id)
  end

  def set_task
    employee_id = Employee.where(user_id: current_user.id).first.id
    if @request.nil?
      @request = Request.find(params[:task][:request])
    end
    @task = Task.where(employee_id: employee_id, request_id: @request.id).first
  end

  def set_request
    @request = Request.find(params[:request])
  end

  def employee(id)
    @employee = Employee.find(id)
  end

  def set_employees
    @employees = Employee.all
  end

  def set_employees_for_create
    @employees = params[:selected_employees_to_add]
  end

  def set_employees_for_destroy
    @employees = params[:selected_employees_to_remove]
  end

  def set_dictionary
    @dictionary = Dictionary.new()
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:employee_id, :request_id, :selected_employees[], employees: [:id], observations: [:description])
  end
end

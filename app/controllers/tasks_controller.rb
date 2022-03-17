class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :set_request, only: %i[ new ]
  before_action :set_employees, only: %i[ new ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    byebug
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    set_employees_for_create
    if @employees.nil?
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @task.errors, status: :unprocessable_entity }

    else
      @request = Request.find(params[:task][:request_id])
      @employees.each { |employee_id| 
        Task.create(employee_id: employee_id, request_id:@request.id)
      }
      redirect_to requests_path
    end
    #@task = Task.new(task_params)
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
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
    @employees = params[:selected_employees]
  end



  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:employee_id, :request_id, :selected_employees[], employees:[:id])
  end
end

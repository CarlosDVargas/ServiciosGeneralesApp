class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_employee_deleteConfirm, only: %i[ deleteConfirm ]
  before_action :set_status, only: %i[index show]

  # GET /employees or /employees.json
  def index
    if params[:active] && params[:inactive]
      @status = "both"
      @employees = Employee.all
    elsif params[:active]
      @status = "active"
      @employees = Employee.where(status: true)
    elsif params[:inactive]
      @status = "inactive"
      @employees = Employee.where(status: false)
    else
      @status = nil
      @employees = Employee.all
    end

  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  def deleteConfirm
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_url(@employee), notice: "Empleado creado correctamente." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Empleado actualizado correctamente." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Empleado eliminado correctamente." }
      format.json { head :no_content }
    end
  end

  def statusfilter

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def set_employee_deleteConfirm
      @employee = Employee.find(params[:format])
      
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:idCard, :fullName, :email, :status)
    end

    def set_status
      @status = params[:status]
    end
end

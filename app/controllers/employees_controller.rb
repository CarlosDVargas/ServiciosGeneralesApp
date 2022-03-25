class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_employee_deleteConfirm, only: %i[ deleteConfirm ]
  before_action :set_status, only: %i[index show]

  # GET /employees or /employees.json
  def index
    if params[:status]
      if params[:value][0] || (params[:value][1] && value[:status][2])
        @employees = Employee.all
        @status = "both"
      elsif params[:value][1]
        @employees = Employee.where(status: true)
        @status = "active"
      elsif params[:value][2]
        @employees = Employee.where(status: false)
        @status = "inactive"
      else
        @employees = Employee.all
        @status = nil
      end
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
    if !@employee.idCard.nil? && !@employee.fullName.nil? && !@employee.email.nil?
      @user = User.new(:email => @employee.email, :password => "Con#{@employee.idCard}", :name => @employee.fullName)
      @user.save
    end
    @employee.write_attribute(:user_id, @user.id)
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
    if @employee.tasks.empty?
      @employee.destroy

      respond_to do |format|
        format.html { redirect_to employees_url, notice: "Empleado eliminado correctamente." }
        format.json { head :no_content }
      end
    else
      redirect_to '#', notice: "No se puede eliminar un trabajador que haya sido asignado a una solicitud"
    end
  end

  def status_filter
    if params[:value][0] || (params[:value][1] && params[:value][2])
      @employees = Employee.all
      @status = "both"
    elsif params[:value][1]
      @employees = Employee.where(status: true)
      @status = "active"
    elsif params[:value][2]
      @employees = Employee.where(status: false)
      @status = "inactive"
    else
      @employees = Employee.all
      @status = nil
    end
    render partial: "employees/employee_list", locals: { employees: @employees }
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

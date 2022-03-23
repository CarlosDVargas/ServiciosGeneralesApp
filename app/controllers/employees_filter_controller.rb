class EmployeesFilterController < ApplicationController
    def index
      byebug
      if params[:value][0] == "active"
        @employees = Employee.where(status: true)
      else
        @employees = Employee.where(status: false)
      end
    end
  end
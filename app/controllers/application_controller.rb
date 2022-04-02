class ApplicationController < ActionController::Base
  def ask_for_user_logged_in
    if !current_user
      redirect_to root_path, notice: "Debes iniciar sesión para acceder a esta sección de la página"
      return false
    end
    return true
  end

  def ask_for_user_role(user_role)
    if current_user.role != user_role
      redirect_to root_path, notice: "No tienes permisos para acceder a esta sección de la página"
      return false
    end
    return true
  end
end

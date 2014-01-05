#encoding: utf-8
class UserController < ApplicationController

  before_action :login_required, :only => :myaccount

  def login

    params[:page_title] = 'Login - Datos Democráticos'
    params[:page_description] = 'Ingresa a Datos Democráticos y obtiene tu Api Key para acceder a los datasets completos de Open Data.'


  end

  def autenticar

    params[:page_title] = 'Login - Datos Democráticos'

    if user = User.authenticate(params[:email], params[:password])

        user_status = UserStatus.where(:name => 'activo').first

      if user.user_status == user_status
        self.set_logged_user user
        self.redirect_to_stored
      else
        UserMailer.signup_confirmation(user).deliver
        flash[:notice] = "Por favor active la cuenta. Se reenvio el mail de confirmación."
        redirect_to login_path
      end
    else
      flash[:notice] = "Usuario o password inválido."
      redirect_to login_path
    end
  end

  def registracion
    params[:page_title] = 'Registración - Datos Democráticos'
    params[:page_description] = 'Registrate a Datos Democráticos y obtiene tu Api Key para acceder a los datasets completos de Open Data.'
  end

  def registrar

    params[:page_title] = 'Registración - Datos Democráticos'
    params[:page_description] = 'Registrate a Datos Democráticos y obtiene tu Api Key para acceder a los datasets completos de Open Data.'

    @user = User.new()

    userStatus = UserStatus.where(:name => 'pendiente').first
    @user.user_status = userStatus

    email = params[:email]
    @user.email = email
    if !@user.setPassword params[:password], params[:repetir_password]

      flash[:notice] = "El password no coincide"
      redirect_to registracion_form_path

    else

      @user.generate_apikey

      if @user.save

        role = Role.get_user

        user_role = UserRole.new
        user_role.user = @user
        user_role.role = role
        user_role.save

        UserMailer.signup_confirmation(@user).deliver

        redirect_to register_success_path
      else
        flash[:notice] = @user.errors.values;
        redirect_to registracion_form_path
      end
    end

  end

  def register_success
    params[:page_title] = 'Bienvenido - Datos Democráticos'
  end

  def activar
    params[:page_title] = 'Activación de cuenta - Datos Democráticos'

    id = params[:id]
    hash = params[:hash]

    user = User.find(id)

    if (user.get_signup_hash == hash)

      userStatus = UserStatus.where(:name => 'activo').first
      user.user_status = userStatus

      if (user.save)
        self.set_logged_user user
        flash[:notice] = "Tu cuenta ya esta activada."
        redirect_to myaccount_path
      else
        flash[:notice] = "Ocurrio un error, pruebe de nuevo."
        redirect_to home_path
      end
    else
      flash[:notice] = "El link no es válido"
      redirect_to home_path
    end

  end

  def logout
    reset_session
    redirect_to home_path
  end

  def forgot_password_form
    params[:page_title] = 'Olvido de password - Datos Democráticos'
  end
  def forgot_password

    user = User.find_by_email(params[:email])

    if user.nil?
      flash[:notice] = "La dirección de correo no es válida."
      redirect_to forgot_password_path

    else
      UserMailer.forgot_password_confirmation(user).deliver

      flash[:notice] = "Un correo se envio a su dirección."
      redirect_to home_path

    end
  end

  def password_recovery_form

    params[:page_title] = 'Recuperación de password - Datos Democráticos'

    @id = params[:id]
    @hash = params[:hash]

    user = User.find(@id)

    if (user.get_password_recovery_hash  != @hash)
      flash[:notice] = "El link no es válido."
      redirect_to home_path
    end
  end

  def password_recovery
    @id = params[:id]
    @hash = params[:hash]

    user = User.find(@id)

    if (user.get_password_recovery_hash  == @hash)

        if !user.setPassword params[:password], params[:password_confirmation]

          flash[:notice] = "El password no coincide"

          render :password_recovery_form

        else

          if user.save

            self.set_logged_user user

            redirect_to home_path

          end

        end

    else
      flash[:notice] = "The link is not valid"
      redirect_to home_path
    end
  end

  def myaccount
      params[:page_title] = 'Mi cuenta - Datos Democráticos'
      @user = self.get_logged_user
      params[:current_menu_item] = :micuenta
      @usage = ApiUse.where(:user => @user).last(20)
  end
end
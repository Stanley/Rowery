class SessionsController < ApplicationController

  def new
    render
  end

  def create

    request.env['warden'].authenticate!
    if logged_in?
      flash[:notice] = "Welcome"
      redirect_to '/'
    else
      unauthenticated
    end
  end

  def unauthenticated
    flash[:error] = "Authentication Required"
    render :new
  end

  def destroy
    request.env['warden'].logout
    flash[:notice] = "logged out"
    redirect_to '/'
  end

end
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.create(params[:user])
    
    respond_to do |format|
      format.html do
        if @user.errors.empty?
          flash[:notice] = "Thanks for signing up!"
          redirect_to('/')
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def index
    request.env['warden'].authenticate!
  end

  def show
    render
  end
end
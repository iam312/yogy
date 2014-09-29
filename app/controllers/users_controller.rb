class UsersController < ApplicationController
  def create
    @user = Users.new
  end

  def edit
  end

  def update
    user = Users.find_by_email( params["users"]["email"] )
    case user
    when nil
      Users.create( params["users"].symbolize_keys() )
    else
      user.update( params["users"].symbolize_keys() )
    end
    redirect_to action: 'show', status: 303
  end

  def show
  end

  def delete
  end
end

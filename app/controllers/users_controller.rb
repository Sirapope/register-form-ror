class UsersController < ApplicationController
  def register
  end

  def create
    # Here you would typically save the user data
    # For now, we'll just redirect back to the form
    redirect_to users_new_path, notice: 'User registered successfully!'
  end
end

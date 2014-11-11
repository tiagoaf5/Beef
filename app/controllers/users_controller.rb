class UsersController < ApplicationController

  def show

    if(user_signed_in?)

      @user=User.find(params[:id])
      @name=@user.name
      @email=@user.email
      @owner=0

      if current_user.id == params[:id]
        @owner=1

      end
    end
  end
end

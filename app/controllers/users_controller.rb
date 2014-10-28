class UsersController < ApplicationController

  def show
    @user=User.find(params[:id])
    @cenas = 'a'
    if(user_signed_in?)
      if current_user.id == params[:id]
        @cenas = 'b'

      end


    end

  end
end

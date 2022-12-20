class SessionsController < ApplicationController

   def new
      @user = User.new
      render :new
   end

   def create
      @user = User.find_by_credentials(params[:user][:email], params[:user][:password])

      if @user.save
         login!(@user)
         redirect_to user_url(@user)
      else
         redirect_to new_session_url
      end
   end
   
   def destroy
      logout! if logged_in?
      
      redirect_to new_session_url
   end
end

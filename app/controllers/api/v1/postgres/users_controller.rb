require './app/services/postgres/user_service'

class Api::V1::Postgres::UsersController < ApplicationController
  before_action :setUser, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = UserService.listUsers

    render json: @users
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /users
  def create
    user = params[:name]  
    password = params[:password]

    UserService.createUser(name: user, password: password)
  
    render json: { message: "User '#{user}' created successfully" }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

    # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def setUser
      userId = params[:id]
      @user = UserService.getUserById(userId)
    end

    # Only allow a list of trusted parameters through.
    def userParams
      params.fetch(:user, {})
    end
end

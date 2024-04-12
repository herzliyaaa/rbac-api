require './app/services/mssql/role_service'

class Api::V1::Mssql::RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy]

  # GET /roles
  def index
    @roles = MSSQLRoleService.new.list_roles  # Call instance method list_roles

    render json: @roles
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /roles/1
  def show
    render json: @role
  end

  # POST /roles
  def create
    role_params = { name: params[:name] }  # Create role_params hash
    MSSQLRoleService.new.create_role(role_params)  # Call instance method create_role

    render json: { message: "Role '#{role_params[:name]}' created successfully" }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy!
  end

  private

  def set_role
    @role = Role.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Role not found" }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.permit(:name)  # Adjusted to permit only :name
  end
end
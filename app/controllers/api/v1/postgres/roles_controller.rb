require './app/services/postgres/role_service'

class Api::V1::Postgres::RolesController < ApplicationController
  before_action :set_role, only: %i[ show update destroy ]

  # GET /roles
  def index
    @roles = RoleService.listRoles

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
    role_name = params[:name]  # Assuming you're passing the role name through params
  
    # Execute the raw SQL query to create the role
    RoleService.createRole(name: role_name)
  
    render json: { message: "Role '#{role_name}' created successfully" }, status: :created
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

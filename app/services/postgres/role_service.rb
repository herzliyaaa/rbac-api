class RoleService
  def initialize
    @postgres_connection = ActiveRecord::Base.connection
    @mssql_connection = establish_mssql_connection
  end

  def create_role(params)
    role_name = params[:name]
    validate_role_name(role_name)

    ActiveRecord::Base.transaction do
      @postgres_connection.execute("CREATE ROLE #{role_name} NOLOGIN")
    end
  rescue PG::Error, TinyTds::Error => e
    Rails.logger.error("Error creating role: #{e.message}")
    raise CreateRoleError, "Error creating role: #{e.message}"
  end

  def list_roles
    @mssql_connection.exec_query("SELECT name AS role FROM sys.database_principals").map do |row|
      { role: row['role'] }
    end
  rescue TinyTds::Error => e
    Rails.logger.error("Error listing roles: #{e.message}")
    raise ListRolesError, "Error listing roles: #{e.message}"
  end

  private

  def validate_role_name(role_name)
    raise ArgumentError, "Invalid role name: #{role_name}" unless role_name.match(/^[a-zA-Z0-9_]+$/)
  end

  def establish_mssql_connection
    mssql_config = Rails.application.config_for(:database)['mssql']

    puts "MSSQL Configuration: #{mssql_config.inspect}"  # Add this line for logging
    ActiveRecord::Base.establish_connection(mssql_config).connection
  end
end

# Custom error classes
class CreateRoleError < StandardError; end
class ListRolesError < StandardError; end

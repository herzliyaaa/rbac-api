class PostgresRoleService
  def initialize
    @postgres_connection = establish_postgres_connection
    @mssql_connection = establish_mssql_connection
  end

  def create_role(params)
    role_name = params[:name]
    check_role_exists(role_name)

    ActiveRecord::Base.transaction do
      @postgres_connection.execute("CREATE ROLE #{role_name} NOLOGIN")
    end
  rescue PG::Error, TinyTds::Error => e
    Rails.logger.error("Error creating role: #{e.message}")
    raise CreateRoleError, "Error creating role: #{e.message}"
  end

  def list_roles
    @postgres_connection.execute("SELECT * FROM pg_roles").map do |row|
      { role: row['rolname']}
    end
  rescue PG::Error => e
    Rails.logger.error("Error listing roles: #{e.message}")
    raise ListRolesError, "Error listing roles: #{e.message}"
  end

  private

  def validate_role_name(role_name)
    raise ArgumentError, "Invalid role name: #{role_name}" unless role_name.match(/^[a-zA-Z0-9_]+$/)
  end

  def check_role_exists(role_name)
    @postgres_connection.execute("SELECT * FROM pg_roles WHERE rolname = '#{role_name}'").count.positive?
  end

  def establish_mssql_connection
    mssql_config = Rails.application.config_for(:database)['mssql']
    puts "MSSQL Configuration: #{mssql_config.inspect}"  # Add this line for logging
    ActiveRecord::Base.establish_connection(mssql_config).connection
  end

  def establish_postgres_connection
    postgres_config = Rails.application.config_for(:database)['postgresql']
    puts "Postgres Configuration: #{postgres_config.inspect}"
    ActiveRecord::Base.establish_connection(postgres_config).connection
  end
end

# Custom error classes
class CreateRoleError < StandardError; end
class ListRolesError < StandardError; end

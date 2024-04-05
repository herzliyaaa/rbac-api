class RoleService
    def self.createRole(params)
      role = params[:name]
  
      # Validate role name (optional but recommended)
      validateRole(role)
  
      ActiveRecord::Base.connection.execute("CREATE ROLE #{role}")
    rescue => exception
      raise CreateRoleError.new(exception.message)
    end
  
    def self.listRoles
      results = ActiveRecord::Base.connection.execute("SELECT rolname AS role FROM pg_roles ORDER BY  rolname ASC;")
  
      # Map results to a more convenient structure (optional)
      results.map do |row|
        {
          role: row['role'],
        }
      end
    end
  
    private
  
    def self.validateRole(role_name)
      # Implement validation logic here (e.g., length, allowed characters)
      # Raise an exception or return an error message if invalid
      raise ArgumentError, "Invalid role name: #{role_name}" unless role_name.match(/^[a-zA-Z0-9_]+$/)
    end
  end
  
  # Custom error class (optional but recommended)
  class CreateRoleError < StandardError
  end
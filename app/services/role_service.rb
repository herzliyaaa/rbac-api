class RoleService
    def self.create_role(params)
      role = params[:name]
  
      # Validate role name (optional but recommended)
      validate_role_name(role)
  
      ActiveRecord::Base.connection.execute("CREATE ROLE #{role}")
    rescue => exception
      raise CreateRoleError.new(exception.message)
    end
  
    def self.list_roles
      results = ActiveRecord::Base.connection.execute("
        SELECT
          u.*,
          u.usename AS username,
          r.rolname AS role,
          CASE
            WHEN r.rolsuper THEN 'superuser'
            WHEN r.rolinherit THEN 'inherit'
            WHEN r.rolcreaterole THEN 'createrole'
            WHEN r.rolcreatedb THEN 'createdb'
            WHEN r.rolreplication THEN 'replication'
            ELSE ''
          END AS RoleAttributes
        FROM
          pg_user u
        LEFT JOIN
          pg_auth_members m ON u.usesysid = m.member
        LEFT JOIN
          pg_roles r ON m.roleid = r.oid
        ORDER BY
          u.usename, r.rolname;
      ")
  
      # Map results to a more convenient structure (optional)
      results.map do |row|
        {
          username: row['username'],
          role: row['role'],
          role_attributes: row['RoleAttributes']
        }
      end
    end
  
    private
  
    def self.validate_role_name(role_name)
      # Implement validation logic here (e.g., length, allowed characters)
      # Raise an exception or return an error message if invalid
      raise ArgumentError, "Invalid role name: #{role_name}" unless role_name.match(/^[a-zA-Z0-9_]+$/)
    end
  end
  
  # Custom error class (optional but recommended)
  class CreateRoleError < StandardError
  end
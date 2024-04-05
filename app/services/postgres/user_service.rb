class UserService
    def self.createUser(params)
      username = params[:name]
      password = params[:password]
  
      validateUser(username)
  
      ActiveRecord::Base.connection.execute("CREATE USER #{username} WITH PASSWORD #{password}")
    rescue => exception
      raise CreateRoleError.new(exception.message)
    end
  
    def self.listUsers
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
          id: row['usesysid'],
          username: row['username'],
          role: row['role'],
          role_attributes: row['RoleAttributes']
        }
      end
    end

    def self.getUserById(id)
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
        WHERE u.usesysid = #{id}
        ORDER BY
          u.usename, r.rolname;
      ")
  
      # Map results to a more convenient structure (optional)
      results.map do |row|
        {
          id: row['usesysid'],
          username: row['username'],
          role: row['role'],
          role_attributes: row['RoleAttributes']
        }
      end
    end
  
    private
  
    def self.validateUser(username)
      # Implement validation logic here (e.g., length, allowed characters)
      # Raise an exception or return an error message if invalid
      raise ArgumentError, "Invalid user: #{username}" unless username.match(/^[a-zA-Z0-9_]+$/)
    end
  end
  
  # Custom error class (optional but recommended)
  class CreateRoleError < StandardError
  end
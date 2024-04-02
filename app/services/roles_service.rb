
class RoleService
    def self.create_role(params)
        role_name = params[:name]
        ActiveRecord::Base.connection.execute("CREATE ROLE #{role_name}")
    end
end
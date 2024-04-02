# app/models/role.rb
class Role < ApplicationRecord
    def self.create(name:)
      ActiveRecord::Base.connection.execute("CREATE ROLE #{name}")
    end
  end
  
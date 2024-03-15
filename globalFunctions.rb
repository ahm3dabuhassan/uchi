require 'mysql'
require 'BCrypt'

class VerifyUser 
    DB_Data = {
        :user => 'root', :password => 'airbag2323_23', :host => 'localhost', :dbname => 'kino', :table_name => 'users'
    }
    @@v = {
        :connection => nil, :response => nil, :command => nil, :verify => nil
    }
    def initialize(username, password)
        @username, @password = username, password
        @response = nil
        self.connect()
    end

    def connect()
        begin
        @@v[:connection] = Mysql.connect("mysql://#{DB_Data[:user]}:#{DB_Data[:password]}@#{DB_Data[:host]}/#{DB_Data[:dbname]}")
        @@v[:command] = "SELECT * FROM #{DB_Data[:table_name]} WHERE username = '#{@username}'"
        @@v[:response] = @@v[:connection].query(@@v[:command])
        @response = @@v[:response].fetch_hash()
        return @response

        rescue Mysql::Error => e 
            puts e.errno
            puts e.error
        end
    end
    def verify()
        if @@v[:verify] = BCrypt::Password.new(@response["Password"]) == @password
            return true
        else 
            return false
        end
    end
    attr :response
end



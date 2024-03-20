require 'mysql'
require 'BCrypt'
require 'socket'

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

class CompareString 
    @@counter = 0
    @@result = 0
    def initialize(s1,s2)
        @string01, @string02 = s1, s2
    end
    def go() 
        while @@counter < @string02.length do
            puts "\e[32mCompareString:. #{@string01[@@counter]}, #{@string02[@@counter]}\e[0m"
            if @string01[@@counter] == @string02[@@counter]
                @@result += 1
            end
            @@counter += 1
        end
        puts "RESULT:#{@@result}, #{@string02.length}"
        if @@result == @string02.length
            return true
        else 
            return false
        end
    end
end



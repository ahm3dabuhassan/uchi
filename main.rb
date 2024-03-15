require 'socket'
require 'uri'
require './globalFunctions.rb'
require './html_templates/home.rb'

server = TCPServer.new(8080)

loop do
    client = server.accept
    request_line = client.readline
    method_token, target, version_number = request_line.split
    puts "\e[32mReceived a #{method_token} request to #{target} with #{version_number}\e[0m"

    case [method_token, target]
    when ['GET','/home']
        status_code = '200 OK'
        response_message = home('HOME.', 'Falsches PASSWORD.')
    when ['POST', '/login']
        status_code = '200 OK'
        puts target
        headers = {}
        while true 
            line = client.readline 
            break if line == "\r\n"
            header_name, value = line.split(": ")
            headers[header_name] = value
        end
        body = client.read(headers['Content-Length'].to_i)
        userData = URI.decode_www_form(body).to_h # :username, :password
        user = VerifyUser.new(userData["username"], userData["password"])
        if user.verify()
            puts "Ok"
        else 
            puts "Nope."
        end
    end
    http_response = <<~MSG
    HTTP/1.1 #{status_code}
    Content-Type: text/html; charset=utf-8

    #{response_message}
    MSG
    client.puts(http_response)
    client.close
end
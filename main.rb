require 'socket'
require 'uri'
require 'net/http'
require './globalFunctions.rb'
require './html_templates/template.rb'

server = TCPServer.new(8080)
cookies = {
    :sUser => nil,
    :sInt => rand(100)
}
loop do
    client = server.accept
    request_line = client.readline
    method_token, target, version_number = request_line.split
    puts "\e[32mReceived a #{method_token} request to #{target} with #{version_number}\e[0m"

    case [method_token, target]
    when ['GET','/home']
        status_code = '200 OK'
        response_message = home('HOME.', 'Falsches PASSWORD.')
        response_message << "<script>"
        f = File.open("./js/test.js")
            content = f.read
            response_message << content
        f.close
        response_message << "</script>"
    when ['POST', '/login']
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
        userData = user.connect()
        if user.verify()
            puts "Ok"
            status_code = '303 OK'
            cookies[:sUser] = "sid=#{userData["Username"]}_#{cookies[:sInt]}" #max-age=60 
            lock = "Location: http://127.0.0.1:8080/inside/#{userData["Username"]}"
        else 
            puts "Nope."
            status_code = '303 OK'
            lock = "Location: http://127.0.0.1:8080/home"
        end
    when ['GET',target[/^\/inside\/[0-9a-zA-Z]+/]] # target[/^\/inside\/[0-9a-zA-Z]+/]
        nickname = target.slice!(/[a-z0-9]+$/)
        saveH = {}
        while true 
            findCookie = client.readline 
            break if findCookie == "\r\n"
            header_name, value = findCookie.split(": ")
            saveH[header_name] = value
        end
        saveH["Cookie"].strip
        if cookies[:sUser] != saveH["Cookie"].strip || saveH["Cookie"] == nil
            puts "Kein Cookie."
            status_code = "303 OK"
            lock = "Location: http://127.0.0.1:8080/home"
        else 
            puts "Es is ok."
            status_code = '200 OK'
            lock = nil
            response_message = headInside('Overview',nickname) 
        end
    when ['GET', '/out']
        puts "Logout.."
        cookies[:sUser] = nil
        timeC = "max-age=-60" 
        status_code = '303 OK'
        lock = "Location: http://127.0.0.1:8080/home"
    end
    http_response = <<~MSG
    HTTP/1.1 #{status_code}
    Content-Type: text/html; charset=utf-8
    #{lock}
    Set-cookie: #{cookies[:sUser]};#{timeC}

    #{response_message}
    MSG
    client.puts(http_response)
    client.close
end
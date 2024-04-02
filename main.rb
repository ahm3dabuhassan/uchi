require 'socket'
require 'uri'
require 'net/http'
require './globalFunctions.rb'
require './html_templates/template.rb'
require 'json'

server = TCPServer.new(8080)

userData = {   
    :username => nil,
    :user_id => nil,
    :user_root_folder => nil,
    :allFolders => nil,
    :responseData => nil
}
loop do
    client = server.accept
    headers = {}
    request_line = client.readline
    method_token, target, version_number = request_line.split
    puts "\e[32mReceived a #{method_token} request to #{target} with #{version_number}\e[0m"
    case [method_token, target]
    when ['GET',target[/^\/home\/*[a-zA-Z0-9_]*/]] 
        if target[/[a-z_]+$/] == "error_p"
            response_message = home("Home", "Falsches Password")
        end
        status_code = "200 OK"
        content_type = "text/html; charset=utf-8"
        response_message = home("Home")
        response_message << implementJS("home.js")
    when ['POST', '/login']
        headers = {}
        while true do 
            line = client.readline
            break if line == "\r\n"
            header_name, value = line.split(": ")  
            headers[header_name] = value          
        end
        body = client.read(headers['Content-Length'].to_i)
        userData = URI.decode_www_form(body).to_h
        user = VerifyUser.new(userData["username"], userData["password"])
        userData = user.connect()
        if user.verify() == true
            status_code = "303 OK"
            content_type = "text/html; charset=utf-8"
            user_cookie_location = <<~STR 
                Set-Cookie: session_uid=#{userData["Id"]}_#{userData["Username"]};
                Location: /inside/#{userData["Username"]}
            STR
        else 
            status_code = "303 OK"
            user_cookie_location = <<~STR
                Location: /home/error_p
            STR
        end
    when ['GET', target[/^\/inside\/[a-z0-9]+/]]
        while true do 
            line = client.readline
            break if line == "\r\n"
            header_name, value = line.split(": ")  
            headers[header_name] = value          
        end
        if headers["Cookie"] == nil && headers["Cookie"] != "session_uid=#{userData["Id"]}_#{userData["Username"]}"
            puts "Keine Authorization."
            status_code = "303 OK"
            content_type = "text/html; charset=utf-8"
            user_cookie_location = "Location: /home"
        else 
            status_code = "200 OK"
            content_type = "text/html; charset=utf-8"
            Dir.chdir("/Users/ahmedabu-hassan/Desktop/uchi/Users")
            USER_ROOT_FOLDER = "/Users/ahmedabu-hassan/Desktop/uchi/Users"
            file_overview = FindAllFolders.new(USER_ROOT_FOLDER)
            userData[:allFolders] = file_overview.allDirectories
            present = Overview.new(file_overview.allDirectories, userData["Username"])
            userData[:username] = userData["Username"]
            user_cookie_location = ""
            response_message = headInside("Inside",target[/[a-zA-Z0-9]+$/])
            response_message << present.output
        end
    when ['GET', target[/^\/{1}open\-{1}(file|dir)\/{1}[a-zA-Z0-9\/\.\-]+/]]
        status_code = "200 OK"
        saveF =  target[/[a-zA-Z0-9]+\/{1}[a-zA-Z0-9]+\.{1}[a-zA-Z]{2,3}$/]
        counter = 0 
        response_message = headInside("Inside",userData[:username])
        for i in userData[:allFolders]["#{userData[:username]}"]
            if i[/[a-zA-Z0-9]+$/] == target[/[a-zA-Z0-9]+\.?[a-zA-Z]*$/] && target[/^\/{1}open\-{1}(dir|file)\/{1}/] == "/open-dir/"
                present = Overview.new(userData[:allFolders], userData[:username], counter)
                response_message << present.output
            elsif  target[/^\/{1}open\-{1}file\/{1}/] == "/open-file/" 
                #content_type = "content-type: image/jpg"
                saveF =  target[/[a-zA-Z0-9]+\/{1}[a-zA-Z0-9]+\.{1}[a-zA-Z]{2,3}$/]
                if i[/[a-zA-Z0-9]+$/] == saveF[/^[a-zA-Z0-9]+/] 
                    Dir.chdir(i)
                    filez = File.read("#{i}/#{target[/[a-zA-Z0-9]+\.{1}[a-zA-Z]{2,3}$/]}")
                    response_message = headInside("#{i[/[a-zA-Z0-9]+$/]}",userData[:username])
                    response_message << filez.to_s
                end
            end
            counter += 1
        end
    when ['GET', '/out']
        status_code = "303 OK"
        user_cookie_location = <<~STR
            Set-Cookie: session_uid=#{userData["Id"]}_#{userData["Username"]};Max-Age=0
            Location: /home
        STR
    when ['GET', target[/^\/{1}taskFile\/{1}(boot|move|rename|delete)\/{1}(file|directory)\/{1}[a-zA-Z0-9\/\.\-]+/]] # file/macboy/Folders.txt
        status_code = "200 OK"
        puts "TASK-FILE.."
        puts target
        userData[:responseData] = []
        saveDirectory =  target[/[a-zA-Z0-9\-\_]+\/{1}[a-zA-Z0-9\-\_]+\.?[a-zA-Z]{2,3}?$/]
        case [target[/(file|directory)/]]
        when ['file']
            puts "FILE:::..."
            userData[:allFolders][userData[:username]].each { |i|
            if i[/[a-zA-Z0-9]+$/] !=  saveDirectory[/^[a-zA-Z0-9\-\_]+/]
               userData[:responseData] << i
            end
            }
        when ['directory']
            puts "DIRECTORY:::..."
            userData[:allFolders][userData[:username]].each { |i|
            if i[/[a-zA-Z0-9]+$/] !=  saveDirectory[/^[a-zA-Z0-9\-\_]+/] && i[/[a-zA-Z0-9]+$/] !=  target[/[a-zA-Z0-9\-\_]+$/]
               userData[:responseData] << i
            end
            }
        end    
        puts userData[:responseData]
        response_message = userData[:responseData].to_json # JSON!!!
        
    end
    http_response = <<~MSG
    HTTP/1.1 #{status_code}
    Content-Type: #{content_type}
    #{user_cookie_location}

    #{response_message}
    MSG
    client.puts(http_response)
    client.close
end

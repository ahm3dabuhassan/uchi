require 'socket'
require 'uri'
require 'net/http'
require 'json'
require 'fileutils'
require 'base64'
require './globalFunctions.rb'
require './html_templates/template.rb'

home = `echo $HOME`
HOME = "/Users/ahmedabu-hassan/Desktop/uchi/Users"
server = TCPServer.new(8080)

userData = { 
    :username => nil,
    :user_id => nil,
    :user_root_folder => nil,
    :allFolders => nil, 
    :responseData => nil,
    :history => nil
}
result = {}
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
        puts "AA: #{userData}"
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
            Dir.chdir(HOME)
            USER_ROOT_FOLDER = "/Users/ahmedabu-hassan/Desktop/uchi/Users"
            file_overview = FindAllFolders.new(USER_ROOT_FOLDER)
            userData[:allFolders] = file_overview.allDirectories
            puts "ALL-FOLDERS:: #{userData[:allFolders]}"
            userData[:username] = userData["Username"]
            userData[:user_root_folder] = "#{USER_ROOT_FOLDER}/#{userData["Username"]}"
            present = Overview.new(file_overview.allDirectories, userData["Username"])
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
            elsif target[/^\/{1}open\-{1}file\/{1}/] == "/open-file/" 
                saveF =  target[/[a-zA-Z0-9]+\/{1}[a-zA-Z0-9]+\.?[a-zA-Z]{2,3}$/]
                if i[/[a-zA-Z0-9]+$/] == saveF[/^[a-zA-Z0-9]+/] 
                    Dir.chdir(i)
                    filez = File.read("#{i}/#{target[/[a-zA-Z0-9]+\.?[a-zA-Z]{2,3}$/]}")
                    #bash_command = ` cd /Users/ahmedabu-hassan/Desktop/uchi; echo "BASH_PWD:: ${PWD}"; chmod +x bash_commands.sh;` #`xxd #{target[/[a-zA-Z0-9]+\.{1}[a-zA-Z]{2,3}$/]} | head`
                    #puts bash_command
                    response_message = headInside("#{i[/[a-zA-Z0-9]+$/]}",userData[:username])
                    response_message << "<img src='data:image/jpg;base64,#{Base64.encode64(filez)}' width='400' height='500'>"
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
    when ['GET', target[/^\/{1}taskFile\/{1}(boot|move|rename|delete|mkdir)\/{1}(file|directory)\/{1}[a-zA-Z0-9\/\.\-\%\,\=:]+/]]
        saveTypeOfTasks = target[/(?<=\/{1}taskFile\/{1})(.*)(?=\/{1}directory|\/{1}file)/]
        status_code = "200 OK"
        case[target[/(?<=\/{1}taskFile\/{1})(.*)(?=\/{1}directory|\/{1}file)/]]
        when ['rename']
            puts "rename!"     
            Dir.chdir("#{HOME}/#{userData[:username]}#{target[/(?<=#{userData[:username]})(.*)(?=\/{1}[a-zA-Z\-\_]+\.?[a-zA-Z]{0,3}\={1}[a-zA-Z\-\_]+\.?[a-zA-Z]{0,3}$)/]}")
            File.rename("#{HOME}/#{userData[:username]}#{target[/(?<=#{userData[:username]})(.*)(?=\=)/]}", target[/(?<=\=)(.*)(?=$)/])   
            file_overview = FindAllFolders.new(USER_ROOT_FOLDER)
            userData[:allFolders] = file_overview.allDirectories
            response_message = "Der Name wurde von #{target[/(?<=#{userData[:username]}\/)(.*)(?=\=)/]} auf #{target[/(?<=\=)(.*)(?=$)/]} verändert".to_json
            yml_data = {:"#{saveTypeOfTasks}"=>{:target=>target[/(?<=#{userData[:username]}\/)(.*)(?=\=)/], :s=>target[/(?<=#{userData[:username]}\/)(.*)(?=\=)/], :d=>target[/(?<=\=)(.*)(?=$)/]}}
        when ['move']
            puts "move!"
            userData[:responseData] = {}
            userData[:allFolders][userData[:username]].each {|w|
               Dir.chdir(w)
               allFiles = Dir.glob("*")
               userData[:responseData][w] = [] 
               allFiles.each { |i|
               recognize = File.stat(i)
               if recognize.file?
                userData[:responseData][w] << "file-#{i}"
               elsif recognize.directory?
                userData[:responseData][w] << "dir-#{i}"
               end
            }    
            }
            response_message = userData[:responseData].to_json  
        when ['delete']
            puts "delete!"
            puts target
            yml_data = {:"#{saveTypeOfTasks}"=>{:target=>target[/(?<=\/file\/)[a-zA-Z0-9\/]+\.?[a-zA-Z0-9]+$/], :location=>Dir.getwd}}
        when ['mkdir']
            puts "mkdir.."
            MKDIR_LOCATION = target[/(?<=\/directory\/)(.*)(?=\=)/]
            # if not exists -> mkdir.
            #  present.update(userData[:allFolders][userData[:username]].index(n), headers['Referer'][/(?<=\/inside\/|\/open\-dir\/)(.*)(?=$)/].gsub(/\s/, ''))
            Dir.chdir("#{USER_ROOT_FOLDER}/#{target[/(?<=\/directory\/)(.*)(?=\=)/]}")
            Dir.mkdir("#{target[/[a-zA-Z0-9\_\-]+$/]}")
            yml_data = {:"#{saveTypeOfTasks}"=>{:target=>target[/[a-zA-Z0-9\_\-]+$/], :location=>MKDIR_LOCATION}}
            for i in userData[:allFolders][userData[:username]]
                i[/[a-zA-Z\-\_0-9]+$/] == MKDIR_LOCATION[/[a-zA-Z\-\_0-9]+$/] ? SAVE_INDEX = userData[:allFolders][userData[:username]].index(i) : false
            end
            file_overview = FindAllFolders.new(USER_ROOT_FOLDER)
            userData[:allFolders] = file_overview.allDirectories
            present = Overview.new(file_overview.allDirectories, userData[:username])
            present.update(SAVE_INDEX)
            response_message = present.output.to_json
        end
        if File.exist?("#{USER_ROOT_FOLDER}/#{userData[:username]}/history.yml") == false && target[/(?<=\/{1}taskFile\/{1})(.*)(?=\/{1}directory|\/{1}file)/] != 'move'
        userData[:history] = History.new(userData[:username], userData[:user_root_folder]).init('init', yml_data)
        elsif File.exist?("#{USER_ROOT_FOLDER}/#{userData[:username]}/history.yml") == true && target[/(?<=\/{1}taskFile\/{1})(.*)(?=\/{1}directory|\/{1}file)/] != 'move'
        userData[:history] = History.new(userData[:username], userData[:user_root_folder]).init('update', yml_data)
        end
    when ['POST', target[/^\/{1}taskFile\/{1}moved\/{1}[a-zA-Z0-9]+\/{1}$/]]
        puts "moved!"
        status_code = "200 OK"
        headers = {}
        while true do 
            line = client.readline
            break if line == "\r\n"
            header_name, value = line.split(": ")  
            headers[header_name] = value          
        end
        body = client.read(headers['Content-Length'].to_i)
        mv_file = JSON.parse(body)
        Dir.chdir("#{HOME}/#{mv_file["s"][/(?<=^)(.*)(?=\/[a-zA-Z0-9\_\-]+\.?[a-z0-9]{2,3}$)/]}")
        FileUtils.mv("#{HOME}/#{mv_file["s"]}", "#{HOME}/#{mv_file["d"]}")
        yml_data = {:"move"=>{:target=>mv_file["s"][/[a-zA-Z0-9]+.?[a-zA-Z0-9]+$/], :s=>"#{mv_file["s"]}", :d=>"#{mv_file["d"]}"}}
        if File.exist?("#{USER_ROOT_FOLDER}/#{userData[:username]}/history.yml") == false 
            userData[:history] = History.new(userData[:username], userData[:user_root_folder]).init('init', yml_data)
        elsif File.exist?("#{USER_ROOT_FOLDER}/#{userData[:username]}/history.yml") == true
            userData[:history] = History.new(userData[:username], userData[:user_root_folder]).init('update', yml_data)
        end
        file_overview = FindAllFolders.new(USER_ROOT_FOLDER)
        userData[:allFolders] = file_overview.allDirectories
        if headers['Referer'][/(?<=\/inside\/|\/open\-dir\/)(.*)(?=$)/].gsub(/\s/, '') == mv_file["s"][/(.*)(?=\/{1}[a-zA-Z0-9]+\.?[a-zA-Z0-9]{0,3})/] || headers['Referer'][/(?<=\/inside\/|\/open\-dir\/)(.*)(?=$)/].gsub(/\s/, '') == mv_file["d"]
            userData[:allFolders][userData[:username]].each { |n|
                if n[/(?<=Users\/)[a-zA-Z\/]+$/] == headers['Referer'][/(?<=\/inside\/|\/open\-dir\/)(.*)(?=$)/].gsub(/\s/, '') 
                    present = Overview.new(userData[:allFolders], userData[:username], 0)
                    present.data = userData[:allFolders]
                    present.update(userData[:allFolders][userData[:username]].index(n), headers['Referer'][/(?<=\/inside\/|\/open\-dir\/)(.*)(?=$)/].gsub(/\s/, ''))
                    response_message = present.output.to_json
                end
            }
        end
    when['GET', target[/\/{1}find\/{1}[a-zA-Z0-9\/\-\.]+/]]
       status_code = "200 OK"
       input = target[/(?<=\/{1}find\/{1})[a-zA-Z0-9\.]+$/]
       userData[:allFolders][userData[:username]].each { |i|
       begin   
        if Dir.chdir(i)
             finder_allFiles = Dir.glob("*")
             finder_allFiles.each { |f| 
             if f.include?(input)
                finder_typeOfFile = File.stat("#{Dir.getwd}/#{f}")
                if finder_typeOfFile.file?
                    bash_file_command = `file #{f} | cut -d" " -f 2`
                    result["f-#{bash_file_command}-#{f}"] = "#{i}/#{f}" 
                elsif finder_typeOfFile.directory?
                    result["d-#{i[/[a-zA-Z0-9]+$/]}/#{f}"] = "#{i}/#{f}" 
                end
             end    
            }
         end
     rescue 
         return false
     end
    }
       response_message = result.to_json
       result = {}
    when['GET', '/history']
        status_code = "200 OK"
        puts "HISTORY.."
        readYML = YAML.load_file("#{userData[:user_root_folder]}/history.yml")
        response_message = readYML.to_json
    when['GET', target[/^\/history\/?(return\-action\/(rename|move)\={1}\d+)?/]]
        status_code = "200 OK"
        userData[:history] = History.new(userData[:username], userData[:user_root_folder]).returnAction(target.gsub(/(\/history\/return-action\/)([a-z]+)\=(\d+$)/, '\2'), target.gsub(/(\/history\/return-action\/)([a-z]+)\=(\d+$)/, '\3'))
    when['GET', target[/\/{1}find\/{1}folder\-content\=[a-zA-Z\d]+\/([a-zA-Z\-\_\/\d]+)$/]]
        status_code = "200 OK"
        folder_content_response = {}
        folder_content_target = target.gsub(/\/{1}find\/{1}folder\-content\=[a-zA-Z\d]+\/([a-zA-Z\-\_\/\d]+)$/, '\1')
        Dir.chdir("#{userData[:user_root_folder]}/#{folder_content_target}")
        fct_all_files = Dir.glob("*")
        if fct_all_files.length > 0 
        folder_content_response['id'] = target[/(?<=\/{1}find\/{1}folder\-content\=).*$/]
        fct_all_files.each { |f|
            fctaf_type = File.stat("#{Dir.getwd}/#{f}")
            if fctaf_type.file? 
                folder_content_response["f-#{f}"] = f
            elsif fctaf_type.directory?
                folder_content_response["d-#{f}"] = f
            end
        }
        else
            folder_content_response["error"] = 'Directory is empty'
        end
        response_message = folder_content_response.to_json
    when['GET', target[/\/{1}project-data\/{1}[a-zA-Z]+\-{1}[a-zA-Z]+$/]]
        status_code = "200 OK" # /project-data/users
        puts 'PROJECT..'
        typeOfRequest = target[/(?<=\/{1}project-data\/{1})[a-zA-Z]+\-{1}[a-zA-Z]+$/]
        case [typeOfRequest]
            when['get-users']
                puts typeOfRequest              
                project_response_users = BuildProject.new('users').connect()
                puts project_response_users.to_json
                response_message = project_response_users.to_json
            when['read-project']
                puts typeOfRequest
        end
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


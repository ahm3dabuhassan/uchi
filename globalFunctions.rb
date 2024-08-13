require 'mysql'
require 'BCrypt'
require 'socket'
require 'yaml/store'

class VerifyUser 
    DB_Data = {
        :user => 'root', :password => 'Sh0-3_G4z-3', :host => 'localhost', :dbname => 'kino', :table_name => 'users'
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
        puts @response
        return @response

        rescue Mysql::Error => e 
            puts e.errno
            puts e.error
        end
    end
    def verify()    
        begin   
            if @@v[:verify] = BCrypt::Password.new(@response["Password"]) == @password
                return true
            else 
                puts "FALSCHES PASSWORD"
                return false
            end
        rescue 
            puts "FALSCHER USERNAME"
        end
    end
    attr :response
end

class FindAllFolders
    @@data = {
     :allFiles => nil,
     :allDir => {}
    }
    def initialize(patt)
         @pattern = patt
         @allDirectories = nil
         self.findFolders()
         self.addFolder()
    end
    def findFolders() 
        puts "find_folders: #{Dir.getwd}" 
         Dir.chdir("#{self.pattern}")
         @@data[:allFiles] = Dir.glob("*")
         @@data[:allFiles].each { |f|       
                 s = File.stat("#{self.pattern}/#{f}")
                 if s.directory? 
                     @@data[:allDir][f] = []
                     @@data[:allDir][f] <<  "#{self.pattern}/#{f}"
                 end 
         }
    end
    def addFolder(index=nil) 
        counter = 0
        @@data[:allDir].each { |key,value|
             if index != nil
                 for i in @@data[:allDir][key][index]
                     Dir.chdir("#{i}")
                     @@data[:allFiles] = Dir.glob("*")
                     @@data[:allFiles].each { |b|
                         s = File.stat("#{Dir.getwd}/#{b}")
                         if s.directory?
                             @@data[:allDir][key] <<  "#{Dir.getwd}/#{b}"
                         end
                     }
                     counter += 1
                 end
             else 
                 for i in @@data[:allDir][key]
                     Dir.chdir("#{i}")
                     @@data[:allFiles] = Dir.glob("*")
                     @@data[:allFiles].each { |b|
                         s = File.stat("#{Dir.getwd}/#{b}")
                         if s.directory?
                             @@data[:allDir][key] <<  "#{Dir.getwd}/#{b}"
                         end
                     }
                     counter += 1
             end             
             end    
            if @@data[:allDir][key][counter] != nil
                 self.addFolder(counter)
            else
                @allDirectories =  @@data[:allDir]
            end
         }
         puts "\e[32m#{@@data[:allDir]}\n\e[0m"
         Dir.chdir("#{@pattern}")
         File.open("Folders.txt","w") {
             |content| 
             @@data[:allDir].each { |key,value|
                 content.write("USER:#{key}:\n")
                 for i in value
                     stix = File.stat("#{i}")
                     content.write("\tDIRECTORIES: #{i}, SIZE: #{stix.size} Byte, TIME: #{stix.atime.strftime("%m/%d/%Y at %I:%M %p")}\n")
                 end
             }
         }
    end
  
     attr :pattern, true
     attr :allDirectories 
     
 end

 class Overview 
    @@stats = nil
    @@folder = nil
    @@forPath = nil
    @@wdP = nil
    def initialize(data,username,index=0)
        @data = data
        @user = username
        @index = index
        @output = nil
        self.init(@index)
    end
    def init(index) 
        @data.each { |k,v| 
            if k == @user  
                Dir.chdir("#{v[index]}")
                @output = <<~STR
                <div id="inside-message"><p></p></div>
                <div id="working-directory">
                <p style="color:orange;"><span class="material-symbols-outlined">
                folder_data
                </span>Working Directory:<p id="working-directory-path">./#{Dir.getwd[/(?<=\/uchi\/Users\/)[a-zA-Z0-9\/\-]+$/]}</p></p>
                </div>
                <div id="mkdir">
                    <span class="material-symbols-outlined">add</span>
                    <span class="material-symbols-outlined">folder</span>
                </div>
                <div id="history">
                <span class="material-symbols-outlined">history</span>
                <div id="history-trigger">
                    <p value="history">Show history</p>
                </div>
                </div>
                <div id="overview"> 
                    <table>
                        <thead>
                            <td class="inside-thead">Name:</td>
                            <td class="inside-thead">Path:</td>
                            <td class="inside-thead">Size:</td>
                            <td class="inside-thead">Time:</td>
                            <td class="inside-thead">Task:</td>
                        </thead>
            STR
                @@forPath = Dir.getwd
                @@folder = Dir.glob("*")
                @@folder.each { |f| 
                @@forPath = "#{@@forPath}"
                if f != 'history.yml' 
                @@stats = File.stat("#{f}")
                if @@stats.file?
                        @output << "<tr>"
                        @output <<  <<~STR 
                            <td><a class="overview-type-file" id="file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}" href="/open-file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                            description
                            </span>#{f}</a></td>
                            <td><p style="width:90%;">#{@@forPath[/(?<=\/uchi\/Users\/)[a-zA-Z0-9\/\-\.]+$/]}/<span style="color:#FF9933">#{f}</span></p></td>
                            <td>#{@@stats.size.to_i / 1024} kB</td>
                            <td>#{@@stats.atime.strftime("%F %H:%M:%S")}</td>
                            <td><div class="inside-action" id="file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                            rebase
                            </span></div></td>
                        STR
                    else 
                        @output << <<~STR
                            <td><a class="overview-type-directory" id="directory#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}" href="/open-dir#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                            folder
                            </span>#{f}</a></td>
                            <td><p style="width:90%;">#{@@forPath[/(?<=\/uchi\/Users\/)[a-zA-Z0-9\/\-\.]+$/]}/<span style="color:#FF9933">#{f}</span></p></td>
                            <td>#{@@stats.size.to_i / 1024} kB</td>
                            <td>#{@@stats.atime.strftime("%F %H:%M:%S")}</td>
                            <td><div class="inside-action" id="directory#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                            rebase
                            </span></div></td>
                        STR
                    end 
                end
                    @output << "</tr>"
                }
            @output << "</table></div>"
        end
        } 
        @output << implementJS('inside.js')
    end

    def update(index, directory=nil) 
        puts "VIEW_UPDATE:::"
        @data.each { |k, v| 
        if k == @user  
            Dir.chdir("#{v[index]}")
            @output = <<~STR
                <table>
                    <thead>
                        <td class="inside-thead">Name:</td>
                        <td class="inside-thead">Path:</td>
                        <td class="inside-thead">Size</td>
                        <td class="inside-thead">Time:</td>
                        <td class="inside-thead">Task:</td>
                    </thead>
        STR
            @@forPath = Dir.getwd
            @@folder = Dir.glob("*")
            @@folder.each { |f| 
            @@forPath = "#{@@forPath}"
            @@stats = File.stat("#{f}") 
            if @@stats.file?
                    @output << "<tr>"
                    @output <<  <<~STR 
                        <td><a class="overview-type-file" onclick="taskFile.build();" id="file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}" href="/open-file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                        description
                        </span>#{f}</a></td>
                        <td><p style="width:90%;">#{@@forPath}/<span style="color:#FF9933">#{f}</span></p></td>
                        <td>#{@@stats.size} Byte</td>
                        <td>#{@@stats.atime}</td>
                        <td><div class="inside-action" id="file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                        rebase
                        </span></div></td>
                    STR
                else 
                    @output << <<~STR
                        <td><a class="overview-type-directory" id="directory#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}" href="/open-dir#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                        folder
                        </span>#{f}</a></td>
                        <td><p style="width:90%;">#{@@forPath}/<span style="color:#FF9933">#{f}</span></p></td>
                        <td>#{@@stats.size / 1024} Byte</td>
                        <td>#{@@stats.atime.strftime("%m/%d/%Y at %I:%M %p")}</td>
                        <td><div class="inside-action" id="directory#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                        rebase
                        </span></div></td>
                    STR
                end 
                @output << "</tr>"
            }
        @output << "</table></div>"
    end
    } 
    end
    attr :output; true
    attr :data;
    attr :folder
    attr_writer :data
 end

class History 
    @@open_file = nil
    @@date = nil
    @@contentYML
    @@id = nil
    @@counter = 0
    def initialize(username, rootDirectory)
        @username, @rootDirectory = username, rootDirectory
    end
    def init(type, data)
        puts data
        puts type
        @@date = Time.now
        data[data.keys[0]][:date] = @@date.strftime("%m/%d/%Y at %I:%M %p")
        if type == 'init' 
            puts "history_init.."
            @@contentYML = "---\n:tasks:\n- :#{data.keys[0]}:\n"
            data[data.keys[0]].each { |key, value|
                if value != nil
                    @@contentYML << "   :#{key}: #{value}\n"
                end
            }
            File.open("#{@rootDirectory}/history.yml", 'w') do |content|
                content.write(@@contentYML) 
            end
        elsif type == 'update'
            puts "history_update.."
            @@open_file = YAML::Store.new("#{@rootDirectory}/history.yml")
            @@open_file.transaction do 
            @@open_file[:tasks] << data.transform_keys(&:to_sym)
            end
        end 
    end
    def returnAction(nameOfTask, id)
      @@open_file = YAML.load_file("#{@rootDirectory}/history.yml")
      if nameOfTask == 'rename'
        if @@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target][/(.*)(?=\/[a-zA-Z0-9]+\.[a-z0-9]{2,4})/] != ''
            Dir.chdir("#{@rootDirectory}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target][/(.*)(?=\/[a-zA-Z0-9]+\.[a-z0-9]{2,4})/]}")
            File.rename("#{Dir.getwd}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:d]}", "#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:s][/[a-zA-Z0-9]+\.?[a-z0-9]{2,4}$/]}")
        else 
            Dir.chdir(@rootDirectory)
            File.rename("#{Dir.getwd}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:d]}", "#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:s][/[a-zA-Z0-9]+\.?[a-z0-9]{2,4}$/]}")
        end
      elsif nameOfTask == 'move'
      puts "RETURN_MOVE"
      puts "#{Dir.getwd}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:d][/[a-zA-Z0-9]+\.?[a-z0-9]{2,4}$/]}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target]}"
      puts "TARGET"
      puts "#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target]}"
      puts "#{@rootDirectory[/(.*)(?=\/{1}[a-zA-Z0-9]+$)/]}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:d]}"
        if @@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target][/(.*)(?=\/[a-zA-Z0-9]+\.[a-z0-9]{2,4})/] != ''
            Dir.chdir("#{@rootDirectory[/(.*)(?=\/{1}[a-zA-Z0-9]+$)/]}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:d]}")
            FileUtils.mv("#{Dir.getwd}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target]}", "#{@rootDirectory[/(.*)(?=\/{1}[a-zA-Z0-9]+$)/]}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:s][/(.*)(?=\/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:s][/[a-zA-Z0-9]+\.?[a-z0-9]{2,4}$/]})/]}")
        else 
            Dir.chdir(@rootDirectory)
            FileUtils.mv("#{Dir.getwd}/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:target]}", "#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:s][/(.*)(?=\/#{@@open_file[:tasks][id.to_i][nameOfTask.to_sym][:s][/[a-zA-Z0-9]+\.?[a-z0-9]{2,4}$/]})/]}")
        end
      end 
      self.updateYML(id)
    end
    def updateYML(id)
        puts "updateYML: #{id}"
        puts @@open_file[:tasks][0]
        @@contentYML = "---\n#{@@open_file.keys.to_s[/(?<=^\[)(.*)(?=\]$)/]}:\n"
        for i in @@open_file[:tasks]
            if @@counter != id.to_i
                @@contentYML << "- #{i.keys.to_s[/(?<=^\[)(.*)(?=\]$)/]}:\n    :#{i[i.keys[0]].keys[0]}: #{i[i.keys[0]][i[i.keys[0]].keys[0]]}\n    :#{i[i.keys[0]].keys[1]}: #{i[i.keys[0]][i[i.keys[0]].keys[1]]}\n    :#{i[i.keys[0]].keys[2]}: #{i[i.keys[0]][i[i.keys[0]].keys[2]]}\n    :#{i[i.keys[0]].keys[3]}: #{i[i.keys[0]][i[i.keys[0]].keys[3]]}\n"
            end
            @@counter+=1
        end
        @@counter=0
        File.open("#{@rootDirectory}/history.yml","w") {
            |content|     
                content.write(@@contentYML)
        }
    end
end

 def implementJS(file)
    root_project = "/Users/ahmedabu-hassan/Desktop/uchi"
    out = ""
    Dir.chdir("#{root_project}")
    f = File.open("./js/#{file}")
        content = f.read
        out << "<script>"
        out << content
        out << "</script>"
    f.close
    return out
 end

 class FileView 
    @@shell_command = nil 
    @@open_file = nil
    @@file_data = {:directory => nil, :file => nil, :type => nil, :dimension => [], :img_output_dimensions => [], :size => nil, :date => nil} 
    @@output = nil

    def initialize(file, root)
        @file = file
        @root = root
    end

    def init()
        puts "FileView.go()"
        puts @file
        puts "CURRECT: #{Dir.getwd[/(?<=[a-zA-Z\/]\/Users\/)(.*)/]}"
        @@file_data[:directory] = @file[/^[a-zA-Z\-\_0-9]+/]
        @@file_data[:file] = @file[/[a-zA-Z\-\_0-9]+\.?[a-zA-Z0-9]{0,4}$/]
        @@file_data[:size] = File.stat(@@file_data[:file]).size.to_i / 1024
        @@file_data[:date] = File.stat(@@file_data[:file]).atime.strftime("%F %H:%M:%S")
        @@shell_command = `file #{@@file_data[:file]} | cut -d" " -f 3,18`
        @@file_data[:type] = @@shell_command[/^[a-zA-Z0-9\s]+/]
        puts "fileType: #{@@file_data[:type]}"
       if @@file_data[:type][/[a-zA-Z]+/] == 'text'
            puts "Text"
            self.presentFile(@@file_data[:type][/[a-zA-Z]+/])
       elsif @@file_data[:type][/[a-zA-Z]+/] == 'image'
            puts "Image"
            @@file_data[:dimension][0] =  @@file_data[:type][/(?<=image\s)\d+/].to_i
            @@file_data[:dimension][1] =  @@file_data[:type][/[0-9]+$/].to_i
            puts @@file_data[:dimension][0], @@file_data[:dimension][1]
            self.presentFile(@@file_data[:type][/[a-zA-Z]+/])
       end
      
    end

    def presentFile(type)
        @@open_file = File.read(@@file_data[:file])
        if type == 'text'
            puts "presentFile: #{type}"
        @@output = <<~STR
            <div id="present-file-parent">
                <a id="present-file-back-parentDirectory" href="/open-dir/#{Dir.getwd[/(?<=[a-zA-Z\/]\/Users\/)(.*)/]}"><span class="material-symbols-outlined">arrow_back_ios</span>Back</a>
                <h3><span class="material-symbols-outlined">table_eye</span>View File</h3>
                <div id="present-file-details">
                    <p class="present-file-details-p" id="present-file-parent-filename"><span class="material-symbols-outlined">font_download</span>File name: #{@@file_data[:file]}</p>
                    <p class="present-file-details-p" id="present-file-parent-dir"><span class="material-symbols-outlined">folder</span>Folder: #{@@file_data[:directory]}</p>

                    <p class="present-file-details-p" id="present-file-parent-format"><span class="material-symbols-outlined">folder</span>Format: #{@@file_data[:type]}</p>

                    <p class="present-file-details-p" id="present-file-parent-size"><span class="material-symbols-outlined">scale</span>Size: #{@@file_data[:size]} kB</p>
                    <p class="present-file-details-p" id="present-file-parent-time"><span class="material-symbols-outlined">date_range</span>Date: #{@@file_data[:date]}</p>
                    <p class="present-file-details-p" id="present-file-parent-download" value="/getFile/#{Dir.getwd[/(?<=[a-zA-Z\/]\/Users\/)(.*)/]}"><span class="material-symbols-outlined">download</span>Download</p>
                    </div>
                    <div id="present-file-text">
                        <p>#{@@open_file}</p>
                    </div>
            </div>
        STR

        else
            puts "presentFile: #{type}"
            puts @@file_data[:dimension][0], @@file_data[:dimension][1], @@file_data[:dimension][0].class, @@file_data[:dimension][1].class
            if @@file_data[:dimension][0] > @@file_data[:dimension][1] # H
                @@file_data[:img_output_dimensions][0] = 950
                @@file_data[:img_output_dimensions][1] = 550
            elsif @@file_data[:dimension][0] < @@file_data[:dimension][1] # W
                @@file_data[:img_output_dimensions][0] = 510
                @@file_data[:img_output_dimensions][1] = 600
            end
        @@output = <<~STR
            <div id="present-file-parent">
            <a id="present-file-back-parentDirectory" href="/open-dir/#{Dir.getwd[/(?<=[a-zA-Z\/]\/Users\/)(.*)/]}"><span class="material-symbols-outlined">arrow_back_ios</span>Back</a>
            <h3><span class="material-symbols-outlined">table_eye</span>View File</h3>
                <div id="present-file-details">
                    <p class="present-file-details-p" id="present-file-parent-filename"><span class="material-symbols-outlined">font_download</span>File name: #{@@file_data[:file]}</p>
                    <p class="present-file-details-p" id="present-file-parent-dir"><span class="material-symbols-outlined">folder</span>Folder: #{@@file_data[:directory]}</p>
                    <p class="present-file-details-p" id="present-file-parent-size"><span class="material-symbols-outlined">scale</span>Size: #{@@file_data[:size]} kB</p>
                    <p class="present-file-details-p" id="present-file-parent-time"><span class="material-symbols-outlined">date_range</span>Date: #{@@file_data[:date]}</p>
                    <p class="present-file-details-p" id="present-file-parent-download" value="/getFile/#{Dir.getwd[/(?<=[a-zA-Z\/]\/Users\/)(.*)/]}/#{@@file_data[:file]}"><span class="material-symbols-outlined">download</span>Download</p>
                </div>
                <img src='data:image/jpg;base64,#{Base64.encode64(@@open_file)}' width='#{@@file_data[:img_output_dimensions][0]}' height='#{@@file_data[:img_output_dimensions][1]}'>
            </div>
        STR
        end

        return @@output

    end

 end

 class BuildProject
    DATABASE = {
        :user => 'root', :password => 'Sh0-3_G4z-3', :host => 'localhost',:db_name => 'kino'
    }
    @@sql_request = {
        :con => nil, :res => nil, :com => nil
    }
    RANDOM_DATA_USER_PHOTO = "/Users/ahmedabu-hassan/desktop/uchi/Users/random_data/"
    def initialize(table, username)
        @table = table
        @username = username
        @response = []
    end

    def connect()
        begin
            @@sql_request[:con] = Mysql.connect("mysql://#{DATABASE[:user]}:#{DATABASE[:password]}@#{DATABASE[:host]}/#{DATABASE[:db_name]}")
            @@sql_request[:com] = "SELECT Id, Username, Firstname, Lastname, Email, image FROM #{@table} WHERE Username != '#{@username}'"
            @@sql_request[:res] = @@sql_request[:con].query(@@sql_request[:com])
            @response = @@sql_request[:res].to_a() 
            for i in  0..@response.length - 1
                readPhoto = File.read("#{RANDOM_DATA_USER_PHOTO}#{@response[i][5]}") 
                @response[i][5] = Base64.encode64(readPhoto)
            end
            return  @response 
        rescue Mysql::Error => e
            puts e.errno
            puts e.error
        end
    end
 end



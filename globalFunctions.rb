require 'mysql'
require 'BCrypt'
require 'socket'
require 'yaml/store'

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
                </span>Working Directory:<p id="working-directory-path">#{Dir.getwd}</p></p>
                </div>
                <div id="history">
                <span class="material-symbols-outlined">history</span>
                <div id="history-trigger">
                    <p>Show history</p>
                </div>
                </div>
                <div id="overview"> 
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
                            <td><a class="overview-type-file" id="file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}" href="/open-file#{v[index][/(?<=[a-zA-Z\/]\/{1}Users)(.*)(?=$)/]}/#{f}"><span class="material-symbols-outlined">
                            description
                            </span>#{f}</a></td>
                            <td><p style="width:90%;">#{@@forPath}/<span style="color:#FF9933">#{f}</span></p></td>
                            <td>#{@@stats.size} Bit</td>
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
                            <td>#{@@stats.size / 1024} Bit</td>
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
        @output << implementJS('inside.js')
    end

    def update(index, directory=nil) 
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
                        <td>#{@@stats.size} Bit</td>
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
                        <td>#{@@stats.size / 1024} Bit</td>
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
    attr_writer :data
 end

class History 
    @@open_file = nil
    @@date = nil
    @@contentYML
    def initialize(username, rootDirectory)
        @username, @rootDirectory = username, rootDirectory
    end
    def init(type, data)
        @@date = Time.now
        data[data.keys[0]][:date] = @@date.strftime("%m/%d/%Y at %I:%M %p")
        if type == 'init' 
            puts "history_init.."
            @@contentYML = "---\n:tasks:\n- :#{data.keys[0]}:\n"
            data[data.keys[0]].each { |key, value|
                if value != nil
                    @@contentYML << "  :#{key}: #{value}\n"
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


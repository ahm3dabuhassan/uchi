class Test
    @@Hello = "Boom"
    USERNAME = {
        :a => "Mac", :b => "H"
    }
    def initialize(par1,par2)
        @par1,@par2 = par1, par2
    end
    def show()
        puts USERNAME[:b]
    end
    attr :Hello 
end

v = Test.new("W","E")
puts v.Hello

#f = File.open("./test.js")
#content = f.read
    #puts content
#f.close

nu = 23 
def er (s) 
begin
erg = 18 + s
rescue => ex
    puts "Error, #{ex.message}"
    erg = 18 + s.to_i
    puts erg
end
end
er("23")
puts "Hello, User"
require 'timeout'
start_time = Time.now  - 120
puts start_time.strftime("%X")


class CompareString 
    @@counter = 0
    @@result = 0
    def initialize(s1,s2)
        @string01, @string02 = s1, s2
    end
    def go() 
        while @@counter < @string01.length do
            if @string01[@@counter] == @string02[@@counter]
                @@result += 1
            end
            @@counter += 1
        end
        if @@result == @string02.length
            return true
        else 
            return false
        end
    end
end

testString = CompareString.new("Hello","Hello").go()
puts testString

def set_interval(delay)
    Thread.new do
      loop do
        sleep delay
        yield # call passed block
      end
    end
  end
  t1 = Time.now; 
  t = set_interval(2.5) {puts Time.now - t1}

asx = ["Rio","Tokyo","Prague"]
for i in asx 
    sleep 2.5
    puts i
end
cvb = 0
while cvb < 60 do 
    sleep 1
    cvb +=1
    puts cvb
end
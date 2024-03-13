require 'socket'

server = TCPServer.new(8080)

loop do
    client = server.accept
    request_line = client.readline
    method_token, target, version_number = request_line.split
    puts "\e[32mReceived a #{method_token} request to #{target} with #{version_number}\e[0m"

    case [method_token, target]
    when ['GET','/home']
        status_code = '200 OK'
        response_message = 'Hello, Home.'
    end
    http_response = <<~MSG
    HTTP/1.1 #{status_code}
    Content-Type: text/html; charset=utf-8

    #{response_message}
    MSG
    client.puts(http_response)
    client.close
end
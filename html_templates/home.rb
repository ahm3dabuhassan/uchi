def head(titel) #Style?
    <<~STR
        <head>
            <title>#{titel}</title>
        </head>
    STR
end
def login()
    <<~STR
        <form action="/login" method="POST">
            <label for="username">Username:</label><input type="text" id="username" name="username">
            <label for="password">Password:</label><input type="password" id="password" name="password">
        </form>
    STR
end
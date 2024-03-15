def home(titel,error=nil) #Style?
    <<~STR
        <head>
            <title>#{titel}</title>
            <style>
                body {
                    font-family: futura; 
                    color: blue;
                }
                #login-main {
                    width:42%;
                    border:1px solid black;
                    padding: 1%;
                    border-radius: 5px;
                }
                #login-message {
                    font-size:11px;
                    font-family: monospace; 
                    color: red;
                }
                #login-main > form > label {
                    width: 35%; 
                    display: inline-block;
                    margin-right:1%;
                }
                #login-main > form > input[type="text"],input[type="password"] {
                    width: 62%; 
                    vertical-align: baseline;
                    display: inline-block;
                    margin-bottom: 4%;
                }
                #login-main > form > input[type="submit"] {
                    margin-top: 4%;
                }
                #login-message {
                    float: right;
                }
            </style>
        </head>
        <body>
        <h1>Wilkommen bei UCHI.</h1>
        <div id="login-main">
        <form action="/login" method="POST">
            <label for="username">Username:</label><input type="text" id="username" name="username">
            <label for="password">Password:</label><input type="password" id="password" name="password">
            <input type="submit" value="Einloggen">
            <input type="reset" value="Reset">
        </form>
        <p id="login-message">#{error}</p>
        </div>
        </body>
    STR
end
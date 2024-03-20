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
                    padding: 2%;
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
                #login-main > form > input[type="submit"], input[type="reset"]{
                    width:30%;
                    padding:2%;
                    margin-top: 4%;
                    border:0;
                    border-radius:2.5px;
                    background-color:blue;
                    color:white;
                    font-family:futura;
                    letter-spacing:2px
                }
                #login-message {
                    float: right;
                }
            </style>
        </head>
        <body>
        <h1>Willkommen bei .../.</h1>
        <div id="login-main">
        <form action="/login" method="POST"> 
            <label for="username">Username:</label><input type="text" id="username" class="home-form-input" name="username">
            <label for="password">Password:</label><input type="password" id="password" class="home-form-input" name="password">
            <input type="submit" value="Einloggen">
            <input type="reset" value="Reset">
        </form>
        <p id="login-message">#{error}</p>
        </div>
        </body>
    STR
end

def headInside(titel,nickname) 
    <<~STR
        <head>
            <title>#{titel}</title>
            <style>
            body {
                font-family: monospace;
                color:blue;
            }
            </style>
        </head>
    <body>  
    <header>
        <li>
            <ul><a href="/inside">Home</a></ul>
            <ul><a href="/out">Logout</a></ul>
        </li>
    </header>
    <body>
    <h1>Hello, #{nickname}.</h1>
    STR
end
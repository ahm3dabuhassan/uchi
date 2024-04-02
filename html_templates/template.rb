def home(titel,error=nil)
    <<~STR
        <head>
            <title>#{titel}</title>
            <style>
                body {
                    font-family: futura; 
                    color: blue;
                }
                h1 {
                    margin-left: 2%;
                }
                #login-main {
                    width:42%;
                    border:1px solid black;
                    padding: 2%;
                    border-radius: 5px;
                }
                #login-message {
                    margin-right: 2%;
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
                font-family: futura;
                color:blue;
            }
            h1{
                margin-left:1%;
            }
            header{
                border:1px solid #252525;
            }
            span {
                margin-right: 1%;
            }
            header > li > ul > a {
                width: 100px;
                heigth: 5vh;
                padding:2%;
                text-decoration:none;
                color:white;
                font-family:futura;
                background-color:blue;
            }
            li {
                display: flex;
                list-style-type:none;
            }
            #overview > table {
                width:100%;
                border: 1px solid #252525;
                border-radius: 5px;
            }
            #overview > table > tbody > tr > td {
                max-width:15%;
                border:1px solid white;
                border-radius: 0 0 12.5px 0; 
                border: 1px solid navy;
                padding:1%;
                font-family: monospace;
            }
            
            #overview > table > tbody > tr > td:first-of-type {
                width: 30%;
            }
            #overview > table > thead:first-of-type {
                height:2vh;
            }
            .inside-thead {
                width:50px;
                padding:1%;
                border-radius:2.5px;
                border: 1px solid blue;
                font-family:futura;
                font-size: 14px;
            }
            #overview > table > tbody > tr > td > a {
                display:flex;
                align-items: center;
                width:70%;
                font-size:12px;
                font-family: futura; 
                color:blue;
                text-decoration:none; 
            }
            .inside-action {
                display:flex;
                justify-content:center;
                width:90%;
                padding:2%;
                border:1px solid white;
                border-radius: 2.5px;
            }
            #working-directory{
                display:flex;
                align-items:baseline; 
            }
            #working-directory-path{
                font-size:12px;   
            }
            #working-directory > p{
                display: inline-block;
            }
            #working-directory > p:nth-of-type(1){
                display: inline-block;
                width:171px;
            }
            #working-directory > p:nth-of-type(2){
                display: inline-block;
                width:480px;
            }
            #inside-control-panel > div{
                margin-top:15%;
                width: 97%;
                border-radius:8px;
            }
            #inside-control-panel > div > p:nth-of-type(1){
              font-size:16px;
              font-weight:300;
              letter-spacing: 1.1px;
            }
            #inside-control-panel > div > p:nth-of-type(2){
                font-size:14px;
                letter-spacing: 1.1px;
                padding:2%;
                font-weigth:normal;
                color:#252525;
                background-color:#EDEDED;
                border-radius:4px;
                width:90%
            }
            #cancel {
                position:absolute;
                right:0; 
                margin-top: 4%;
                margin-right: 4%;
                margin-bottom: 30%;
                display: flex;
                justify-content: center;
                align-items: center;
                width:30px;
                height:30px;
                border-radius:50%;
                border:0;
                font-family:futura; 
                color:blue;
            }
            #inside-control-panel > div > select {
                width: 32%;
                height:3.4vh;
                padding:1%;
                font-family:futura;
                overflow: hidden;
                border: 1px solid orange; 
                border-radius:4px;
                background-color: white;

            }
            .insert-data {
                padding:1%;
                font-family:futura;
                border: 1px solid orange; 
                border-radius:4px;
                background-color: white;
            }
            #rename,#delete{
                width: 32%;
                height:3.4vh;
                padding:1%;
                font-family:futura;
                font-size:12px;
                border: 1px solid orange;
                background-color: white;
                border-radius: 4px;
                display: block;
                margin-bottom:1%;
                text-align:left;
            }
            #rename:hover {
                background-color: whitesmoke;
            }
            #delete:hover {
                background-color: whitesmoke;
            }
            </style>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
            </head>
    <body>  
    <header>
        <li>
            <ul><a href="/inside/#{nickname}">Home</a></ul>
            <ul><a href="/out">Logout</a></ul>
        </li>
    </header>
    <body>
    <h1>Hello, #{nickname}.</h1>
    STR
end
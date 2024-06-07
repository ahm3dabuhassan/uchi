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
                float:left;
                display:flex;
                align-items:baseline; 
                width: 55%;
                padding-left: 1%;
                padding-right: 1%;
                margin-bottom: 1%;
                border:1px solid #252525;
                border-radius: 0 20px 0 20px;
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
                background-color:white;
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
            #rename,#delete,#move{
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
            #move:hover {
                background-color: whitesmoke;
            }
            #rename-newValue:hover {
                background-color: whitesmoke;
            }
            #inside-move-overview {
                display:flex;
                align-items:center;
                width:40%;
            }
            #inside-move-overview > .material-symbols-outlined {
                font-size:34px;
            }
            .move-elements{
                display:flex;
                align-items:center;
                width:92%;
                border:1px solid whitesmoke;
                padding:1%;
                margin: 0 auto;
                margin-bottom: 5px;
            }
            .inside-move-overview-child-header{
                border-radius: 5px 5px 0 0;
                background-color:orange;
            }
            .inside-move-overview-child-header > p:nth-of-type(1){
                margin:0;
                padding:1.3%;
            }
            .empty-folder {
                width:92%;
                height: 11vh;
                display: flex;
                align-items:center;
                justify-content:center;
                margin: 0 auto;
                border: 1px solid whitesmoke;
            }
            #move-elements-button {
                position:absolute;
                right:33px;
                top:32px;
                heigth:38px;
                width:70px;
                border-radius:2.5px;
                border:2px solid whitesmoke;
                color:whitesmoke;
                background-color:blue;
                font-weight:bold;
            }
            #rename-newValue{
                float:left;
                border:2px solid green;
                height:3.4vh;
                width:35%;
                margin-left:1%;
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
            #rename-confirm{
                float:left;
                border:2px solid green;
                height:3.4vh;
                padding:1%;
                margin-left:1%;
                font-family:futura;
                font-size:12px;
                border: 1px solid orange;
                background-color: white;
                border-radius: 4px;
                margin-bottom:1%;
            }
            #header-finder-parent{
                float:right;
                display: flex;
                align-items: center;
                border: 1px solid #252525; 
                padding: 1%;
                display: flex; 
                height: 24px;
                border-radius: 0 0 20px 20px;
            }
            #header-finder-parent > label{
                margin-right:5px;
                font-size: 15px;
                letter-spacing: 2px;
                color:#252525;
            }
            #header-finder-parent > span{
                margin-right:5px;
                padding: 1.3%;
                border: 3px solid blue; 
                border-radius: 50%;
                color:#252525;
                box-shadow: 2px 2px 3px 1px rgb(60, 60, 60, 0.3);
            }
            .iconFolderCustomColor{
                color:yellowgreen;
            }
            .iconFileCustomColor{
                color:orange;
            }
            #finder-result-header{
                display:flex;
                justify-content: space-between;
            }
            #finder-result-header > h3{
                width:50%;
                padding:1%;
                margin:0;
                border:1px solid white;
                border-radius:5px;
            }
            .finder-result-a {
                text-decoration: none; 
                color:white; 
                font-family: futura; 
            }
            #history {
                display:flex;
                align-items:center;
                justify-content:center;
                float:right; 
                border: 1px solid #252525;
                border-radius: 0 20px;
                padding: 10px;
            }
            #history-trigger > p {
                font-size:11px;
            }
            #history > span {
                color:orange;
                margin-right:1%;
                font-size:28px;
            }
            .history-type-of-task {
                display:flex;
                align-items:center;
                padding: 1%;
                width:94%;
                margin: 0 auto;
                border:1px solid white;
                border-radius:0 0 10px; 
            }
            #history-list {
                position:absolute; 
                z-index:100; 
                right: 7px; 
                top: 200px;
                padding:1%;
                background-color: lightgray; 
                border-radius:20px 0 20px 20px;
                box-shadow: -10px 5px 2px 1px rgb(60, 60, 60, 0.1);
                color: #252525;
            }
            #history-list > div > button {
                width:70px;
                border:0;
                border-radius:5px;
                background-color:blue;
                font-size: 11px;
                color:white;
                font-family:futura;
                letter-spacing: 4px;
                margin-left:5%;
                margin-bottom:2%;
            }
            #history-list > div > p:nth-of-type(1) > span {
                color: green;
                margin-right: 3%;
                font-weight: bold;
            }
            #history-list > div > p:nth-of-type(1) {
                font-size: 14px;
                letter-spacing: 0.3px;
            }
            #history-list > div > p:nth-of-type(2) > span {
                color: red;
            }
            #history-list > div > p:nth-of-type {
                color: #252525;
            }
            </style>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
            </head>
    <body>  
    <header>
        <li>
            <ul><a href="/inside/#{nickname}">Home</a></ul>
            <ul><a href="#">Upload</a></ul>
            <ul><a href="/out">Logout</a></ul>
        </li>
        <div id="header-finder-parent">
            <span class="material-symbols-outlined">
            search
            </span>
            <label for="header-finder-input">Finder</label>
            <div><input type="text" id="header-finder-input"></div>
        </div>
    </header>
    <body>
    <h1>Hello, #{nickname}.</h1>
    STR
end
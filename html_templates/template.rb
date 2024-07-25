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
                border-radius: 0 20px;
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
                margin-top:10px;
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
                margin-bottom:1%;
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
            #finder-filter-header {
                width:100%;
                display:flex;
                justify-content:space-evenly;
                border: 1px solid white;
                border-radius:8px;
            }
            .finder-filter-buttons {
                margin:0;
            }
            .finderFilterButtonsIcons {
                font-size:21px;
            }
            .finder-filter-format{
                width:27px;
                border:1px solid yellowgreen;
                font-size: 9px;
                padding:2%;
                text-align: center; 
                border-radius: 4px;
                margin-left:5px;
                margin-top: 2px;
                margin-bottom:0;
                float:left;
            }
            #mkdir {
                float:left;
                display:flex;
                justify-content: center; 
                width:4%;
                height:7vh;
                align-items: center;
                padding-left:1%;
                padding-right:1%;
                margin-bottom:1%;
                margin-top:10px;
                margin-left:10px;
                border:1px solid #252525;
                border-radius:20px 20px 20px 0;
                color: blue;
            }
            #mkdir > span:nth-of-type(1){
                color: orange;
                font-weight:bold;
            }
            #mkdir > span:nth-of-type(2){
                font-weight: 500;
            }
            #history-header{
                font-family:futura;
                color:beige;
                margin-top:2px;
                margin-left:2px;

            }
            #mkdir-parent {
                position:absolute; 
                z-index:200;
                width:260px;
                height:30vh;
                padding:1%;
                background-color:white;
                top:200px;
                left:500px;
                border-radius:20px;   
                box-shadow: 2px 2px 3px 1px rgb(60, 60, 60, 0.3);
            }
            #mkdir-parent-header{
                font-size:15px;
                display: flex; 
                align-items:center;
                justify-content:center;
                color: #252525;
                background-color:whitesmoke;
                padding:1%;
                border-radius: 10px;
                height:4vh;
            }
            #mkdir-parent-header > span{
                color:blue;
                font-size:27px;
            }
            #mkdir-parent > label {
                margin:5px;  
                font-size: 12px; 
                color: #252525;
            }
            #mkdir-parent > button{
                width:45%;
                margin:5px;
                margin-top:18px;
                font-family:futura;
                font-size:12px;
                border:0; 
                border-radius:10px;
                background-color:whitesmoke;
            }    
            #mkdir-input {
                width:190px;
                margin-bottom:10px;
                font-family:futura;
                font-size:14px;
                letter-spacing:2;
            }    
            #mkdir-parent > button:nth-of-type(1) {
                display:block;
                float:left;
            }
            #mkdir-parent-wd{
                display:flex;
                justify-content:center;
                align-items:center; 
                margin-bottom:5px;
                border-radius: 10px;
                padding:1%;
                color:#252525;
                width:70%;
            }
            #mkdir-parent-wd{
                font-size:12px;
            }
            #mkdir-parent-wd > span{
               color:blue;
            }
            .finder-folder-content{
                display:flex;
                align-items:center;
                justify-content: center;
                width:120px;
                height:10px;
                font-size: 10px;
                margin-top:0.5%;
                border-left: 1px solid white;
                border-right: 1px solid white;
                border-bottom: 1px solid white;
            }
            .finder-result-showContent{
                width:20%;
                height:3vh;
                font-size:8px;
                background-color:black;
                border-radius:5px;
                display:flex;
                justify-content:center;
                margin-left:30px;
            }
            .finder-result-showContent > p{
                display:flex;
                align-items:center;
                font-size:11px;
            }
            .finder-result{
                position:relative;
                width:50%;
                margin-bottom:1%;
            }
            .finder-result > p:nth-of-type(1){
                font-size:14px;
                margin-left:30px;
            }
            .finder-result > p:nth-of-type(1){
                width:50%;
            }  
            .folder-content-list{
               margin-left:10%;
            }
            #folderContentListIcon{
                font-size: 14px;
                margin-right:2%;
            }
            .finder-result-showContent-header {
                background-color:#252525;
            }
            #show-content-icon{
                float:left;
            }
            #finder-typOfFormat-Parent{
                display:inline-block;
                width:50px;
                height: 6vh;
                padding:2%;
                margin-left: 2%;
                margin-top:4%;
                border:1px solid aqua;
                border-radius: 5px 0 0 5px;
                font-size:7px;
                writing-mode: vertical-rl;
            }
            .finder-typeOfFormat-types{
                width:22px;
                height: 4.5vh;
                border:1px solid red;
                border-radius:2.5px;
                text-align:center;
            }
            .history-parent-container{
                position:relative;
                width:100%;
                height:22vh;
                margin-bottom:3%;
                border:1px solid white;
                padding:1%;
                font-size:10px;
                font-family:futura;
            }
            .history-parent-container > button {
                position:absolute;
                bottom:5px;
            }
            #new-project-parent{
                width:100px;
                height:5vh;
                float:right;
                border-radius:0 0 20px 20px;         
                padding: 0.3%;
                margin-right:5px; 
                border-left:1px solid black;
                border-right:1px solid black;
                border-bottom:1px solid black;
                font-size: 14px;
                color:#252525;
            }
            #new-project-parent > input:nth-of-type(1){
                width:250px;
                height:3vh;
                margin-left:10px;
            }
            #new-project-parent > label{
                margin-left:5%;
            }
            #new-project-header {
                display:flex;
                justify-content:center; 
                align-items:center;
                font-size:14px; 
                color:#252525;
                margin-bottom:5%;
            }
            #new-project-header > span:nth-of-type(1){
                font-weight:bold;
                color:blue;
                margin-right:6px;
                margin-left:6px;
            }
            #new-project-header > p:nth-of-type(1){
                margin:0;
            }
            #new-project-main > label:nth-of-type(1){
                float:left;
                border:2px solid lightgrey; 
                border-radius:10px;
                margin-right:10px;
                align-self:center; 
                width:180px;
                text-align:center;
                padding:1%;
            }
            #project-input-parent{
                width:280px;
                height:2.2vh;
                padding:1%;
                display:flex;
                justify-content:center;
                align-items:center;
                border:2px solid lightgrey;
                border-radius:10px;
            }
            #project-input-parent > input{
                width:265px;
                height:3vh;
                font-size:16px;
                letter-spacing:1;
                font-weight:500;
                color:#252525;
            }
            #project-select-user-trigger{
                float:left;
                width:180px;
                padding:1%;
                margin:0;
                border:1px solid blue; 
                text-align:center;
                border:2px solid lightgrey;
                border-radius:10px;
            }
            #new-project-parent-header{
                width:100px;
                border-radius:10px;
                padding:1%;
                font-size:16px;
                font-weight:bold;
            }
            #new-project-parent-header > span{
               font-size:40px;
               color:blue;
            }
            #new-project-users-overview{
                float:left;
                width:600px;
                height:25vh;
                overflow:hidden;
                padding:2%;
                margin-left:10px;
                border:2px solid lightgrey;
                border-radius:10px;
            }
            #project-select-user-parent{
                margin-top:20px;
            }
            .new-project-user{
                margin-bottom:9px;
                font-size:11px;
                border:1px solid blue;
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
    <div id='new-project-parent'><div id='new-project-header'><span id='new-project-header-icon' class="material-symbols-outlined">new_window</span><p>Build Project</p></div><div id='new-project-main'></div></div>
    <h1>Hello, #{nickname}.</h1>
    STR
end
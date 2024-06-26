console.log("INSIDE ist da");

let taskFile = {
    source: null,
    positionRequest: null,
    y: null,
    x: null,
    controlPanel: {
        el: document.createElement('div'), 
        child: document.createElement('div'), 
        components:[document.createElement('button'),document.createElement('p'),document.createElement('p'),document.createElement('button'),document.createElement('button'),document.createElement('button')] 
    },
    fileID: null,
    typeOfTask: 'boot',
    typeOfResponse: 'text',
    directories: null, 
    index: null,
    amoutOfChildren: null,
    funk: null,
    username: null, 
    moveIdUpdate: null,
    folderStatus: null,
    regEx:{ 
        pattern: null,
        instance: null
    }, 
    updateTable:{  
        regExPattern: /[a-zA-Z0-9\-\_]+\.?[a-zA-Z0-9]{0,3}$/,
        aTag: null, 
        parentButton: null
    },
    makeNewDirectory: { 
        trigger: null, 
        wDir: null,
        nameOfDirectory: null,
        elements: []
    },
    message: document.getElementById('inside-message'),
    init: () => {
        this.source = document.querySelectorAll(".inside-action");
        for(let i=0; i<this.source.length; i++){
            this.source[i].addEventListener('click', taskFile.build);
        }
        new Finder().init();
        taskFile.makeNewDirectory.trigger = document.getElementById('mkdir');
        taskFile.makeNewDirectory.trigger.addEventListener('click', taskFile.mkdir);
    },
    connect: (typeOfTask, fileID, funk=null, headBody=null) => { 
        let checkRequest = `http://127.0.0.1:8080/taskFile/${typeOfTask}/${fileID}`;
        console.log(checkRequest);
        fetch(checkRequest, headBody) 
                    .then(response => { 
                        return response.json();
                    })
                    .then(response => {
                            taskFile.funk = funk(response);
                    })
                    .catch(err => {
                        console.log(err);
                    })    
    },
    build: (e) => {
        console.log('Build');
        this.fileID = e.target.getAttribute('id');
        taskFile.controlPanel.el.setAttribute('name', this.fileID);
        for(let i=0; i<this.source.length; i++){
            if(this.source[i].id == this.fileID){
                if(this.fileID.match(/^[a-zA-Z0-9]+/)[0] == 'file'){
                    taskFile.controlPanel.components[1].innerHTML = `Filename: ${this.fileID.match(/[a-zA-Z0-9\_\-]+\.?[a-zA-Z0-9]{2,3}?$/)[0]}`;
                }else{
                    taskFile.controlPanel.components[1].innerHTML = `Folder Name: ${this.fileID.match(/[a-zA-Z0-9\_\-]+\.?[a-zA-Z]{2,3}?$/)[0]}`;
                }
                taskFile.controlPanel.components[1].setAttribute('style','background-color:white;width:90%;padding:2%;border-radius:4px;font-family:helvetica'); 
                taskFile.controlPanel.components[2].innerHTML = 'Task:'    
                taskFile.controlPanel.components[3].innerHTML = 'Rename';
                taskFile.controlPanel.components[3].id = 'rename';
                taskFile.controlPanel.components[3].name = 'rename';
                taskFile.controlPanel.components[3].value = this.fileID;
                taskFile.controlPanel.components[4].innerHTML = 'Delete';
                taskFile.controlPanel.components[4].id = 'delete';
                taskFile.controlPanel.components[4].value = this.fileID;
                taskFile.controlPanel.components[5].innerHTML = 'Move to';
                taskFile.controlPanel.components[5].id = 'move';
                taskFile.controlPanel.components[5].value = this.fileID;
                taskFile.controlPanel.components[5].addEventListener('click',taskFile.move);
                taskFile.controlPanel.components[0].innerHTML = 'X';
                taskFile.controlPanel.components[0].id = 'cancel'; 
                taskFile.controlPanel.el.appendChild(taskFile.controlPanel.components[0]);
                taskFile.controlPanel.components[3].addEventListener('click', taskFile.rename);
                taskFile.controlPanel.components[4].addEventListener('click', taskFile.delete);
                taskFile.controlPanel.components[0].addEventListener('click', (e) => { taskFile.typeOfTask = 'boot';
                if(document.getElementById('rename-newValue') != null){
                    document.getElementById('rename-newValue').remove();
                    taskFile.controlPanel.components[taskFile.index].remove();
                    taskFile.controlPanel.components.splice(taskFile.controlPanel.components.length-2, 2);
                    e.target.parentElement.remove();
                }else{
                    e.target.parentElement.remove();
                }
                });           
                for(let i=1; i<taskFile.controlPanel.components.length; i++){
                    taskFile.controlPanel.child.appendChild(taskFile.controlPanel.components[i]);
                }
                taskFile.positionRequest = this.source[i].getBoundingClientRect();
                taskFile.y = taskFile.positionRequest.top;
                taskFile.x = taskFile.positionRequest.left;
                taskFile.controlPanel.el.id = "inside-control-panel";
                taskFile.controlPanel.el.setAttribute('style',`width:400px;padding-left:1%;padding-right:1.4%;padding-bottom:1%;background-color:blue;border-radius:16px;box-shadow: 5px 5px 2px 1px rgb(60, 60, 60, 0.1);position:absolute;left:${taskFile.x-460}px;top:${taskFile.y}px;`);
                taskFile.controlPanel.child.setAttribute('style','width:96%;height:100%;padding:3%;background-color:blue;border-style:dashed solid;border:1px solid whitesmoke;');
                taskFile.controlPanel.el.appendChild(taskFile.controlPanel.child);
                document.body.appendChild(taskFile.controlPanel.el);
                taskFile.index = taskFile.controlPanel.components.length;
            } 
        }
    },
    move: (e) => { 
        taskFile.typeOfTask = 'move';
        taskFile.index = taskFile.controlPanel.components.length;
        taskFile.controlPanel.components[taskFile.index] = document.createElement('div');
        taskFile.controlPanel.components[taskFile.index].setAttribute("style","width:80%;background-color:blue;border-radius:10px;padding:2%;position:absolute;z-index:100;color:white;left:7%;top:32%;box-shadow:5px 5px 5px rgba(0,0,0,0.5);");
        taskFile.controlPanel.components[taskFile.index].innerHTML = "<div id='inside-move-overview'><span class=\"material-symbols-outlined\">home_app_logo</span><p>Übersicht über Folders</p></div>";
        taskFile.moveIdUpdate = e.target.value.match(/(?:directory\/|file\/)(.*)(?=$)/)[1];
        taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'), (x) => {taskFile.insertData(taskFile.controlPanel.components[taskFile.index], x, taskFile.moveIdUpdate)}); //.2
        document.body.appendChild(taskFile.controlPanel.components[taskFile.index]);
    },
    rename: (e) => {
        if(e.target.name == 'rename'){
            taskFile.typeOfTask = 'rename';
            taskFile.controlPanel.components[3].name = 'cancel';
            taskFile.controlPanel.components[3].innerHTML = 'Cancel';
            taskFile.controlPanel.components[taskFile.index] = document.createElement('input');
            taskFile.controlPanel.components[taskFile.index].className = "insert-data";
            taskFile.controlPanel.components[taskFile.index].id = "rename-newValue";
            taskFile.controlPanel.components[taskFile.index].value = e.target.parentElement.parentElement.getAttribute('name').match(/[a-zA-Z0-9]+\.?[a-zA-Z0-9]{2,3}?$/)[0];
            e.target.parentElement.appendChild(taskFile.controlPanel.components[taskFile.index]);
            taskFile.controlPanel.components[3].setAttribute('style','float:left;');
            e.target.parentElement.insertBefore(taskFile.controlPanel.components[taskFile.index], taskFile.controlPanel.components[4]);
            taskFile.index++
            taskFile.controlPanel.components[taskFile.index] = document.createElement('button');
            taskFile.controlPanel.components[taskFile.index].innerHTML = 'Confirm';
            taskFile.controlPanel.components[taskFile.index].id = 'rename-confirm';
            taskFile.controlPanel.components[taskFile.index].value = this.fileID;
            taskFile.controlPanel.components[taskFile.index].addEventListener('click', (e)=> {   
                taskFile.updateTable.aTag = document.querySelector(`a[id="${e.target.value}"]`);
                taskFile.updateTable.aTag.id = taskFile.updateTable.aTag.id.replace(e.target.value.match(taskFile.updateTable.regExPattern)[0], taskFile.controlPanel.components[taskFile.index-1].value);
                taskFile.updateTable.aTag.href = taskFile.updateTable.aTag.href.replace(e.target.value.match(taskFile.updateTable.regExPattern)[0], taskFile.controlPanel.components[taskFile.index-1].value);
                taskFile.updateTable.aTag.innerHTML = taskFile.updateTable.aTag.innerHTML.replace(e.target.value.match(taskFile.updateTable.regExPattern), taskFile.controlPanel.components[taskFile.index-1].value);
                taskFile.updateTable.parentButton = document.querySelector(`div[id="${e.target.value}"]`);
                taskFile.updateTable.parentButton.id = taskFile.updateTable.parentButton.id.replace(e.target.value.match(taskFile.updateTable.regExPattern)[0], taskFile.controlPanel.components[taskFile.index-1].value);
                taskFile.connect(taskFile.typeOfTask,`${e.target.getAttribute('value')}=${taskFile.controlPanel.components[taskFile.index-1].value}`, (x) => { new Message('#inside-message', 'correct', x).go();});
                e.target.value = e.target.value.replace(e.target.value.match(taskFile.updateTable.regExPattern)[0], taskFile.controlPanel.components[taskFile.index-1].value);    
            });
            e.target.parentElement.insertBefore(taskFile.controlPanel.components[taskFile.index], taskFile.controlPanel.components[4]);
            taskFile.controlPanel.components[4].setAttribute('style','clear:both;');
        }else if(e.target.name == 'cancel'){
            taskFile.controlPanel.components[6].remove();
            taskFile.controlPanel.components[7].remove();
            taskFile.controlPanel.components[3].name = 'rename';
            taskFile.controlPanel.components[3].innerHTML = 'Rename';
            taskFile.controlPanel.components.splice(taskFile.controlPanel.components.length-2, 2);
            taskFile.index = taskFile.controlPanel.components.length;
        }
    },
    delete: (e) => {
        taskFile.typeOfTask = 'delete';
        taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'));
    },
    mkdir: () => {
       taskFile.typeOfTask = 'mkdir';
       taskFile.makeNewDirectory.wDir = document.getElementById('working-directory-path').innerHTML.match(/(?:\.\/)(.*)/)[1];
       taskFile.makeNewDirectory.elements[0] = document.createElement('div');
       taskFile.makeNewDirectory.elements[0].id = 'mkdir-parent';
       taskFile.makeNewDirectory.elements[1] = document.createElement('input');
       taskFile.makeNewDirectory.elements[1].id = 'mkdir-input';
       taskFile.makeNewDirectory.elements[2] = document.createElement('button'); 
       taskFile.makeNewDirectory.elements[2].innerHTML = 'Done';
       taskFile.makeNewDirectory.elements[2].id = 'mkdir-button-done';
       taskFile.makeNewDirectory.elements[3] = document.createElement('p'); 
       taskFile.makeNewDirectory.elements[3].innerHTML = '<span class="material-symbols-outlined">build</span>Make New Directory';
       taskFile.makeNewDirectory.elements[3].id = 'mkdir-parent-header';
       taskFile.makeNewDirectory.elements[4] = document.createElement('button'); 
       taskFile.makeNewDirectory.elements[4].innerHTML = 'Cancel';
       taskFile.makeNewDirectory.elements[4].id = 'mkdir-button-cancel';
       taskFile.makeNewDirectory.elements[4].addEventListener('click', (e) => {
            e.target.parentElement.remove();
            taskFile.makeNewDirectory.elements = [];
       });
       taskFile.makeNewDirectory.elements[5] = document.createElement('label');
       taskFile.makeNewDirectory.elements[5].innerHTML = 'Name:';
       taskFile.makeNewDirectory.elements[5].htmlFor = 'mkdir-input';
       taskFile.makeNewDirectory.elements[6] = document.createElement('p');
       taskFile.makeNewDirectory.elements[6].id = 'mkdir-parent-wd';
       taskFile.makeNewDirectory.elements[6].innerHTML = `<span class="material-symbols-outlined">folder_data</span>Parent Directory: ${taskFile.makeNewDirectory.wDir}`;
       taskFile.makeNewDirectory.elements[0].appendChild(taskFile.makeNewDirectory.elements[3]);
       taskFile.makeNewDirectory.elements[0].appendChild(taskFile.makeNewDirectory.elements[6]);
       taskFile.makeNewDirectory.elements[0].appendChild(taskFile.makeNewDirectory.elements[5]);
       taskFile.makeNewDirectory.elements[0].appendChild(taskFile.makeNewDirectory.elements[1]);
       taskFile.makeNewDirectory.elements[0].appendChild(taskFile.makeNewDirectory.elements[2]);
       taskFile.makeNewDirectory.elements[0].appendChild(taskFile.makeNewDirectory.elements[4]);
       document.body.appendChild(taskFile.makeNewDirectory.elements[0]);
       taskFile.makeNewDirectory.trigger = document.getElementById('mkdir-button-done');
       taskFile.makeNewDirectory.trigger.addEventListener('click', () => {
              console.log('MKDIR-DONE..');
              let catchNameOfDirectory = document.querySelector('#mkdir-input').value;
              console.log(catchNameOfDirectory);
              taskFile.connect(taskFile.typeOfTask, `directory/${taskFile.makeNewDirectory.wDir}=${catchNameOfDirectory}`);
       });
    },
    insertData: (target,content,id) => {
        console.log("INSERT-DATA");
        if(document.getElementById('rename-newValue')){
            document.getElementById('rename-newValue').remove();
            taskFile.controlPanel.components[3].name = 'rename';
            taskFile.controlPanel.components[3].innerHTML = 'Rename';
        }
        taskFile.username = document.cookie.match(/[a-zA-Z0-9]+$/);
        taskFile.regEx.pattern = `${taskFile.username}[a-zA-Z\/]*$`;
        taskFile.regEx.instance = new RegExp(taskFile.regEx.pattern, 'g');
        for(let key in content){
            taskFile.index++;
            taskFile.controlPanel.components[taskFile.index] = document.createElement('div');
            taskFile.controlPanel.components[taskFile.index].setAttribute('style','width:20%;min-height:20vh;border:1px solid white;border-radius:5px;font-size:12px;float:left;margin-right:5px;margin-bottom:5px;');
            taskFile.controlPanel.components[taskFile.index].innerHTML = `<div class="inside-move-overview-child-header"><p>PATH: <span style="font-size:10px;color:white;">${key.match(/Users\/{1}[a-zA-Z0-9\/\_]+$/)}</span></p></div><p>INHALT:</p>`;
            taskFile.controlPanel.components[taskFile.index].id = key.match(taskFile.regEx.pattern);  
            taskFile.controlPanel.components[taskFile.index].className = "move-directories";
            if(content[key].length != 0){
                for(let i=0; i<content[key].length; i++){ 
                    if(content[key][i].match(/^(file|dir)/)[0] == 'file'){
                        taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="move-elements" name="file" id="${key.match(taskFile.regEx.pattern)[0]}/${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z0-9]*$/)[0]}" draggable="true"><span class="material-symbols-outlined">article</span>Name: ${content[key][i].match(/[a-zA-Z0-9\_]+\.?[a-zA-Z0-9]{0,3}$/)[0]}</p>`;
                    }else if(content[key][i].match(/^(file|dir)/)[0] == 'dir'){
                        taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="move-elements" name="directory" id="${key.match(taskFile.regEx.pattern)}/${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}" draggable="true"><span class="material-symbols-outlined">folder</span>Name: ${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}</p>`;
                    } 
                }
            }else {
                taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="empty-folder"><span class="material-symbols-outlined">folder</span>Empty Folder</p>`;
            }
            taskFile.controlPanel.components[taskFile.index].innerHTML += `</div>`;
            target.appendChild(taskFile.controlPanel.components[taskFile.index]);
        }
        taskFile.controlPanel.components[++taskFile.index] = document.createElement('button');
        taskFile.controlPanel.components[taskFile.index].innerHTML = 'Cancel';
        taskFile.controlPanel.components[taskFile.index].id = 'move-elements-button'; 
        taskFile.controlPanel.components[taskFile.index].addEventListener('click', ()=> {   
        for(i=6; i<taskFile.controlPanel.components.length; i++){
            taskFile.controlPanel.components[i].remove();   
        }
        taskFile.controlPanel.components.splice(6,taskFile.controlPanel.components.length-1);
        taskFile.index = taskFile.controlPanel.components.length;
        }); 
        target.appendChild(taskFile.controlPanel.components[taskFile.index]);
        let checkElements = document.querySelectorAll('.move-elements');
        for(let i=0; i<checkElements.length; i++){
            checkElements[i].addEventListener('dragstart', taskFile.drag);
        }
        let assignEventToDirectories = document.querySelectorAll('.move-directories');
        for(let i=0; i<assignEventToDirectories.length; i++){
            assignEventToDirectories[i].addEventListener('drop', taskFile.drop);
            assignEventToDirectories[i].addEventListener('dragover', taskFile.allowDrop);
        }
        document.getElementById(id).parentElement.style.backgroundColor = "red";
    },
    drag: (e) => {
        let was = e.target.getAttribute('name');
        e.target.parentElement.children.length < 4 ? taskFile.folderStatus = e.target.parentElement.id : false;
        e.dataTransfer.setData('text', JSON.stringify({id:e.target.id,type:was}));
    },
    drop: (e) => {
        taskFile.typeOfTask = "moved"
        e.preventDefault();
        let data = JSON.parse(e.dataTransfer.getData("text"));
        if(e.currentTarget.id != data["id"]){
            taskFile.connect(taskFile.typeOfTask, `${data.type}/`, (x) => { document.querySelector('#overview').innerHTML = x;
            this.source = document.querySelectorAll(".inside-action");
                for(let i=0; i<this.source.length; i++){
                    this.source[i].addEventListener('click', taskFile.build);
                }
                taskFile.typeOfTask = 'boot';
             }, {headers:{
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: JSON.stringify({s:data.id,d:e.currentTarget.id})
        });
            e.currentTarget.appendChild(document.getElementById(data["id"]));
            let updateID = document.getElementById(data.id);
            updateID.id = `${e.currentTarget.id}/${data.id.match(/[a-zA-Z\-\_]+\.?[a-zA-Z0-9]{0,3}$/)}`;
            if(taskFile.folderStatus != null){
                taskFile.index = taskFile.index++;
                taskFile.controlPanel.components[taskFile.index] = document.createElement('p');
                taskFile.controlPanel.components[taskFile.index].className = "empty-folder";
                taskFile.controlPanel.components[taskFile.index].innerHTML = '<span class="material-symbols-outlined">folder</span>Empty Folder'; 
                document.querySelector(`div[id="${taskFile.folderStatus}"]`).appendChild(taskFile.controlPanel.components[taskFile.index]);
                taskFile.folderStatus = null;
            }
            e.currentTarget.children[2].className == 'empty-folder' ?  e.currentTarget.children[2].remove() : false;
            new Message('#inside-message', 'correct', `Datei/Verzeichnis unter dem Name <span style="font-weight:bold;">${data.id.match(/[a-zA-Z0-9\-\_]+\.?[a-zA-Z0-9]{0,3}$/)}</span> wurde erfolgreich nach <span style="font-weight:bold;">${e.currentTarget.id.match(/[a-zA-Z\-\_0-9]+$/)}</span> verschoben.`).go();
        }else{
            new Message('#inside-message', 'alert', `Du kannst dieses Verzeichnis unter dem Name <span style="font-weight:bold;">${data.id.match(/[a-zA-Z0-9\-]+$/)}</span> nicht verschieben.`).go();
        }
    },
    allowDrop: (e) => {
        e.preventDefault();
    }
}

class Message {
    #motion = {
        endPosition: 40,
        startPosition: -300,
        interval: null
    }
    constructor(id, type, response){ 
        this.targetElement = document.querySelector(id);
        this.type = type;
        this.content = response;
    }
    go(p){
        if(this.type == 'correct'){
            this.targetElement.innerHTML = `<span class="material-symbols-outlined" style="font-weight:bold;margin-right:3%;">check</span><p>${this.content}</p>`;
            this.targetElement.setAttribute('style', 'display:flex;align-items:center;width:400px;position:absolute;top:80px;right:-200px;color:yellowgreen;float:right;font-family:futura;border:2px solid yellowgreen;padding:1%;border-radius:5px;box-shadow:5px 5px 5px rgba(0,0,0,0.5);background-color:white;');
        }else if(this.type == 'alert'){
            this.targetElement.innerHTML = `<span class="material-symbols-outlined">warning</span>${this.content}`;
            this.targetElement.setAttribute('style', 'display:flex;align-items:center;width:400px;position:absolute;top:80px;right:-200px;color:red;float:right;font-family:futura;border:2px solid red;padding:1%;border-radius:5px;box-shadow:5px 5px 5px rgba(0,0,0,0.5);background-color:white;');
        }
        this.anim();
    }
    anim(){
        this.#motion.interval = setInterval(() => {
            if(this.#motion.startPosition <= this.#motion.endPosition){
                this.#motion.startPosition++
                this.targetElement.style.right = `${this.#motion.startPosition}px`;
            }else{
                clearInterval(this.#motion.interval);
                setTimeout(() => {this.targetElement.style.right = "-500px";}, 700);
            }

        }, 8);
    }
}

class Finder { 
       #host =  "http://127.0.0.1:8080/find";
       #response = null;
       #trigger = null;
       #overview = { 
            parent: document.createElement('div'),
            children: [],
            counter: 0,
            button: document.createElement('button'),
            cleaner: null,
            header: document.createElement('div'),
            typeOfFile: document.createElement('div'),
            typeOfFileChild: [],
            chosed: null
       };
       #selectType = {  
        counter: 0, 
        type: [],
        format: [],
        func: (newType) => {
                for(let i=0; i<this.#selectType.type.length; i++){
                    if(newType == this.#selectType.type[i]){
                        this.#selectType.counter++;
                    }
                }
            if(this.#selectType.counter == 0){
                this.#selectType.type.push(newType);
            }
            this.#selectType.counter = 0;
        }
        }
       go(parameter){
            fetch(`${this.#host}/${parameter}`)
            .then(response => {
                return response.json();
            })
            .then(response => {
                this.#response = response;
            })
            .catch(err => {
                console.log(err);
            })
       }
       init(){
            this.#trigger = document.getElementById('header-finder-input');
            this.#trigger.addEventListener('keyup', (e) => {
                if(this.#trigger.value != ''){
                    this.go(e.target.value);
                    this.build(e.target.value);
                }else{
                    this.#overview['parent'].remove();
                }
            });
       }
       build(p){
            this.#selectType.format = [];
            this.#overview.cleaner = document.querySelectorAll('.finder-result');
            if(this.#overview.cleaner.length > 0){
                for(let i=0; i<this.#overview.cleaner.length; i++){
                    this.#overview.cleaner[i].remove();
                }
            }
            this.#overview['header'].id = 'finder-result-header';
            this.#overview['header'].innerHTML = `<h3>Suche nach <span style='font-weight:bold;'>${p}:</span></h3>`;
            this.#overview['button'].innerHTML = 'Cancel';
            this.#overview['button'].setAttribute('style','width:70px;height:36px;border:0;padding:1%;font-family:futura;font-size:12px;color:black;background-color:white;border-radius:2.5px;color:black;letter-spacing:1px;');
            this.#overview['header'].appendChild(this.#overview['button']); 
            this.#overview['parent'].appendChild(this.#overview['header']);
            this.#overview['parent'].appendChild(this.#overview['typeOfFile']);
            this.#overview['typeOfFile'].setAttribute('style', 'width:115px;float:right;');
            this.#overview['typeOfFile'].innerHTML = '<p id="finder-filter-header"><span class="material-symbols-outlined">stacks</span>Filter:</p>';
            for(let key in this.#response){
                this.#overview['counter']++
                this.#overview['children'][this.#overview['counter']] = document.createElement('p');
                this.#overview['children'][this.#overview['counter']].className = 'finder-result';
                if(key.match(/^[a-z]/)[0] == 'f'){ 
                this.#selectType.format.includes(key.match(/(?:f\-)(.*)/)[1]) == false ? this.#selectType.format.push(key.match(/(?:f\-)(.*)/)[1]) : false;
                this.#overview['children'][this.#overview['counter']].innerHTML = `<span class="material-symbols-outlined iconFileCustomColor">text_snippet</span>Name: <a class="finder-result-a" href="/open-file/${document.cookie.match(/[a-zA-Z0-9]+$/)}/${this.#response[key].match(/(?:\/macboy\/)(.*)/)[1]}">${key.match(/(?:^f\-[a-zA-Z\s]+\-)(.*)/)[1]}</a><br> Path: ${this.#response[key].match(/(?:\/uchi\/Users\/)(.*)/)[1]}`;
                this.#overview['children'][this.#overview['counter']].id = `file-${key.match(/(?:f\-)(.*)/)[1]}`;
                this.#selectType.func('F');
                }else if(key.match(/^[a-z]/)[0] == 'd'){
                    this.#selectType.func('D');
                    this.#overview['children'][this.#overview['counter']].innerHTML = `<span class="material-symbols-outlined iconFolderCustomColor">folder_open</span>Name: <a class="finder-result-a" href="/open-dir/${document.cookie.match(/[a-zA-Z0-9]+$/)}/${this.#response[key].match(/(?:\/macboy\/)(.*)/)[1]}">${key.match(/[a-zA-Z0-9]+\.?[a-z0-9]{1,3}$/)[0]}</a><br> Path: ${this.#response[key].match(/(?:\/uchi\/Users\/)(.*)/)[1]}`;
                    this.#overview['children'][this.#overview['counter']].id = 'directory';
                }
                this.#overview['parent'].appendChild(this.#overview['children'][this.#overview['counter']]);
                console.log('FINDER-CATCH-FORMATS:::');
                console.log(this.#selectType.format);
            } 
            this.#overview['button'].addEventListener('click', () => {
                this.#overview['counter'] = 0;
                this.#overview['children'] = [];
                this.#overview['parent'].remove();
                this.#trigger.value = '';
            }); 
            this.#overview['parent'].setAttribute('style','width:81%;min-height:25vh;padding:2%;background-color:#262626;color:white;border-radius:0 17px 17px 0;');
            document.body.insertBefore(this.#overview['parent'], document.getElementById('working-directory')); 
            this.#overview['children'] = [];
            this.#overview['counter'] = 0;
            if(this.#overview['typeOfFileChild'].length > 0){
                for(let i=0; i<this.#overview['typeOfFileChild'].length; i++){
                   this.#overview['typeOfFileChild'][i].remove();
                }
                this.#overview['typeOfFileChild'] = [];
            }
            for(let i=0; i<this.#selectType.type.length; i++){ 
                this.#overview['typeOfFileChild'][i] = document.createElement('div');
                this.#overview['typeOfFileChild'][i].setAttribute('style', 'width:50px;height:50px;border:1px solid white;border-radius:5px;margin-left:5px;display:flex;flex-direction:column;align-items:center;float:left;');
                if(this.#selectType.type[i] == 'F'){
                    this.#overview['typeOfFileChild'][i].innerHTML = `<span class="material-symbols-outlined finderFilterButtonsIcons">text_snippet</span><p class="finder-filter-buttons">${this.#selectType.type[i]}</p>`;
                    this.#overview['typeOfFileChild'][i].id = `file`;
                }else{
                     this.#overview['typeOfFileChild'][i].innerHTML = `<span class="material-symbols-outlined finderFilterButtonsIcons">folder_open</span><p class="finder-filter-buttons">${this.#selectType.type[i]}</p>`
                     this.#overview['typeOfFileChild'][i].id = 'directory';
                }
                this.#overview['typeOfFileChild'][i].addEventListener('click', (e) => {
                    e.target.style.borderColor = 'red';
                    if(e.target.id != this.#overview['chosed']){
                        for(let i=0; i<this.#overview['parent'].children.length; i++){
                            if(this.#overview['parent'].children[i].id.match(/^[a-zA-Z]+/) != e.target.id && this.#overview['parent'].children[i].className == 'finder-result'){
                                this.#overview['parent'].children[i].style.display = 'none';
                            }
                        } 
                        this.#overview['chosed'] = e.target.id; 
                    }else{
                        e.target.style.borderColor = 'white';
                        for(let i=0; i<this.#overview['parent'].children.length; i++){
                            if(this.#overview['parent'].children[i].id != e.target.id && this.#overview['parent'].children[i].className == 'finder-result'){
                                this.#overview['parent'].children[i].style.display = 'block';
                            }
                        } 
                        let findTypeOfFilesButtons = document.querySelectorAll('.finder-filter-format'); 
                        if(findTypeOfFilesButtons.length > 0){
                            for(let c=0; c<=findTypeOfFilesButtons.length; c++){
                                findTypeOfFilesButtons[c].remove();
                            }
                        }
                        this.#overview['chosed'] = null;
                    }
                    if(this.#selectType.format.length > 0 && document.querySelectorAll('.finder-filter-format').length == 0){
                        let formatParent = document.createElement('p');
                        for(let i=0; i<this.#selectType.format.length; i++){
                            let formatChild = document.createElement('p');
                            formatChild.innerHTML = this.#selectType.format[i];
                            formatChild.value = this.#selectType.format[i];
                            formatChild.className = 'finder-filter-format';
                            formatParent.appendChild(formatChild);
                        }
                        this.#overview['typeOfFile'].appendChild(formatParent);
                        let assignEventTargets = document.querySelectorAll('.finder-filter-format');
                        for(let i=0; i<assignEventTargets.length; i++){
                            assignEventTargets[i].addEventListener('click', (e) => {
                                e.target.style.border = '1px solid red';
                                let testSelector = document.querySelector(`.finder-result#file-${e.target.innerHTML}`);
                                let allFindResult = document.querySelectorAll(`.finder-result`);
                                for(let i=0; i<allFindResult.length; i++){
                                    allFindResult[i].id != `file-${e.target.innerHTML}` ? allFindResult[i].style.display = 'none' : false
                                }
                                console.log(testSelector);
                            });
                        }
                    }
                });
                this.#overview['typeOfFile'].appendChild(this.#overview['typeOfFileChild'][i]);
            }
            this.#selectType.type = [];
        }
}

let history = { 
    trigger: null, 
    list: { 
        target: null, 
        out: '',
        parent: null,
        button: document.createElement('button'),
        returnButtons: null
    },
    data: null,
    request: (e) => {
        console.log('HISTORY-INIT-REQUEST..');
        console.log(e.target.getAttribute('value'));
            fetch(`/${e.target.getAttribute('value')}`)
            .then(response => {
                return response.json();
            })
            .then(response => {
                console.log(response)
                history.data = response;
                history.build();
            })
            .catch(err => {
                console.log(err);
            })
    }, 
    build: () => {
        console.log("history_build...");
        console.log(history.data['tasks']);
        history.list.target = document.getElementById('history');
        history.list.parent = document.createElement('div');
        history.list.button.innerHTML = "X";
        history.list.button.id = 'history-button-remove';
        history.list.button.setAttribute('style', 'float:left;width:25px;height:25px;border:0;border-radius:50%;margin-bottom:5px;margin-right:6px;');
        history.list.button.addEventListener('click', (e) => {e.target.parentElement.remove();  history.list.out = ''});
        history.list.parent.id = "history-list";
        history.list.out += '<p id="history-header">History <span style="color:blue;font-weight:bold;">:.</span></p>'
        for(let key in history.data['tasks']){
            for(let key2 in history.data['tasks'][key]){
                history.list.out += `<div id="${key}" style="width:100%;margin-bottom:3%;border:1px solid white;padding:1%;font-size:10px;font-family:futura;"><p class="history-type-of-task"><span class="material-symbols-outlined">task_alt</span>${key2}</p><p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">target</span> ${history.data['tasks'][key][key2]['target']}</p>`;
                history.list.out += `<p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">trending_flat</span>${history.data['tasks'][key][key2]['s']}</p><p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">stop</span> ${history.data['tasks'][key][key2]['d']}</p>`;
                history.list.out += `<p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">today</span>${history.data['tasks'][key][key2]['date']}</p>`;
                history.list.out += `<button class="history-button-return" id="${key}" value="history/return-action/${key2}=${key}">return</button>`;
                history.list.out += `</div>`;
            }
        }
        history.list.parent.innerHTML += history.list.out; 
        history.list.parent.insertBefore(history.list.button, history.list.parent.children[0]);
        document.body.appendChild(history.list.parent);
        history.list.returnButtons = document.getElementsByClassName('history-button-return');
        for(let i=0; i<history.list.returnButtons.length; i++){
            history.list.returnButtons[i].addEventListener('click', history.request);
            history.list.returnButtons[i].addEventListener('click', (e) => { e.target.parentElement.remove(); });
        }
    },
    init: () => {
        this.trigger = document.querySelector('#history-trigger > p');
        this.trigger.addEventListener('click', history.request);
    }
}

document.body.addEventListener('onload', taskFile.init());
history.init();



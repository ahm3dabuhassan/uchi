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
    folderContent: null,
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
        this.fileID = e.target.getAttribute('id');
        taskFile.controlPanel.el.setAttribute('name', this.fileID);
        for(let i=0; i<this.source.length; i++){
            if(this.source[i].id == this.fileID){
                if(this.fileID.match(/^[a-zA-Z0-9]+/)[0] == 'file'){
                    taskFile.controlPanel.components[1].innerHTML = `Filename: ${this.fileID.match(/[a-zA-Z0-9\_\-]+\.?[a-zA-Z0-9]{2,3}?$/)[0]}`;
                }else{
                    taskFile.controlPanel.components[1].innerHTML = `Folder Name: ${this.fileID.match(/[a-zA-Z0-9\_\-]+$/)[0]}`;
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
            console.log("RENAME");
            taskFile.typeOfTask = 'rename';
            taskFile.controlPanel.components[3].name = 'cancel';
            taskFile.controlPanel.components[3].innerHTML = 'Cancel';
            taskFile.controlPanel.components[taskFile.index] = document.createElement('input');
            taskFile.controlPanel.components[taskFile.index].className = "insert-data";
            taskFile.controlPanel.components[taskFile.index].id = "rename-newValue";
            taskFile.controlPanel.components[taskFile.index].value = e.target.parentElement.parentElement.getAttribute('name').match(/[a-zA-Z0-9\-\_]+\.?[a-zA-Z0-9]{2,3}?$/)[0];
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
       taskFile.makeNewDirectory.trigger.addEventListener('click', (e) => {
              let catchNameOfDirectory = document.querySelector('#mkdir-input').value;
              taskFile.connect(taskFile.typeOfTask, `directory/${taskFile.makeNewDirectory.wDir}=${catchNameOfDirectory}`, (x) => { 
               document.querySelector('#overview').innerHTML = x;
               this.source = document.querySelectorAll(".inside-action");
                    for(let i=0; i<this.source.length; i++){
                        this.source[i].addEventListener('click', taskFile.build);
                    }
                    taskFile.typeOfTask = 'boot';
                });
                e.target.parentElement.remove();
       });
    },
    insertData: (target,content,id) => {
        taskFile.folderContent = content; 
        if(document.getElementById('rename-newValue')){
            document.getElementById('rename-newValue').remove();
            taskFile.controlPanel.components[3].name = 'rename';
            taskFile.controlPanel.components[3].innerHTML = 'Rename';
        }
        taskFile.username = document.cookie.match(/[a-zA-Z0-9]+$/);
        taskFile.regEx.pattern = `${taskFile.username}[a-zA-Z\/\_\-]*$`;
        taskFile.regEx.instance = new RegExp(taskFile.regEx.pattern, 'g');
        for(let key in content){
            taskFile.index++;
            taskFile.controlPanel.components[taskFile.index] = document.createElement('div');
            taskFile.controlPanel.components[taskFile.index].setAttribute('style','width:20%;min-height:35vh;border:1px solid white;border-radius:5px;font-size:12px;float:left;margin-right:5px;margin-bottom:5px;');
            taskFile.controlPanel.components[taskFile.index].innerHTML = `<div class="inside-move-overview-child-header"><p>Path: <span style="font-size:10px;color:white;">${key.match(/(?:Users\/)([a-zA-Z0-9\/\_]+)$/)[1]}</span></p></div><p>Content:</p>`;
            taskFile.controlPanel.components[taskFile.index].id = key.match(taskFile.regEx.pattern);  
            taskFile.controlPanel.components[taskFile.index].className = "move-directories";
            let bedingung = null;
            if(content[key].length > 0){ 
                for(let i=0; i<content[key].length; i++){  
                    console.log(content[key][i]);
                    if(i > 5){
                       // taskFile.controlPanel.components[taskFile.index].innerHTML += `<button class='folder-slider' id='${key.match(/(?:^.*\/{1}Users\/{1})(.*)$/)[1]}'>More</button>`;
                        break;
                    }  
                    if(content[key][i].match(/^(file|dir)/)[0] == 'file' && content[key][i] != "file-history.yml"){
                        taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="move-elements" name="file" id="${key.match(taskFile.regEx.pattern)[0]}/${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z0-9]*$/)[0]}" draggable="true"><span class="material-symbols-outlined">article</span>Name: ${content[key][i].match(/[a-zA-Z0-9\_]+\.?[a-zA-Z0-9]{0,3}$/)[0]}</p>`;
                    }else if(content[key][i].match(/^(file|dir)/)[0] == 'dir'){
                        taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="move-elements" name="directory" id="${key.match(taskFile.regEx.pattern)}/${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}" draggable="true"><span class="material-symbols-outlined">folder</span>Name: ${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}</p>`;
                    }  
              }
            }else{
                taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="empty-folder"><span class="material-symbols-outlined">folder</span>Empty Folder</p>`;
            }
            taskFile.controlPanel.components[taskFile.index].innerHTML += `</div>`;
            target.appendChild(taskFile.controlPanel.components[taskFile.index]);
        }
      //  taskFile.windows[id] = {index:4, l:taskFile.folderContent[`${Object.keys(taskFile.folderContent)[0].match(/^.*Users\//)[0]}${id}`].length} 
        let scrollButtons = document.querySelectorAll('.folder-slider');
        for(let i=0; i<scrollButtons.length; i++){ 
            scrollButtons[i].addEventListener('click', (e) => {console.log(content[e.target.getAttribute('id')]); taskFile.windowScroll(e.target.getAttribute('id'));});
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
    windows: {},
    windowScroll: (id) => { // Nachfrage zum Object, 
        console.log("WINDOWSCROLL.."); 
        console.log(Object.keys(taskFile.folderContent)[0].match(/^.*Users\//)[0]);
        console.log(id);
        console.log(taskFile.windows[id]);
        console.log(`${Object.keys(taskFile.folderContent)[0].match(/^.*Users\//)[0]}${id}`);
        console.log(taskFile.folderContent[`${Object.keys(taskFile.folderContent)[0].match(/^.*Users\//)[0]}${id}`]);
        let endLoop = null;
        switch(true){
            case taskFile.windows[id].index == 4: 
                console.log("SWITCH-EQUAL::");
                endLoop = taskFile.windows[id].index + 4;
            break;
            case taskFile.windows[id].index < taskFile.windows[id].l &&  taskFile.windows[id].index + 4 <=  taskFile.windows[id].l:
                console.log("SWITCH-LESS::");
                taskFile.windows[id].index += 4;
                endLoop = taskFile.windows[id].index + 4;
            break;
            default: 
                console.log("SWITCH-DEFAULT::");
                taskFile.windows[id].index = taskFile.windows[id].index - taskFile.windows[id].l;
                endLoop = taskFile.windows[id].l;
        }
        for(let i=taskFile.windows[id].index; i<endLoop; i++){
            console.log(taskFile.folderContent[`${Object.keys(taskFile.folderContent)[0].match(/^.*Users\//)[0]}${id}`][i]);
        }
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
       #func = null;
       #overview = { 
            parent: document.createElement('div'),
            children: [],
            counter: 0,
            button: document.createElement('button'),
            cleaner: null,
            header: document.createElement('div'),
            typeOfFile: document.createElement('div'),
            typeOfFileChild: [],
            chosen: null,
       };
       #selectType = {   
        counter: 0, 
        type: [],
        format: [],
        selectedButton: null,
        chosen: null,
        fileFormatChosed: null,
        formats: [], 
        elementsOfFormatsParent: null, 
        elementsOfFormatsChild: null,
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
        };
       #requestFolderContent = { 
            element: null,
            dataOutput: null,
            data: null,
            target:null,
            status: true,
            counter:0,
            elements:{},
            event: (id) => { 
                this.#requestFolderContent.counter = 0;
                if(!this.#requestFolderContent.elements[id]){
                    this.#requestFolderContent.elements[id] = []; 
                    this.#requestFolderContent.target.setAttribute('style', 'display:block;width:46%;height:fit-content;padding:1.2%;border:1.3px solid aqua;');
                    for(let key in this.#requestFolderContent.data){
                        if(key != 'id'){
                        this.#requestFolderContent.elements[id][this.#requestFolderContent.counter] = document.createElement('p');      
                        if(key.match(/[d-f]/)[0] == 'd'){
                            this.#requestFolderContent.elements[id][this.#requestFolderContent.counter].innerHTML = '<span class="material-symbols-outlined folderContentListIcon" id="folderContentListIcon">folder</span>';      
                        }else if (key.match(/[d-f]/)[0] == 'f'){
                            this.#requestFolderContent.elements[id][this.#requestFolderContent.counter].innerHTML = '<span class="material-symbols-outlined" id="folderContentListIcon">description</span>';
                        }else {
                            this.#requestFolderContent.elements[id][this.#requestFolderContent.counter].innerHTML = '<span class="material-symbols-outlined">error</span>';
                            this.#requestFolderContent.elements[id][this.#requestFolderContent.counter].style.color = 'red';
                        }
                        this.#requestFolderContent.elements[id][this.#requestFolderContent.counter].innerHTML += `${this.#requestFolderContent.data[key]}`;
                        this.#requestFolderContent.elements[id][this.#requestFolderContent.counter].className = 'folder-content-list';
                        this.#requestFolderContent.target.appendChild(this.#requestFolderContent.elements[id][this.#requestFolderContent.counter]);
                        this.#requestFolderContent.counter++;
                    }
                    }
                    this.#requestFolderContent.counter.status = false;
                }else if(this.#requestFolderContent.elements[id]){
                    for(let i=0; i<this.#requestFolderContent.elements[id].length; i++){
                        this.#requestFolderContent.elements[id][i].remove();
                    }  
                    delete this.#requestFolderContent.elements[id]; 
                    this.#requestFolderContent.target.children[0].innerHTML = 'keyboard_arrow_down';
                    this.#requestFolderContent.target.children[1].innerHTML = 'Show Content';
                    this.#requestFolderContent.target.setAttribute('style', 'width:18%;height:3vh;font-size:8px;background-color:black;border-radius:5px;display:flex;justify-content:center;margin-left:30px;');
                }
            }
       }
       go(parameter,func=null){
            fetch(`${this.#host}/${parameter}`)
            .then(response => {
                return response.json();
            })
            .then(response => {
                this.#response = response;
                this.#func = func(response);
            })
            .catch(err => {
                console.log(err);
            })
       }
       init(){
            this.#trigger = document.getElementById('header-finder-input');
            this.#trigger.addEventListener('keyup', (e) => {
                if(this.#trigger.value != ''){
                    this.go(e.target.value, (x) => {console.log(x);});
                    this.build(e.target.value);
                }else{
                    this.#overview['parent'].remove();
                    this.#selectType.elementsOfFormatsParent = null;
                }
                this.#requestFolderContent.elements = {};
            });
       }
       build(p){
            this.#selectType.format = [];
            this.#overview['children'] = [];
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
            this.#overview['typeOfFile'].id = 'finder-filter-parent';
            this.#overview['typeOfFile'].setAttribute('style', 'width:115px;float:right;');
            this.#overview['typeOfFile'].innerHTML = '<p id="finder-filter-header"><span class="material-symbols-outlined">stacks</span>Filter:</p>';
            for(let key in this.#response){
                this.#overview['counter']++
                this.#overview['children'][this.#overview['counter']] = document.createElement('div');
                this.#overview['children'][this.#overview['counter']].className = 'finder-result';
                if(key.match(/^[a-z]/)[0] == 'f'){ 
                this.#selectType.format.includes(key.match(/(?:f\-)(.*)/)[1]) == false ? this.#selectType.format.push(key.match(/(?:f\-)(.*)/)[1]) : false;
                this.#overview['children'][this.#overview['counter']].innerHTML = `<span class="material-symbols-outlined iconFileCustomColor">text_snippet</span>Name: <a class="finder-result-a" href="/open-file/${document.cookie.match(/[a-zA-Z0-9]+$/)}/${this.#response[key].match(/(?:\/macboy\/)(.*)/)[1]}">${key.match(/(?:^f\-[a-zA-Z\s]+\-)(.*)$/)[1]}</a><br><p>Path: <span style='font-size:12px;'>${this.#response[key].match(/(?:\/uchi\/Users\/)(.*)/)[1]}</span></p>`;
                this.#overview['children'][this.#overview['counter']].id = `file-${key.match(/(?:f\-)(.*)/)[1]}`;
                this.#selectType.func('F');
                }else if(key.match(/^[a-z]/)[0] == 'd'){
                    this.#selectType.func('D');
                    this.#overview['children'][this.#overview['counter']].innerHTML = `<span class="material-symbols-outlined iconFolderCustomColor">folder_open</span>Name: <a class="finder-result-a" href="/open-dir/${document.cookie.match(/[a-zA-Z0-9]+$/)}/${this.#response[key].match(/(?:\/macboy\/)(.*)/)[1]}">${key.match(/[a-zA-Z0-9]+\.?[a-z0-9]{1,3}$/)[0]}</a><p>Path: <span style='font-size:12px;'>${this.#response[key].match(/(?:\/uchi\/Users\/)(.*)/)[1]}</p>`;
                    this.#overview['children'][this.#overview['counter']].id = 'directory';
                    this.#requestFolderContent.element = document.createElement('div');
                    this.#requestFolderContent.element.className = 'finder-result-showContent';
                    this.#requestFolderContent.element.id = `${this.#response[key].match(/(?:\/uchi\/Users\/)(.*)$/)[1]}`;
                    this.#requestFolderContent.element.innerHTML = '<span class="material-symbols-outlined" id="show-content-icon">keyboard_arrow_down</span><p class="finder-result-showContent-header">Show Content</p>';
                    this.#requestFolderContent.element.addEventListener('click', (e) => {
                        if(!this.#requestFolderContent.elements[e.target.parentElement.id]){
                            this.go(`folder-content=${e.target.parentElement.id}`, (x) => {
                                this.#requestFolderContent.target = document.getElementById(e.target.parentElement.id);
                                this.#requestFolderContent.target.children[0].innerHTML = 'close';
                                this.#requestFolderContent.target.children[0].style.backgroundColor = '#252525';
                                this.#requestFolderContent.target.children[0].style.margin = 0;
                                this.#requestFolderContent.target.children[1].innerHTML = 'Hide Content';
                                this.#requestFolderContent.target.children[1].setAttribute('style', 'height:2vh;margin:0;padding:1%;');
                                this.#requestFolderContent.data = x;
                                this.#requestFolderContent.event(e.target.parentElement.id);
                            });
                          
                        }else{
                            this.#requestFolderContent.target = document.getElementById(e.target.parentElement.id);
                            this.#requestFolderContent.event(e.target.parentElement.id);
                            this.#requestFolderContent.target.children[0].style.backgroundColor = 'black';
                            this.#requestFolderContent.target.children[1].setAttribute('style', 'display:flex;align-items:center;font-size:11px;background-color:#252525;');
                        }
                    });
                    this.#overview['children'][this.#overview['counter']].appendChild(this.#requestFolderContent.element);
                }
                this.#overview['parent'].appendChild(this.#overview['children'][this.#overview['counter']]);
            } 
            this.#overview['button'].addEventListener('click', () => {
                this.#overview['counter'] = 0;
                this.#overview['children'] = [];
                this.#overview['parent'].remove();
                this.#trigger.value = '';
                this.#selectType.elementsOfFormatsParent.remove();
                this.#selectType.elementsOfFormatsParent = null;
                this.#requestFolderContent.elements = {};
            }); 
            this.#overview['parent'].setAttribute('style','width:81%;min-height:25vh;padding:2%;background-color:#262626;color:white;border-radius:0 17px 17px 0;');
            if(document.getElementById('working-directory')){
                document.body.insertBefore(this.#overview['parent'], document.getElementById('working-directory')); 
            }else if(document.getElementById('present-file-parent')){
                document.body.insertBefore(this.#overview['parent'], document.getElementById('present-file-parent'));
            }
            
            this.#overview['counter'] = 0;
            if(this.#overview['typeOfFileChild'].length > 0){
                for(let i=0; i<this.#overview['typeOfFileChild'].length; i++){
                   this.#overview['typeOfFileChild'][i].remove();
                }
                this.#overview['typeOfFileChild'] = [];
            }
            for(let i=0; i<this.#selectType.type.length; i++){ 
                this.#overview['typeOfFileChild'][i] = document.createElement('div');
                this.#overview['typeOfFileChild'][i].setAttribute('style', 'width:50px;height:50px;border:1px solid white;border-radius:5px;margin-left:5px;margin-bottom:5px;display:flex;flex-direction:column;align-items:center;float:left;');
                if(this.#selectType.type[i] == 'F'){
                    this.#overview['typeOfFileChild'][i].innerHTML = `<span id='file' class="material-symbols-outlined finderFilterButtonsIcons">text_snippet</span>${this.#selectType.type[i]}`;
                    this.#overview['typeOfFileChild'][i].id = `file`;
                }else{
                    this.#overview['typeOfFileChild'][i].innerHTML = `<span id='directory' class="material-symbols-outlined finderFilterButtonsIcons">folder_open</span>${this.#selectType.type[i]}`;
                    this.#overview['typeOfFileChild'][i].id = 'directory';
                }
                this.#overview['typeOfFileChild'][i].addEventListener('click', (e) => {
                this.#selectType.selectedButton = document.getElementById(e.target.id.match(/(file|directory)/)[0]);
                if(this.#selectType.chosen == null){
                    this.#selectType.chosen = e.target.id.match(/(file|directory)/)[0];
                    for(let i=1; i<this.#overview['children'].length; i++){
                        this.#overview['children'][i].id.match(/(file|directory)/)[0] != this.#selectType.chosen ? this.#overview['children'][i].style.display = 'none' : false
                        if(this.#selectType.chosen == 'file' && this.#overview['children'][i].id.match(/(file|directory)/)[0] == 'file'){
                            this.#selectType.formats.includes(this.#overview['children'][i].id.match(/[a-zA-Z0-9]+$/)[0]) == false ? this.#selectType.formats.push(this.#overview['children'][i].id.match(/[a-zA-Z0-9]+$/)[0]) : false
                        }
                    } // this.#selectType.chosen == 'file' && this.#selectType.formats.length > 0 && this.#selectType.elementsOfFormatsParent == null
                    if(this.#selectType.chosen == 'file'  && this.#selectType.elementsOfFormatsParent == null){
                        this.#selectType.elementsOfFormatsParent = document.createElement('div');
                        this.#selectType.elementsOfFormatsParent.id = 'finder-typOfFormat-Parent';
                        for(let i=0; i<this.#selectType.formats.length; i++){
                            this.#selectType.elementsOfFormatsChild = document.createElement('div');
                            this.#selectType.elementsOfFormatsChild.innerHTML = `<p id='${this.#selectType.formats[i]}'>${this.#selectType.formats[i]}</p>`;
                            this.#selectType.elementsOfFormatsChild.className = 'finder-typeOfFormat-types';
                            this.#selectType.elementsOfFormatsChild.id = this.#selectType.formats[i];
                            this.#selectType.elementsOfFormatsParent.appendChild(this.#selectType.elementsOfFormatsChild);
                            this.#selectType.elementsOfFormatsChild.addEventListener('click', (e) => {
                                if(this.#selectType.fileFormatChosed == null){
                                    this.#selectType.fileFormatChosed = e.target.id;
                                    document.querySelector(`.finder-typeOfFormat-types[id="${e.target.id}"]`).style.borderColor = 'yellowgreen';
                                    for(let i=1; i<this.#overview['children'].length; i++){
                                        this.#overview['children'][i].id != 'directory' && this.#overview['children'][i].id.match(/[a-zA-Z0-9]+$/)[0] != this.#selectType.fileFormatChosed ? this.#overview['children'][i].style.display = 'none' : false;
                                    }
                                }else if(this.#selectType.fileFormatChosed == e.target.id){
                                    for(let i=1; i<this.#overview['children'].length; i++){
                                        this.#overview['children'][i].id != 'directory' && this.#overview['children'][i].id.match(/[a-zA-Z0-9]+$/)[0] != this.#selectType.fileFormatChosed ? this.#overview['children'][i].style.display = 'block' : false;
                                    }
                                    document.querySelector(`.finder-typeOfFormat-types[id="${e.target.id}"]`).style.borderColor = 'red';
                                    this.#selectType.fileFormatChosed = null;
                                }
                        });
                        }
                        this.#overview['typeOfFile'].appendChild(this.#selectType.elementsOfFormatsParent);
                    }
                    this.#selectType.selectedButton.style.border = '1px solid red';
                }else if(this.#selectType.chosen == e.target.id.match(/(file|directory)/)[0]){
                  //  this.#selectType.elementsOfFormatsParent != null ? document.querySelector('finder-typOfFormat-Parent').remove() : false;
                    this.#selectType.chosen == 'file' && this.#selectType.elementsOfFormatsParent != null ? document.querySelector('#finder-typOfFormat-Parent').remove() : console.log('NO_PARENT')
                    for(let i=1; i<this.#overview['children'].length; i++){
                        this.#overview['children'][i].id.match(/(file|directory)/)[0] != this.#selectType.chosen ? this.#overview['children'][i].style.display = 'block' : false
                    }
                    this.#selectType.chosen = null;
                    this.#selectType.elementsOfFormatsParent = null;
                    this.#selectType.selectedButton.style.border = '1px solid white';
                    this.#selectType.fileFormatChosed = null;
                    this.#selectType.formats = [];
                }         
                });
                this.#overview['typeOfFile'].appendChild(this.#overview['typeOfFileChild'][i]);
            }
            this.#selectType.type = [];
            this.#selectType.chosen = null;
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
            fetch(`/${e.target.getAttribute('value')}`)
            .then(response => {
                return response.json();
            })
            .then(response => {
                history.data = response;
                history.build();
            })
            .catch(err => {
                console.log(err);
            })
    }, 
    build: () => {
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
                if(key2 != 'mkdir'){
                    history.list.out += `<div id="${key}" class='history-parent-container'><p class="history-type-of-task"><span class="material-symbols-outlined">task_alt</span>${key2}</p><p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">target</span> ${history.data['tasks'][key][key2]['target']}</p>`;
                    history.list.out += `<p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">trending_flat</span>${history.data['tasks'][key][key2]['s']}</p><p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">stop</span> ${history.data['tasks'][key][key2]['d']}</p>`;
                    history.list.out += `<p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">today</span>${history.data['tasks'][key][key2]['date']}</p>`;
                    history.list.out += `<button class="history-button-return" id="${key}" value="history/return-action/${key2}=${key}">return</button>`;
                    history.list.out += `</div>`;
                }else if(key2 == 'mkdir'){
                    history.list.out += `<div id="${key}" style="position:relative;width:100%;height:18vh;margin-bottom:3%;border:1px solid white;padding:1%;font-size:10px;font-family:futura;"><p class="history-type-of-task"><span class="material-symbols-outlined">task_alt</span>${key2}</p><p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">target</span> ${history.data['tasks'][key][key2]['target']}</p>`;
                    history.list.out += `<p style="display:flex;align-items:center;margin-left:5px;"><span class="material-symbols-outlined">today</span>${history.data['tasks'][key][key2]['date']}</p>`;
                    history.list.out += `<button class="history-button-return" id="${key}" value="history/return-action/${key2}=${key}">return</button>`;
                    history.list.out += `</div>`;
                }
               
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

let initProject = { 
    trigger: document.getElementById('new-project-header'),
    projectActionTriggers:null,
    projectData: {
        members: [],
        schedule: null,
        name: null
    },
    parent: null, 
    status: true,
    users: null, 
    main: null,
    users: null,
    build: () => {
        console.log(initProject.trigger);
        initProject.parent = document.getElementById('new-project-parent');
        initProject.main = document.getElementById('new-project-main');
        if(initProject.status == true){
            initProject.parent.setAttribute('style', 'position:absolute;z-index:300;right:290px;width:1175px;height:60vh;padding:1%;background-color:white;box-shadow: -10px 5px 2px 1px rgb(60, 60, 60, 0.1);border-radius:20px 0 20px 20px');
            initProject.trigger.setAttribute('style','background-color:lightgrey;padding:1%;border-radius:50%;width:9px;height:9px;float:right;');
            initProject.trigger.children[1].style.display = 'none';
            initProject.trigger.children[0].innerHTML = 'close';
            initProject.main.innerHTML = `<div id='new-project-parent-header'><span class="material-symbols-outlined">construction</span><p>Build Project</p></div><div><label for='projectName'>Project Name</label></div><div id='project-input-parent'><input id='projectName' type='text'></div><div id='project-select-user-parent'><p id='project-select-user-trigger' value='get-users'>Select User</p></div>`;
            document.getElementById('project-select-user-trigger').addEventListener('click', () => {initProject.getUsers('get-users', (x) => {
                initProject.projectData.name = document.getElementById('projectName').value; 
                if(initProject.projectData.name == ''){
                    document.getElementById('projectName').placeholder = "Project Name is required";
                }else{
                    document.getElementById('new-project-users-overview') == undefined ? initProject.buildUsers(x) : false;
                }   
            })}, false);
            initProject.status = false;
        }else if(initProject.status == false){
            initProject.parent.setAttribute('style', 'width:100px;height:5vh;float:right;border-radius:0 0 20px 20px;padding: 0.3%;margin-right:5px;border-left:1px solid black;border-right:1px solid black;border-bottom:1px solid black;');  
            initProject.trigger.setAttribute('style','background-color:white;padding:0;border-radius:0');
            initProject.trigger.children[1].style.display = 'block';
            initProject.main.innerHTML = '';
            initProject.users != null ? initProject.users.remove() : false;
            document.getElementById('new-project-header-icon').innerHTML = 'new_window';
            initProject.status = true;            
        }
     },
     getUsers: (par, func) => {
        fetch(`/project-data/${par}`)
        .then(response => {
            return response.json();
        })
        .then(response => {
            let task = func(response);
        })
        .catch(err => {
            console.log(err);
        })
    },
    buildUsers:(x) => {
        console.log(x);
        initProject.users = document.createElement('div');
        initProject.users.id = 'new-project-users-overview';
        for(let i=0; i<x.length; i++){
            initProject.users.innerHTML += `<div class='new-project-user'><img src='data:image/jpg;base64,${x[i][5]}' width="100" height="131"/><div class="new-project-user-info"><p class="new-project-user-child-p">Username: ${x[i][1]}</p><p class="new-project-user-child-p">First Name: ${x[i][2]}</p><p class="new-project-user-child-p">Last Name: ${x[i][3]}</p><p class="new-project-user-child-p">Contact: ${x[i][4]}</p></div><div class='project-action-container' value="${x[i][0]}"><span class="material-symbols-outlined">person_add</span></div></div>`;
        }
        initProject.main.style.width = '100%';
        document.getElementById('project-select-user-parent').appendChild(initProject.users);
        initProject.assignEvent();
    },
    assignEvent: () => { 
        initProject.projectActionTriggers = document.querySelectorAll('.project-action-container');
        for(let i=0; i<initProject.projectActionTriggers.length; i++){
            initProject.projectActionTriggers[i].addEventListener('click', (e)=>{initProject.projectData.members.push(e.target.parentElement.getAttribute('value')); console.log(initProject.projectData.members);});
        }
    }
}

class BuildProject{
    constructor(name, members, schedule){ 
        this.name = name; 
        this.members = members; 
        this.schedule = schedule 
    }
    connect(){

    }
}

let downloadFile = {
    trigger: null,
    id: null,
    go: () => {
        if(document.querySelector('#present-file-parent-download')){
            downloadFile.trigger = document.querySelector('#present-file-parent-download');
            downloadFile.trigger.addEventListener('click', (e) => {
                downloadFile.id = e.target.getAttribute('value');
                downloadFile.connect();
                });
        }else{
            return false;
        }
    },
    connect: () => {
        fetch(downloadFile.id)
        .then(response => {
            return response.json();
        })
        .then(response => {
           // let task = func(response);
           console.log("download..");
           console.log(response);
        })
        .catch(err => {
            console.log(err);
        })
    }
}

document.getElementById('new-project-header').addEventListener('click', initProject.build);
downloadFile.go();
document.body.addEventListener('onload', taskFile.init());
history.init();



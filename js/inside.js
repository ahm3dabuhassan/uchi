console.log("INSIDE ist da");

let taskFile = {
    source: null,
    positionRequest: null,
    y: null,
    x: null,
    controlPanel: {
        el: document.createElement('div'), // Parent, Target for Childs..
        child: document.createElement('div'), // Child
        components:[document.createElement('button'),document.createElement('p'),document.createElement('p'),document.createElement('button'),document.createElement('button'),document.createElement('button'),document.createElement('div')] 
    },
    fileID: null,
    typeOfTask: 'boot',
    typeOfResponse: 'text',
    directories: null, 
    index: null,
    amoutOfChildren: null,
    funk: null,
    init: () => {
        this.source = document.querySelectorAll(".inside-action");
        for(let i=0; i<this.source.length; i++){
            this.source[i].addEventListener('click', taskFile.build);
        }
    },
    connect: (typeOfTask, fileID, funk=null, headBody=null) => { 
        console.log(typeOfTask);
        fetch(`http://127.0.0.1:8080/taskFile/${typeOfTask}/${fileID}`, headBody) 
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
                    taskFile.controlPanel.components[1].innerHTML = `Filename: ${this.fileID.match(/[a-zA-Z0-9\_\-]+\.?[a-zA-Z]{2,3}?$/)[0]}`;
                }else{
                    taskFile.controlPanel.components[1].innerHTML = `Folder Name: ${this.fileID.match(/[a-zA-Z0-9\_\-]+\.?[a-zA-Z]{2,3}?$/)[0]}`;
                }
                taskFile.controlPanel.components[1].setAttribute('style','background-color:#EDEDED;width:90%;padding:2%;border-radius:4px;font-family:helvetica'); 
                taskFile.controlPanel.components[2].innerHTML = 'Task:'    
                taskFile.controlPanel.components[3].innerHTML = 'Rename';
                taskFile.controlPanel.components[3].id = 'rename';
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
                taskFile.controlPanel.components[0].addEventListener('click', (e) => { taskFile.typeOfTask = 'boot'; e.target.parentElement.remove()});           
                for(let i=1; i<taskFile.controlPanel.components.length; i++){
                    taskFile.controlPanel.child.appendChild(taskFile.controlPanel.components[i]);
                }
                taskFile.positionRequest = this.source[i].getBoundingClientRect();
                taskFile.y = taskFile.positionRequest.top;
                taskFile.x = taskFile.positionRequest.left;
                taskFile.controlPanel.el.id = "inside-control-panel";
                taskFile.controlPanel.el.setAttribute('style',`width:400px;padding-left:1%;padding-right:1.4%;padding-bottom:1%;border:1px solid orangered;background-color:white;border-radius:16px;box-shadow: 5px 5px 2px 1px rgb(60, 60, 60, 0.1);position:absolute;left:${taskFile.x-460}px;top:${taskFile.y}px;`);
                taskFile.controlPanel.child.setAttribute('style','width:96%;height:100%;padding:3%;background-color:whitesmoke;');
                taskFile.controlPanel.el.appendChild(taskFile.controlPanel.child);
                document.body.appendChild(taskFile.controlPanel.el);
            } 
        }
    },
    move: (e) => {
        taskFile.typeOfTask = 'move';
        console.log(e.target.parentElement.parentElement.getAttribute("name"));
        taskFile.index = taskFile.controlPanel.components.length;
        taskFile.controlPanel.components[taskFile.index] = document.createElement('div');
        taskFile.controlPanel.components[taskFile.index].setAttribute("style","width:80%;background-color:blue;border-radius:10px;padding:2%;position:absolute;z-index:100;color:white;left:7%;top:32%;");
        taskFile.controlPanel.components[taskFile.index].innerHTML = "<div id='inside-move-overview'><span class=\"material-symbols-outlined\">home_app_logo</span><p>Übersicht über Folders</p></div>";
        taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'), (x) => {taskFile.insertData(taskFile.controlPanel.components[taskFile.index],x)});
        document.body.appendChild(taskFile.controlPanel.components[taskFile.index]);
    },
    rename: (e) => {
        console.log("RENAME");
        taskFile.typeOfTask = 'rename';
        /// HIER - BUTTON MIT CONFIRM... 
        // insertBefore(newNode, referenceNode)
        taskFile.controlPanel.components[taskFile.index] = document.createElement('input');
        taskFile.controlPanel.components[taskFile.index].className = "insert-data";
        taskFile.controlPanel.components[taskFile.index].id = "rename-newValue";
        taskFile.controlPanel.components[taskFile.index].value = e.target.parentElement.parentElement.getAttribute('name').match(/[a-zA-Z0-9]+\.?[a-zA-Z0-9]{2,3}?$/)[0];
        e.target.parentElement.appendChild(taskFile.controlPanel.components[taskFile.index]);
        taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'));
    },
    delete: (e) => {
        taskFile.typeOfTask = 'delete';
        taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'));
    },
    insertData: (target,content) => {
        for(let key in content){
            taskFile.index++;
            taskFile.controlPanel.components[taskFile.index] = document.createElement('div');
            taskFile.controlPanel.components[taskFile.index].setAttribute('style','width:20%;min-height:20vh;border:1px solid white;border-radius:5px;font-size:12px;float:left;margin-right:5px;margin-bottom:5px;');
            taskFile.controlPanel.components[taskFile.index].innerHTML = `<div class="inside-move-overview-child-header"><p>PATH: <span style="font-size:10px;color:white;">${key.match(/Users\/{1}[a-zA-Z0-9\/\_]+$/)}</span></p></div><p>INHALT:</p>`;
            taskFile.controlPanel.components[taskFile.index].id = key.match(/[a-zA-Z0-9\_\-]+\/{1}[a-zA-Z0-9\_\-]+$/)[0];
            taskFile.controlPanel.components[taskFile.index].className = "move-directories";
            if(content[key].length != 0){
                for(let i=0; i<content[key].length; i++){ 
                    if(content[key][i].match(/^(file|dir)/)[0] == 'file'){
                        taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="move-elements" name="file" id="${key.match(/[a-zA-Z0-9\_\-]+\/{1}[a-zA-Z0-9\_\-]+$/)[0]}/${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}" draggable="true"><span class="material-symbols-outlined">article</span>Name: ${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}</p>`;
                    }else if(content[key][i].match(/^(file|dir)/)[0] == 'dir'){
                        taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="move-elements" name="directory" id="${key.match(/[a-zA-Z0-9\_\-]+\/{1}[a-zA-Z0-9\_\-]+$/)[0]}/${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}" draggable="true"><span class="material-symbols-outlined">folder</span>Name: ${content[key][i].match(/[a-zA-Z0-9]+\.*[a-zA-Z]*$/)[0]}</p>`;
                    } 
                }
            }else {
                taskFile.controlPanel.components[taskFile.index].innerHTML += `<p class="empty-folder"><span class="material-symbols-outlined">folder</span>Empty Folder</p>`;
            }
            taskFile.controlPanel.components[taskFile.index].innerHTML += `</div>`;
            target.appendChild(taskFile.controlPanel.components[taskFile.index]);
        }
        let checkElements = document.querySelectorAll('.move-elements');
        for(let i=0; i<checkElements.length; i++){
            checkElements[i].addEventListener('dragstart', taskFile.drag);
        }
        let assignEventToDirectories = document.querySelectorAll('.move-directories');
        for(let i=0; i<assignEventToDirectories.length; i++){
            assignEventToDirectories[i].addEventListener('drop', taskFile.drop);
            assignEventToDirectories[i].addEventListener('dragover', taskFile.allowDrop);
        }
    },
    drag: (e) => {
        console.log(e.target.id, e.target.getAttribute('name'));
        let was = e.target.getAttribute('name');
        e.dataTransfer.setData('text', JSON.stringify({id:e.target.id,type:was}));
    },
    drop: (e) => {
        console.log("DROP..");
        taskFile.typeOfTask = "moved"
        console.log(e.currentTarget);
        e.preventDefault();
        console.log(`DROP-EVENT: ${e.target.id}`);
        let data = JSON.parse(e.dataTransfer.getData("text"));
        console.log(`DATA:: ${data.id}, ${data.type}`); 
        taskFile.connect(taskFile.typeOfTask, `${data.type}/`, (x) => {console.log(`MOVED:: ${x}`);}, {headers:{
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method: 'POST',
        body: JSON.stringify({s:data.id,d:e.currentTarget.id})
    });
        e.currentTarget.appendChild(document.getElementById(data["id"]));
    },
    allowDrop: (e) => {
        e.preventDefault();
    }
}
document.body.addEventListener('onload', taskFile.init());

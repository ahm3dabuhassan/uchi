console.log("INSIDE ist da");

let taskFile = {
    source: null,
    positionRequest: null,
    y: null,
    x: null,
    controlPanel: {
        el: document.createElement('div'), // Parent, Target for Childs..
        child: document.createElement('div'), // Child
        components:[document.createElement('button'),document.createElement('p'),document.createElement('p'),document.createElement('button'),document.createElement('button'),document.createElement('select')] 
    },
    fileID: null,
    typeOfTask: 'boot',
    typeOfResponse: 'text',
    directories: null, 
    index: null,
    amoutOfChildren: null,
    init: () => {
        this.source = document.querySelectorAll(".inside-action");
        for(let i=0; i<this.source.length; i++){
            this.source[i].addEventListener('click', taskFile.build);
        }
    },
    connect: (typeOfTask, fileID, funk) => { // typeOfTask
        console.log(typeOfTask);
        fetch(`http://127.0.0.1:8080/taskFile/${typeOfTask}/${fileID}`) 
                    .then(response => { 
                        return response.json();
                    })
                    .then(response => {
                        taskFile.insertData(taskFile.controlPanel.components[5], 'option', response);
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
                taskFile.controlPanel.components[0].innerHTML = 'X';
                taskFile.controlPanel.components[0].id = 'cancel'; // (e) => { taskFile.rename(); taskFile.typeOfTask = e.target.id; taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'),false)}
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
                taskFile.connect(taskFile.typeOfTask, this.fileID);
            } 
        }
    },
    insertData: (target,typeOfElement,data) => { // REG-OPTION=null -> if != null 
      this.index = taskFile.controlPanel.components.length;
      this.amoutOfChildren = document.querySelectorAll('.insert-data');
      if(this.amoutOfChildren != null){
        for(let i=0; i<this.amoutOfChildren.length; i++){
            this.amoutOfChildren[i].remove();
        }
      } 
      taskFile.controlPanel.components[taskFile.index] = document.createElement(typeOfElement);
      taskFile.controlPanel.components[taskFile.index].innerHTML = "Move to:";
      taskFile.controlPanel.components[taskFile.index].selected = true;
      taskFile.controlPanel.components[taskFile.index].className = "insert-data";
      target.appendChild(taskFile.controlPanel.components[taskFile.index]);
      for(let i=0; i<data.length; i++){
            taskFile.controlPanel.components[taskFile.index] = document.createElement(typeOfElement);
            taskFile.controlPanel.components[taskFile.index].innerHTML = data[i];//.match(/macboy\/{1}[a-zA-Z0-9\/\-\_]+/);
            taskFile.controlPanel.components[taskFile.index].className = "insert-data";
            target.appendChild(taskFile.controlPanel.components[taskFile.index]);
        }
      this.index = taskFile.controlPanel.components.length;
    },
    rename: (e) => {
        console.log("RENAME");
        taskFile.typeOfTask = 'rename';
        taskFile.controlPanel.components[taskFile.index] = document.createElement('input');
        taskFile.controlPanel.components[taskFile.index].className = "insert-data";
        taskFile.controlPanel.components[taskFile.index].id = "rename-newValue";
        taskFile.controlPanel.components[taskFile.index].value = e.target.parentElement.parentElement.getAttribute('name').match(/[a-zA-Z0-9]+\.?[a-zA-Z0-9]{2,3}?$/)[0];
        console.log(taskFile.controlPanel.components[taskFile.index]);
        e.target.parentElement.appendChild(taskFile.controlPanel.components[taskFile.index]);
        console.log(e.target.parentElement);
      //  taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'));
    },
    delete: (e) => {
        taskFile.typeOfTask = 'delete';
        taskFile.connect(taskFile.typeOfTask,e.target.parentElement.parentElement.getAttribute('name'));
    }
} 
document.body.addEventListener('onload', taskFile.init());

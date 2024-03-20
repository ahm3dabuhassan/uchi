//console.log(document.cookie);
let validForm = {
    source: null,
    trigger: null,
    message: null,
    init: () => {
        this.source = document.querySelectorAll('.home-form-input');
        this.trigger = document.querySelector('form');
        this.trigger.setAttribute('onsubmit', "return validForm.valid();");
        this.message = document.querySelector('#login-message');
    },
    valid: () => {
        for(let i=0; i<this.source.length; i++){
            if(this.source[i].value.length < 1){
                this.message.innerHTML = "Alle Felder mussen ausgefühlt werden";
                return false;
            }
        }
    }
}
validForm.init();
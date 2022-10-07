let form = document.forms.formbusca;

const changeInput = () => {
    document.querySelector("#buscar").disabled = false;
    if (form.titulo.value == "" && form.escritor.value == "")
        document.querySelector("#buscar").disabled = true;
}
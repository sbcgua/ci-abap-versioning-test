

function onSubmit() {
    console.log('hello');
    const repoPath = document.querySelector("#constructorForm [name='repo_path']");
    const filePath = document.querySelector("#constructorForm [name='file_path']");
    const constName = document.querySelector("#constructorForm [name='const_name']");
    console.log(repoPath, filePath, constName);
}

function initForm() {
    document.getElementById('constructorSubmit').onclick = onSubmit;
}

initForm();

// document.getElementById("text2").innerHTML = "And this one too";
// $().ready(() => {
//     $("#text3").html("This is text3");
//     $("#textInc").html("This is text in includes");
// });

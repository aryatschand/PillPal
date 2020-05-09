errorBox = document.querySelector("#error");
numOfPills = 0;
addPill();

async function signup() {
    event.preventDefault();
    let email = document.querySelector("#emailInput").value.toLowerCase();
    let firstName = document.querySelector("#firstName").value;
    let lastName = document.querySelector("#lastName").value;
    let password = document.querySelector("#passwordInput").value;
    let passwordConfirm = document.querySelector("#passwordConfirm").value;
    let patientType = document.querySelector("#patientType").value;
    let userType = document.querySelector("#userType").value;
    let result;
    let pillResult = "";
    let pillElements = document.getElementsByClassName("pillInput");
    console.log(pillElements);
    if (pillElements.length != 0) {
        for (i = 0; i < pillElements.length; i++) {
            if (pillElements[i].value != "") {
                pillResult += `${pillElements[i].value},`;
            }
        }
    }
    console.log(pillResult);
    await axios({
        method: 'POST',
        url: 'https://pillpal.macrotechsolutions.us:9146/http://localhost/website/signUp',
        headers: {
            'Content-Type': 'application/json',
            'usertype': userType,
            'patienttype': patientType,
            'email': email,
            'firstname': firstName,
            'lastname': lastName,
            'password': password,
            'passwordconfirm': passwordConfirm,
            "pilljson": pillResult
        }
    })
        .then(data => result = data.data)
        .catch(err => console.log(err))
    if (result.data == "Email already exists.") {
        errorBox.innerText = 'Email already exists.';
    } else if (result.data == "Please enter an email address.") {
        errorBox.innerText = 'Please enter an email address.';
    } else if (result.data == 'Invalid Name') {
        errorBox.innerText = 'Invalid Name';
    } else if (result.data == 'Invalid email address.') {
        errorBox.innerText = 'Invalid email address.';
    } else if (result.data == 'Your password needs to be at least 6 characters.') {
        errorBox.innerText = 'Your password needs to be at least 6 characters.';
    } else if (result.data == 'Your passwords don\'t match.') {
        errorBox.innerText = 'Your passwords don\'t match.';
    } else if (result.data == 'Please enter at least one pill.') {
        errorBox.innerText = 'Please enter at least one pill.';
    } else {
        errorBox.innerText = `Successfully registered ${firstName} ${lastName}!`;
        clearForm();
    }
}

function clearForm() {
    document.querySelector(".login-dark").innerHTML = `<form method="post">\
        <h2 class="sr-only">Sign Up Form</h2>\
        <div class="illustration"><i class="fas fa-user-plus"></i></div>\
        <p style="text-align:center" id="error">${errorBox.innerText}</p>\
        <div class="form-group"><select class="form-control"\
                id="userType" onchange="userChanged()">\
                <option style="color:black" value="Patient">Patient</option>\
                <option style="color:black" value="Doctor">Doctor</option>\
            </select></div>\
        <div class="form-group"><input\
                class="form-control" type="name" id="firstName"\
                name="name" placeholder="First Name"></div>\
        <div class="form-group"><input\
                class="form-control" type="name" id="lastName"\
                name="name" placeholder="Last Name"></div>\
        <div class="form-group"><input\
                class="form-control" type="email" id="emailInput"\
                name="email" placeholder="Email"></div>\
        <div class="form-group"><input\
                class="form-control" id="passwordInput"\
                type="password" name="password" placeholder="Password"></div>\
        <div class="form-group"><input\
                class="form-control" id="passwordConfirm"\
                type="password" name="password" placeholder="Confirm Password"></div>\
        <div class="form-group"><select class="form-control"\
                id="patientType">\
                <option style="color:black" value="Automatic">Automatic</option>\
                <option style="color:black" value="Manual">Manual</option>\
            </select></div>\
        <div id="pillNames">\
        </div>\
        <button class="btn btn-primary\
            btn-block" onclick="addPill()">Add Pill</button>\
        <div class="form-group"><button class="btn btn-primary\
                btn-block" type="submit" onclick="signup()">Sign Up</button></div>\
    </form>`;
}

function userChanged() {
    let userType = document.querySelector("#userType").value;
    if (userType == "Doctor") {
        document.querySelector("#patientType").style.display = "none";
        document.querySelector("#pillMainDiv").style.display = "none";

    } else {
        document.querySelector("#patientType").style.display = "block";
        document.querySelector("#pillMainDiv").style.display = "block";
    }
}

function addPill() {
    event.preventDefault();
    numOfPills++;
    let pillDiv = document.createElement('div');
    pillDiv.className = "form-group d-flex flex-row justify-content-center align-items-center";
    pillDiv.id = `pillDiv${numOfPills}`;
    let pillInput = document.createElement('input');
    pillInput.className = "form-control pillInput";
    pillInput.placeholder = "Pill Name";
    let pillButton = document.createElement('button');
    pillButton.className = "btn btn-primary";
    pillButton.type = "button";
    pillButton.style = "margin-top: 0px;"
    pillButton.innerText = "X";
    let currentPillNum = numOfPills;
    pillButton.onclick = function () {
        document.querySelector(`#pillNames`).removeChild(document.querySelector(`#pillDiv${currentPillNum}`));
    };
    pillDiv.appendChild(pillInput);
    pillDiv.appendChild(pillButton);
    document.querySelector("#pillNames").appendChild(pillDiv);
}

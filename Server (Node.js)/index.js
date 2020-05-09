const express = require('express');
const bcrypt = require('bcryptjs');
var admin = require('firebase-admin');
var serviceAccount = require("./qbhacks-ff9af-firebase-adminsdk-s5try-078691b50f.json");
var path = require('path');
var bodyParser = require('body-parser');
const PORT = process.env.PORT || 80

var app = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://qbhacks-ff9af.firebaseio.com"
});

var database = admin.database();

express()
    .use(express.static(path.join(__dirname, 'build')))
    .use(bodyParser.urlencoded({ extended: false }))
    .set('views', path.join(__dirname, 'views'))
    .set('view engine', 'ejs')
    .post('/iphone/newschedule', function (req, res, next) {
        var date = req.headers.date
        var pill = req.headers.pill
        var user = req.headers.user

        database.ref(`/Schedule/`).push({
            user: user,
            pill: pill,
            fulfilled: false,
            date: date,
        })
    })
    .get('/arduino/dispense', async function (req, res) {
        let myVal = await database.ref('/Patients').orderByChild('name').equalTo("Arya Tschand").once("value");
        myVal = myVal.val();
        if (myVal) {
            for (key in myVal) {
                if (myVal[key].fulfilled == false || myVal[key].fulfilled == "false") {
                    let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal[key].requested).once("value");
                    myVal2 = myVal2.val();
                    if (myVal2) {
                        for (key in myVal2) {
                            database.ref('/Patients/Arya Tschand/fulfilled').set(true);
                            // res.send(parseInt(key.substring(1)));
                            res.send(key.substring(1));
                            return;
                        }
                    }
                }
            }
        }

        let today = new Date();
        let myVal3 = await database.ref('/Schedule').orderByChild('user').equalTo("Arya Tschand").once("value");
        myVal3 = myVal3.val();
        if (myVal3) {
            for (mainKey in myVal3) {
                if (myVal3[mainKey].fulfilled == false || myVal3[mainKey].fulfilled == "false") {
                    let timeList = myVal3[mainKey].date.split("-");
                    if (today.getFullYear() > parseInt(timeList[0])) {
                        let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal3[mainKey].pill).once("value");
                        myVal2 = myVal2.val();
                        if (myVal2) {
                            for (key in myVal2) {
                                // res.send(parseInt(key.substring(1)));
                                database.ref(`/Schedule/${mainKey}/fulfilled`).set(true);
                                res.send(key.substring(1));
                                return;
                            }
                        }
                    } else if (today.getFullYear() == parseInt(timeList[0])) {
                        if (today.getMonth() + 1 > parseInt(timeList[1])) {
                            let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal3[mainKey].pill).once("value");
                            myVal2 = myVal2.val();
                            if (myVal2) {
                                for (key in myVal2) {
                                    // res.send(parseInt(key.substring(1)));
                                    database.ref(`/Schedule/${mainKey}/fulfilled`).set(true);
                                    res.send(key.substring(1));
                                    return;
                                }
                            }
                        } else if (today.getMonth() + 1 == parseInt(timeList[1])) {
                            if (today.getDate() > parseInt(timeList[2].substring(0, 2))) {
                                let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal3[mainKey].pill).once("value");
                                myVal2 = myVal2.val();
                                if (myVal2) {
                                    for (key in myVal2) {
                                        // res.send(parseInt(key.substring(1)));
                                        database.ref(`/Schedule/${mainKey}/fulfilled`).set(true);
                                        res.send(key.substring(1));
                                        return;
                                    }
                                }
                            } else if (today.getDate() == parseInt(timeList[2].substring(0, 2))) {
                                if (today.getHours() > parseInt(timeList[2].substring(3, 5))) {
                                    let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal3[mainKey].pill).once("value");
                                    myVal2 = myVal2.val();
                                    if (myVal2) {
                                        for (key in myVal2) {
                                            // res.send(parseInt(key.substring(1)));
                                            database.ref(`/Schedule/${mainKey}/fulfilled`).set(true);
                                            res.send(key.substring(1));
                                            return;
                                        }
                                    }
                                } else if (today.getHours() == parseInt(timeList[2].substring(3, 5))) {
                                    if (today.getMinutes() > parseInt(timeList[2].substring(6, 8))) {
                                        let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal3[mainKey].pill).once("value");
                                        myVal2 = myVal2.val();
                                        if (myVal2) {
                                            for (key in myVal2) {
                                                // res.send(parseInt(key.substring(1)));
                                                database.ref(`/Schedule/${mainKey}/fulfilled`).set(true);
                                                res.send(key.substring(1));
                                                return;
                                            }
                                        }
                                    } else if (today.getMinutes() == parseInt(timeList[2].substring(6, 8))) {
                                        if (today.getSeconds() >= parseInt(timeList[2].substring(9, 11))) {
                                            let myVal2 = await database.ref('/Positions').orderByChild('pill').equalTo(myVal3[mainKey].pill).once("value");
                                            myVal2 = myVal2.val();
                                            if (myVal2) {
                                                for (key in myVal2) {
                                                    // res.send(parseInt(key.substring(1)));
                                                    database.ref(`/Schedule/${mainKey}/fulfilled`).set(true);
                                                    res.send(key.substring(1));
                                                    return;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // res.send(0);
        res.send("0");
    })
    .post('/website/signUp', async function (req, res) {
        console.log("Signup request started");
        let info = req.headers;
        let email = info.email;
        console.log(`Email: ${email}`);
        let firstName = info.firstname;
        let lastName = info.lastname;
        console.log(`Name: ${firstName} ${lastName}`);
        let password = info.password;
        let passwordConfirm = info.passwordconfirm;
        let passwordEncrypt = hash(password);
        console.log(`Password: ${passwordEncrypt}`);
        let userType = info.usertype;
        let patientType = info.patienttype;
        let pillJson = info.pilljson;
        let returnVal;
        if (userType == "Doctor") {
            if (!email) {
                returnVal = {
                    data: 'Please enter an email address.'
                };
                res.send(returnVal);
                return;
            }
            let myVal = await database.ref("Doctors").orderByChild('email').equalTo(email).once("value");
            myVal = myVal.val();
            if (myVal) {
                returnVal = {
                    data: 'Email already exists.'
                };
            } else if (firstName.length == 0 || lastName.length == 0) {
                returnVal = {
                    data: 'Invalid Name'
                };
            } else if (!(/^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$/u.test(firstName) && /^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$/u.test(lastName))) {
                returnVal = {
                    data: 'Invalid Name'
                };
            } else if (!(/(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/
                .test(email))) {
                returnVal = {
                    data: 'Invalid email address.'
                };
            } else if (password.length < 6) {
                returnVal = {
                    data: 'Your password needs to be at least 6 characters.'
                };
            } else if (password != passwordConfirm) {
                returnVal = {
                    data: 'Your passwords don\'t match.'
                };
            } else {
                database.ref(`Doctors/${firstName} ${lastName}/email`).set(email);
                database.ref(`Doctors/${firstName} ${lastName}/password`).set(hash(password));
                returnVal = {
                    data: "Valid User"
                }
            }
        } else {
            if (!email) {
                returnVal = {
                    data: 'Please enter an email address.'
                };
                res.send(returnVal);
                return;
            } else if (pillJson == "") {
                returnVal = {
                    data: 'Please enter at least one pill.'
                };
                res.send(returnVal);
                return;
            }
            let myVal = await database.ref("Patients").orderByChild('email').equalTo(email).once("value");
            myVal = myVal.val();
            if (myVal) {
                returnVal = {
                    data: 'Email already exists.'
                };
            } else if (firstName.length == 0 || lastName.length == 0) {
                returnVal = {
                    data: 'Invalid Name'
                };
            } else if (!(/^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$/u.test(firstName) && /^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$/u.test(lastName))) {
                returnVal = {
                    data: 'Invalid Name'
                };
            } else if (!(/(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/
                .test(email))) {
                returnVal = {
                    data: 'Invalid email address.'
                };
            } else if (password.length < 6) {
                returnVal = {
                    data: 'Your password needs to be at least 6 characters.'
                };
            } else if (password != passwordConfirm) {
                returnVal = {
                    data: 'Your passwords don\'t match.'
                };
            } else {
                database.ref(`Patients/${firstName} ${lastName}/email`).set(email);
                database.ref(`Patients/${firstName} ${lastName}/name`).set(`${firstName} ${lastName}`);
                database.ref(`Patients/${firstName} ${lastName}/password`).set(passwordEncrypt);
                database.ref(`Patients/${firstName} ${lastName}/patientType`).set(patientType);
                database.ref(`Patients/${firstName} ${lastName}/pills`).set(pillJson);
                database.ref(`Patients/${firstName} ${lastName}/requested`).set("none");
                database.ref(`Patients/${firstName} ${lastName}/fulfilled`).set("empty");
                database.ref(`Patients/${firstName} ${lastName}/pills`).set(pillJson);
                returnVal = {
                    data: "Valid User"
                }
            }
        }
        res.send(returnVal);
    })
    .post('/website/signIn', async function (req, res) {
        // Website you wish to allow to connect
        res.setHeader('Access-Control-Allow-Origin', 'https://syncfast.macrotechsolutions.us');

        // Request methods you wish to allow
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
        let info = req.headers;
        let email = info.email;
        let password = info.password;
        let returnVal;
        let myVal = await database.ref("Patients").orderByChild('email').equalTo(email).once("value");
        myVal = myVal.val();
        if (!myVal) {
            let myVal2 = await database.ref("Doctors").orderByChild('email').equalTo(email).once("value");
            myVal2 = myVal2.val();
            if (!myVal2) {
                returnVal = {
                    data: "Incorrect email address."
                }
            } else {
                let doctorName = "";
                let userPassword;
                for (key in myVal2) {
                    doctorName = key;
                    userPassword = myVal2[key].password;
                }
                let inputPassword = password;
                if (bcrypt.compareSync(inputPassword, userPassword)) {
                    returnVal = {
                        data: "Valid User",
                        name: doctorName,
                        user: "Doctor"
                    }
                } else {
                    returnVal = {
                        data: "Incorrect Password"
                    }
                }
            }
        } else {
            let patientName = "";
            let userPassword;
            let patientType = "";
            for (key in myVal) {
                patientName = key;
                userPassword = myVal[key].password;
                patientType = myVal[key].patientType;
            }
            let inputPassword = password;
            if (bcrypt.compareSync(inputPassword, userPassword)) {
                returnVal = {
                    data: "Valid User",
                    name: patientName,
                    user: `${patientType} Patient`
                }
            } else {
                returnVal = {
                    data: "Incorrect Password"
                }
            }
        }
        res.send(returnVal);
    })
    .listen(PORT, () => console.log(`Listening on ${PORT}`));

function hash(value) {
    let salt = bcrypt.genSaltSync(10);
    let hashVal = bcrypt.hashSync(value, salt);
    return hashVal;
}

function parseEnvList(env) {
    if (!env) {
        return [];
    }
    return env.split(',');
}

var originBlacklist = parseEnvList(process.env.CORSANYWHERE_BLACKLIST);
var originWhitelist = parseEnvList(process.env.CORSANYWHERE_WHITELIST);

// Set up rate-limiting to avoid abuse of the public CORS Anywhere server.
var checkRateLimit = require('./lib/rate-limit')(process.env.CORSANYWHERE_RATELIMIT);

var cors_proxy = require('./lib/cors-anywhere');
cors_proxy.createServer({
    originBlacklist: originBlacklist,
    originWhitelist: originWhitelist,
    requireHeader: ['origin', 'x-requested-with'],
    checkRateLimit: checkRateLimit,
    removeHeaders: [
        'cookie',
        'cookie2',
        // Strip Heroku-specific headers
        'x-heroku-queue-wait-time',
        'x-heroku-queue-depth',
        'x-heroku-dynos-in-use',
        'x-request-start',
    ],
    redirectSameOrigin: true,
    httpProxyOptions: {
        // Do not add X-Forwarded-For, etc. headers, because Heroku already adds it.
        xfwd: false,
    },
})
    .listen(4911, () => console.log(`Listening on ${4911}`))
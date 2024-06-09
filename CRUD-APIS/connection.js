const mysql = require('mysql2')
var mysqlconnection = mysql.createConnection({
    host:"localhost",
    user:"root",
    password:"etkhan12",
    database:"myDB"
})
 mysqlconnection.connect((error)=>{
    if(error){
        console.log("error: "+JSON.stringify(error,undefined,2))
    }else{
        console.log("Connected Successfully!")
    }
})

module.exports = mysqlconnection
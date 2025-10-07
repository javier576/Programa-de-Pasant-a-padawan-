 const mysql= require("mysql2");

 const connection = mysql.createConnection({
    host: "localhost",
    user:"root",
    password:"123456",
    database:"I_Strategies"
 });

 connection.connect((err)=>{
    if(err)throw err;
    console.log("Conexion Exitosa")
 })
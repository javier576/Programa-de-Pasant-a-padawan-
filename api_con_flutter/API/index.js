import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import mysql from "mysql2";

const app = express();
const PORT = 3000;
const SECRET_KEY = "clave_secreta";

app.use(express.json());

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "123456",
  database: "I_Strategies"
});

app.post("/register", (req, res)=>{
    const {correo, nombre, fecha_nacimiento, pais, telefono, contraseña}=req.body;

const hashedPassword = bcrypt.hashSync(contraseña, 10);

db.query(
    "INSERT INTO usuarios (correo, nombre, fecha_nacimiento, pais, telefono, contraseña) VALUES (?, ?, ?, ?, ?, ?)",
    [correo, nombre, fecha_nacimiento, pais, telefono, hashedPassword],
    (err,result)=>{
        if( err) return res.status(500).json({error:"Error al registrar"});
        res.json({ mensaje:"Usuario registrado"});
    }
) 
});

//buscar correo
app.get("/search/:correo", (req, res)=>{
  const correo =req.params.correo;
  db.query(
    "SELECT * FROM usuarios WHERE correo = ?",
    [correo],
    (err,result)=>{
      if(err){
         return res.status(500).json({error:"Error en la BD"});
      }
      if (result.length === 0){
        return res.status(404).json({ error: "Usuario no encontrado" });
      }

      res.json(result[0]);
    }
  )
});

//cambiar contraseña 
app.put("/change-password", (req, res) => {
  const { correo, contraseña } = req.body;

  if (!correo || !contraseña)
    return res.status(400).json({ error: "Datos incompletos" });

  //Buscar al usuario por correo
  db.query("SELECT contraseña FROM usuarios WHERE correo = ?", [correo], (err, results) => {
    if (err) return res.status(500).json({ error: "Error en la base de datos" });
    if (results.length === 0)
      return res.status(404).json({ error: "Usuario no encontrado" });

    const contraseñaActual = results[0].contraseña;
 
    //Comparar contraseñas
    const esIgual = bcrypt.compareSync(contraseña, contraseñaActual);
    if (esIgual)
      return res.status(400).json({ error: "La nueva contraseña no puede ser igual a la anterior" });

    // Encriptar y actualizar
    const hashedPassword = bcrypt.hashSync(contraseña, 10);
    db.query(
      "UPDATE usuarios SET contraseña = ? WHERE correo = ?",
      [hashedPassword, correo],
      (err2) => {
        if (err2) return res.status(500).json({ error: "Error al actualizar contraseña" });
        res.json({ mensaje: "Contraseña cambiada correctamente" });
      }
    );
  });
});


// login usuario
app.post("/login", (req, res) => {
  const { correo, contraseña } = req.body;

  db.query(
      "SELECT * FROM usuarios WHERE correo = ?",
      [correo],
      (err, results) => {
        if (err) return res.status(500).json({ error: "Error en la BD" });
        if (results.length === 0)
          return res.status(401).json({ error: "Usuario no encontrado" });

        const user = results[0];

        const validPassword = bcrypt.compareSync(contraseña, user.contraseña);
        if (!validPassword)
          return res.status(401).json({ error: "Contraseña incorrecta" });

        // Generar token JWT
        const token = jwt.sign({ id: user.id, correo: user.correo }, SECRET_KEY, {
          expiresIn: "1h",
        });

        res.json({ mensaje: "Login exitoso", token });
      }
    );
  });

  app.get("/perfil", (req, res) => {
    const token = req.headers["authorization"];
    if (!token) return res.status(403).json({ error: "Token requerido" });

    try {
      const decoded = jwt.verify(token, SECRET_KEY);
      res.json({ mensaje: "Acceso permitido", user: decoded });
    } catch (error) {
      res.status(401).json({ error: "Token inválido" });
    }
  });

  app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
  });


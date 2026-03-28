const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();

// On sert les fichiers statiques (ton index.html avec Tailwind)
app.use(express.static(path.join(__dirname, 'public')));

// Paramètres de connexion vers ta VM BDD (192.168.10.10)
const db = mysql.createConnection({
  host: '192.168.10.10', 
  user: 'appuser',
  password: 'password', // Assure-toi que c'est le bon MDP défini sur MySQL
  database: 'appdb'
});

// Route pour tester la DB depuis le navigateur
app.get('/status-db', (req, res) => {
  db.query('SELECT "Connexion MySQL OK" AS status', (err, rows) => {
    if (err) {
      return res.status(500).json({ error: "Erreur de connexion : " + err.message });
    }
    res.json({ status: rows[0].status });
  });
});

// Lancement sur toutes les interfaces pour que la Passerelle puisse entrer
app.listen(3000, '0.0.0.0', () => {
  console.log('---------------------------------------------');
  console.log('  SERVEUR SAMA WEB (M1 SR) - CONNECTÉ DB     ');
  console.log('  Port : 3000 | IP : 192.168.100.10          ');
  console.log('---------------------------------------------');
});
import sqlite3 from 'sqlite3';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const dbPath = path.join(__dirname, 'conectatic.db');

console.log('🔧 Inicializando base de datos SQLite...');
console.log(`📂 Ruta: ${dbPath}`);

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('❌ Error creando base de datos:', err.message);
    process.exit(1);
  } else {
    console.log('✅ Base de datos creada exitosamente');
    
    // Crear tabla usuarios
    db.run(`
      CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre VARCHAR(100) NOT NULL,
        correo VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        progreso INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `, (err) => {
      if (err) {
        console.error('❌ Error creando tabla usuarios:', err.message);
        process.exit(1);
      } else {
        console.log('✅ Tabla usuarios creada exitosamente');
        
        // Cerrar la conexión
        db.close((err) => {
          if (err) {
            console.error('❌ Error cerrando base de datos:', err.message);
          } else {
            console.log('✅ Base de datos inicializada correctamente');
            console.log('📋 Puedes ejecutar "npm run dev" ahora');
          }
        });
      }
    });
  }
});
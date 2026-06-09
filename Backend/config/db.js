import sqlite3 from 'sqlite3';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

// Cargar .env solo en desarrollo
if (process.env.NODE_ENV !== 'production') {
  dotenv.config();
}

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Usar /tmp para persistencia temporal en Railway (24-48h)
// En desarrollo, usar archivo local
const dbPath = process.env.NODE_ENV === 'production' 
  ? '/tmp/conectatic.db'
  : path.join(__dirname, '../conectatic.db');

let db;

export async function initDb() {
  return new Promise((resolve, reject) => {
    db = new sqlite3.Database(dbPath, (err) => {
      if (err) {
        console.error('❌ Error abriendo SQLite:', err.message);
        reject(err);
      } else {
        console.log('✅ Conexión a SQLite establecida correctamente');
        console.log(`   Base de datos: ${dbPath}`);
        console.log(`   📝 Nota: Datos persisten ~24-48 horas en Railway`);

        // Habilitar foreign keys
        db.run('PRAGMA foreign_keys = ON', (err) => {
          if (err) {
            console.error('❌ Error habilitando foreign keys:', err);
            reject(err);
          } else {
            // Crear tabla si no existe
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
                console.error('❌ Error creando tabla:', err);
                reject(err);
              } else {
                console.log('✅ Tabla usuarios verificada/creada');
                resolve(db);
              }
            });
          }
        });
      }
    });
  });
}

export function getDb() {
  return db;
}

export default { initDb, getDb };
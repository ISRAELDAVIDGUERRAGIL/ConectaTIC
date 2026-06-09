import { sql } from '@vercel/postgres';
import dotenv from 'dotenv';

// Cargar .env solo en desarrollo
if (process.env.NODE_ENV !== 'production') {
  dotenv.config();
}

export async function initDb() {
  try {
    // Verificar conexión a Vercel Postgres
    const result = await sql`SELECT 1`;
    console.log('✅ Conexión a Vercel Postgres establecida correctamente');
    console.log('   📝 Nota: Base de datos persistente y GRATIS con Vercel');

    // Crear tabla si no existe
    await sql`
      CREATE TABLE IF NOT EXISTS usuarios (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        correo VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        progreso INT DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `;

    console.log('✅ Tabla usuarios verificada/creada');
    
    return sql;
  } catch (error) {
    console.error('❌ Error conectando a Vercel Postgres:', error.message);
    throw error;
  }
}

export function getDb() {
  return sql;
}

export default { initDb, getDb };
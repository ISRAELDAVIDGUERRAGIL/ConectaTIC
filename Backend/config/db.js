import pg from 'pg';
import dotenv from 'dotenv';

// Cargar .env solo en desarrollo
if (process.env.NODE_ENV !== 'production') {
  dotenv.config();
}

let pool;

export async function initDb() {
  try {
    // Usar DATABASE_URL directamente de process.env (Railway lo proporciona)
    const dbUrl = process.env.DATABASE_URL || 'postgresql://postgres:password@localhost:5432/conectatic';
    
    console.log('🔍 Conectando a:', dbUrl.split('@')[0] + '@' + dbUrl.split('@')[1]?.substring(0, 30) + '...');

    // Crear pool de conexiones PostgreSQL
    pool = new pg.Pool({
      connectionString: dbUrl,
      max: 10,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
    });

    // Verificar conexión
    const client = await pool.connect();
    console.log('✅ Conexión a PostgreSQL establecida correctamente');
    
    const result = await client.query('SELECT NOW()');
    console.log(`   Base de datos conectada: ${result.rows[0].now}`);

    // Crear tabla si no existe
    await client.query(`
      CREATE TABLE IF NOT EXISTS usuarios (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        correo VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        progreso INT DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      
      CREATE INDEX IF NOT EXISTS idx_correo ON usuarios(correo);
    `);

    console.log('✅ Tabla usuarios verificada/creada');
    client.release();
    
    return pool;
  } catch (error) {
    console.error('❌ Error conectando a PostgreSQL:', error.message);
    process.exit(1);
  }
}

export function getDb() {
  return pool;
}

export default { initDb, getDb };
import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config({ path: './Backend/.env' });

const { Pool } = pg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

async function getUsers() {
  try {
    const result = await pool.query('SELECT id, nombre, correo, progreso, created_at FROM usuarios ORDER BY id DESC');
    
    console.log('\n📋 USUARIOS EN SUPABASE:\n');
    
    if (result.rows.length === 0) {
      console.log('❌ No hay usuarios registrados');
    } else {
      result.rows.forEach((user, index) => {
        console.log(`${index + 1}. ${user.nombre}`);
        console.log(`   📧 Correo: ${user.correo}`);
        console.log(`   📊 Progreso: ${user.progreso}%`);
        console.log(`   ⏰ Creado: ${new Date(user.created_at).toLocaleString('es-ES')}`);
        console.log('');
      });
    }
    
    console.log(`✅ Total de usuarios: ${result.rows.length}`);
    
    await pool.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

getUsers();

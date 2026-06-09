import sqlite3 from 'sqlite3';

const db = new sqlite3.Database('./conectatic.db', (err) => {
  if (err) {
    console.error('Error abriendo BD:', err.message);
    process.exit(1);
  }
  
  db.all('SELECT id, nombre, correo, progreso FROM usuarios ORDER BY id DESC', (err, rows) => {
    if (err) {
      console.error('Error:', err.message);
    } else {
      console.log('\n📋 CREDENCIALES EN LA BD:\n');
      if (rows && rows.length > 0) {
        rows.forEach((user, i) => {
          console.log(`${i+1}. ${user.nombre}`);
          console.log(`   Correo: ${user.correo}`);
          console.log(`   Progreso: ${user.progreso}%\n`);
        });
        console.log(`✅ Total: ${rows.length} usuarios\n`);
      } else {
        console.log('❌ No hay usuarios registrados\n');
      }
    }
    db.close();
  });
});

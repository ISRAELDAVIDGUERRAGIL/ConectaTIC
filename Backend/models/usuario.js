import { getDb, saveDb } from '../config/db.js';

export const UsuarioModel = {
  async findByEmail(correo) {
    const db = getDb();
    const stmt = db.prepare('SELECT id, nombre, correo, password, progreso FROM usuarios WHERE correo = ?');
    stmt.bind([correo]);
    if (stmt.step()) {
      const row = stmt.getAsObject();
      stmt.free();
      return row;
    }
    stmt.free();
    return null;
  },

  async findById(id) {
    const db = getDb();
    const stmt = db.prepare('SELECT id, nombre, correo, progreso FROM usuarios WHERE id = ?');
    stmt.bind([id]);
    if (stmt.step()) {
      const row = stmt.getAsObject();
      stmt.free();
      return row;
    }
    stmt.free();
    return null;
  },

  async getAll() {
    const db = getDb();
    const results = [];
    const stmt = db.prepare('SELECT id, nombre, correo, progreso FROM usuarios ORDER BY id DESC');
    while (stmt.step()) {
      results.push(stmt.getAsObject());
    }
    stmt.free();
    return results;
  },

  async create({ nombre, correo, password }) {
    const db = getDb();
    db.run('INSERT INTO usuarios (nombre, correo, password, progreso) VALUES (?, ?, ?, ?)', [nombre, correo, password, 0]);
    saveDb();
    const stmt = db.prepare('SELECT last_insert_rowid() as id');
    stmt.step();
    const result = stmt.getAsObject();
    stmt.free();
    return result.id;
  },

  async updateById(id, updates) {
    const db = getDb();
    
    // 🔒 WHITELIST de campos permitidos (Prevención SQL Injection)
    const allowedFields = ['nombre', 'correo'];
    const fields = [];
    const values = [];

    Object.keys(updates).forEach(key => {
      if (allowedFields.includes(key) && updates[key] !== undefined) {
        fields.push(`${key} = ?`);
        values.push(updates[key]);
      }
    });

    // Si no hay campos para actualizar, retornar usuario actual
    if (fields.length === 0) {
      return this.findById(id);
    }

    // Agregar ID para el WHERE clause
    values.push(id);

    // Ejecutar actualización con campos validados
    db.run(`UPDATE usuarios SET ${fields.join(', ')} WHERE id = ?`, values);
    saveDb();

    return this.findById(id);
  },

  async updateProgress(id, incremento) {
    const db = getDb();
    const user = await this.findById(id);
    if (!user) return null;
    
    const nuevoProgreso = Math.min(100, Math.max(0, user.progreso + incremento));
    db.run('UPDATE usuarios SET progreso = ? WHERE id = ?', [nuevoProgreso, id]);
    saveDb();
    
    return nuevoProgreso;
  },

  async deleteById(id) {
    const db = getDb();
    db.run('DELETE FROM usuarios WHERE id = ?', [id]);
    saveDb();
    return true;
  }
};

export default UsuarioModel;
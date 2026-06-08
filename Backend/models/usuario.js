import { getDb } from '../config/db.js';

export const UsuarioModel = {
  // ============================================================
  // Buscar usuario por correo
  // ============================================================
  async findByEmail(correo) {
    return new Promise((resolve, reject) => {
      const db = getDb();
      db.get(
        'SELECT id, nombre, correo, password, progreso FROM usuarios WHERE correo = ?',
        [correo],
        (err, row) => {
          if (err) {
            console.error('❌ Error en findByEmail:', err.message);
            reject(err);
          } else {
            resolve(row || null);
          }
        }
      );
    });
  },

  // ============================================================
  // Buscar usuario por ID
  // ============================================================
  async findById(id) {
    return new Promise((resolve, reject) => {
      const db = getDb();
      db.get(
        'SELECT id, nombre, correo, progreso FROM usuarios WHERE id = ?',
        [id],
        (err, row) => {
          if (err) {
            console.error('❌ Error en findById:', err.message);
            reject(err);
          } else {
            resolve(row || null);
          }
        }
      );
    });
  },

  // ============================================================
  // Obtener todos los usuarios
  // ============================================================
  async getAll() {
    return new Promise((resolve, reject) => {
      const db = getDb();
      db.all(
        'SELECT id, nombre, correo, progreso FROM usuarios ORDER BY id DESC',
        (err, rows) => {
          if (err) {
            console.error('❌ Error en getAll:', err.message);
            reject(err);
          } else {
            resolve(rows || []);
          }
        }
      );
    });
  },

  // ============================================================
  // Crear nuevo usuario
  // ============================================================
  async create({ nombre, correo, password }) {
    return new Promise((resolve, reject) => {
      const db = getDb();
      db.run(
        'INSERT INTO usuarios (nombre, correo, password, progreso) VALUES (?, ?, ?, ?)',
        [nombre, correo, password, 0],
        function(err) {
          if (err) {
            console.error('❌ Error en create:', err.message);
            reject(err);
          } else {
            resolve(this.lastID);
          }
        }
      );
    });
  },

  // ============================================================
  // Actualizar usuario (por ID)
  // ============================================================
  async updateById(id, updates) {
    try {
      // 🔒 WHITELIST de campos permitidos
      const allowedFields = ['nombre', 'correo'];
      const fields = [];
      const values = [];

      Object.keys(updates).forEach(key => {
        if (allowedFields.includes(key) && updates[key] !== undefined) {
          fields.push(`${key} = ?`);
          values.push(updates[key]);
        }
      });

      if (fields.length === 0) {
        return this.findById(id);
      }

      values.push(id);

      return new Promise((resolve, reject) => {
        const db = getDb();
        db.run(
          `UPDATE usuarios SET ${fields.join(', ')} WHERE id = ?`,
          values,
          (err) => {
            if (err) {
              console.error('❌ Error en updateById:', err.message);
              reject(err);
            } else {
              this.findById(id).then(resolve).catch(reject);
            }
          }
        );
      });
    } catch (error) {
      console.error('❌ Error en updateById:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Actualizar progreso del usuario
  // ============================================================
  async updateProgress(id, incremento) {
    try {
      const user = await this.findById(id);
      if (!user) return null;

      const nuevoProgreso = Math.min(100, Math.max(0, user.progreso + incremento));

      return new Promise((resolve, reject) => {
        const db = getDb();
        db.run(
          'UPDATE usuarios SET progreso = ? WHERE id = ?',
          [nuevoProgreso, id],
          (err) => {
            if (err) {
              console.error('❌ Error en updateProgress:', err.message);
              reject(err);
            } else {
              resolve(nuevoProgreso);
            }
          }
        );
      });
    } catch (error) {
      console.error('❌ Error en updateProgress:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Eliminar usuario por ID
  // ============================================================
  async deleteById(id) {
    return new Promise((resolve, reject) => {
      const db = getDb();
      db.run(
        'DELETE FROM usuarios WHERE id = ?',
        [id],
        function(err) {
          if (err) {
            console.error('❌ Error en deleteById:', err.message);
            reject(err);
          } else {
            resolve(this.changes > 0);
          }
        }
      );
    });
  }
};

export default UsuarioModel;
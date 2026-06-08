import { getDb } from '../config/db.js';

export const UsuarioModel = {
  // ============================================================
  // Buscar usuario por correo
  // ============================================================
  async findByEmail(correo) {
    try {
      const pool = getDb();
      const result = await pool.query(
        'SELECT id, nombre, correo, password, progreso FROM usuarios WHERE correo = $1',
        [correo]
      );
      return result.rows.length > 0 ? result.rows[0] : null;
    } catch (error) {
      console.error('❌ Error en findByEmail:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Buscar usuario por ID
  // ============================================================
  async findById(id) {
    try {
      const pool = getDb();
      const result = await pool.query(
        'SELECT id, nombre, correo, progreso FROM usuarios WHERE id = $1',
        [id]
      );
      return result.rows.length > 0 ? result.rows[0] : null;
    } catch (error) {
      console.error('❌ Error en findById:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Obtener todos los usuarios
  // ============================================================
  async getAll() {
    try {
      const pool = getDb();
      const result = await pool.query(
        'SELECT id, nombre, correo, progreso FROM usuarios ORDER BY id DESC'
      );
      return result.rows || [];
    } catch (error) {
      console.error('❌ Error en getAll:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Crear nuevo usuario
  // ============================================================
  async create({ nombre, correo, password }) {
    try {
      const pool = getDb();
      const result = await pool.query(
        'INSERT INTO usuarios (nombre, correo, password, progreso) VALUES ($1, $2, $3, $4) RETURNING id',
        [nombre, correo, password, 0]
      );
      return result.rows[0].id;
    } catch (error) {
      console.error('❌ Error en create:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Actualizar usuario (por ID)
  // ============================================================
  async updateById(id, updates) {
    try {
      // 🔒 WHITELIST de campos permitidos (Prevención SQL Injection)
      const allowedFields = ['nombre', 'correo'];
      const fields = [];
      const values = [];
      let paramCount = 1;

      Object.keys(updates).forEach(key => {
        if (allowedFields.includes(key) && updates[key] !== undefined) {
          fields.push(`${key} = $${paramCount}`);
          values.push(updates[key]);
          paramCount++;
        }
      });

      // Si no hay campos para actualizar, retornar usuario actual
      if (fields.length === 0) {
        return this.findById(id);
      }

      // Agregar ID para el WHERE clause
      values.push(id);

      const pool = getDb();
      await pool.query(
        `UPDATE usuarios SET ${fields.join(', ')} WHERE id = $${paramCount}`,
        values
      );

      return this.findById(id);
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

      const pool = getDb();
      await pool.query(
        'UPDATE usuarios SET progreso = $1 WHERE id = $2',
        [nuevoProgreso, id]
      );

      return nuevoProgreso;
    } catch (error) {
      console.error('❌ Error en updateProgress:', error.message);
      throw error;
    }
  },

  // ============================================================
  // Eliminar usuario por ID
  // ============================================================
  async deleteById(id) {
    try {
      const pool = getDb();
      const result = await pool.query(
        'DELETE FROM usuarios WHERE id = $1',
        [id]
      );
      return result.rowCount > 0;
    } catch (error) {
      console.error('❌ Error en deleteById:', error.message);
      throw error;
    }
  }
};

export default UsuarioModel;
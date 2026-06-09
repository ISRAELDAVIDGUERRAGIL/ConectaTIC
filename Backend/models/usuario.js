import { getDb } from '../config/db.js';

export const UsuarioModel = {
  // ============================================================
  // Buscar usuario por correo
  // ============================================================
  async findByEmail(correo) {
    try {
      const db = getDb();
      const result = await db`
        SELECT id, nombre, correo, password, progreso FROM usuarios WHERE correo = ${correo}
      `;
      return result.rows[0] || null;
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
      const db = getDb();
      const result = await db`
        SELECT id, nombre, correo, progreso FROM usuarios WHERE id = ${id}
      `;
      return result.rows[0] || null;
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
      const db = getDb();
      const result = await db`
        SELECT id, nombre, correo, progreso FROM usuarios ORDER BY id DESC
      `;
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
      const db = getDb();
      const result = await db`
        INSERT INTO usuarios (nombre, correo, password, progreso)
        VALUES (${nombre}, ${correo}, ${password}, 0)
        RETURNING id
      `;
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
      // 🔒 WHITELIST de campos permitidos
      const allowedFields = ['nombre', 'correo'];
      const updateFields = {};

      Object.keys(updates).forEach(key => {
        if (allowedFields.includes(key) && updates[key] !== undefined) {
          updateFields[key] = updates[key];
        }
      });

      if (Object.keys(updateFields).length === 0) {
        return this.findById(id);
      }

      const db = getDb();
      const setClause = Object.keys(updateFields)
        .map(key => `${key} = $${Object.keys(updateFields).indexOf(key) + 1}`)
        .join(', ');
      const values = Object.values(updateFields);

      await db(`
        UPDATE usuarios SET ${setClause} WHERE id = $${values.length + 1}
      `, [...values, id]);

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

      const db = getDb();
      await db`
        UPDATE usuarios SET progreso = ${nuevoProgreso} WHERE id = ${id}
      `;

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
      const db = getDb();
      const result = await db`
        DELETE FROM usuarios WHERE id = ${id}
      `;
      return result.rowCount > 0;
    } catch (error) {
      console.error('❌ Error en deleteById:', error.message);
      throw error;
    }
  }
};

export default UsuarioModel;
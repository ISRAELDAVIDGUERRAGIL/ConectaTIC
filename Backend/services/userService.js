// ============================================================
// ARCHIVO: services/userService.js
// PROPÓSITO: Lógica de negocio para gestión de usuarios
// DESCRIPCIÓN: Maneja operaciones CRUD de usuarios y progreso
// ============================================================

import { UsuarioModel } from '../models/usuario.js';
import ApiError from '../utils/ApiError.js';

// ============================================================
// FUNCIÓN: Obtener todos los usuarios
// ============================================================

/**
 * Retorna una lista de todos los usuarios registrados
 * @returns {Array} - Array de usuarios
 */
export const getAllUsers = async () => {
  return await UsuarioModel.getAll();
};

// ============================================================
// FUNCIÓN: Obtener usuario por ID
// ============================================================

/**
 * Busca un usuario específico por su ID
 * @param {number} id - ID del usuario
 * @returns {Object|null} - Datos del usuario o null si no existe
 */
export const getUserById = async (id) => {
  return await UsuarioModel.findById(id);
};

// ============================================================
// FUNCIÓN: Crear usuario
// ============================================================

/**
 * Crea un nuevo usuario en la base de datos
 * @param {Object} userData
 * @returns {Object}
 */
export const createUser = async (userData) => {
  const existingUser = await UsuarioModel.findByEmail(userData.correo);

  if (existingUser) {
    throw ApiError.conflict('El correo ya está registrado');
  }

  const userId = await UsuarioModel.create(userData);

  return {
    id: userId,
    nombre: userData.nombre,
    correo: userData.correo
  };
};

// ============================================================
// FUNCIÓN: Actualizar usuario
// ============================================================

/**
 * Actualiza los datos de un usuario
 * @param {number} id - ID del usuario
 * @param {Object} updates - Campos a actualizar
 * @returns {Object} - Datos actualizados del usuario
 */
export const updateUser = async (id, updates) => {
  const user = await UsuarioModel.findById(id);

  if (!user) {
    throw ApiError.notFound('Usuario no encontrado');
  }

  if (updates.correo) {
    const existingUser = await UsuarioModel.findByEmail(updates.correo);
    if (existingUser && existingUser.id !== id) {
      throw ApiError.conflict('El correo ya está registrado');
    }
  }

  return await UsuarioModel.updateById(id, updates);
};

// ============================================================
// FUNCIÓN: Actualizar progreso del usuario
// ============================================================

/**
 * Incrementa el progreso de un usuario
 * El progreso máximo es 100
 * @param {number} idUsuario - ID del usuario
 * @param {number} incremento - Cantidad a incrementar
 * @returns {number} - Nuevo valor del progreso
 */
export const updateUserProgress = async (idUsuario, incremento) => {
  if (typeof incremento !== 'number' || incremento < 0) {
    throw ApiError.badRequest('El incremento debe ser un número positivo');
  }

  const progreso = await UsuarioModel.updateProgress(idUsuario, incremento);

  if (progreso === null) {
    throw ApiError.notFound('Usuario no encontrado');
  }

  return progreso;
};

// ============================================================
// FUNCIÓN: Eliminar usuario
// ============================================================

/**
 * Elimina un usuario de la base de datos
 * @param {number} id - ID del usuario a eliminar
 * @returns {boolean} - true si se eliminó, false si no existía
 */
export const deleteUser = async (id) => {
  const deleted = await UsuarioModel.deleteById(id);

  if (!deleted) {
    throw ApiError.notFound('Usuario no encontrado');
  }

  return deleted;
};

// ============================================================
// EXPORTAR FUNCIONES
// ============================================================

export default {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  updateUserProgress,
  deleteUser
};
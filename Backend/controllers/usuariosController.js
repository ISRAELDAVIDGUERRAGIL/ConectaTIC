// ============================================================
// ARCHIVO: controllers/usuariosController.js
// PROPÓSITO: Controlador de gestión de usuarios
// DESCRIPCIÓN: Maneja las solicitudes HTTP relacionadas con usuarios
//              y coordina con los servicios correspondientes
// ============================================================

// Importar servicios de usuario
import * as userService from '../services/userService.js';

// Importar validadores
import { validateUpdateUser } from '../validators/authValidator.js';

// Importar formateador de respuestas
import { ok, created, badRequest, notFound, internalError } from '../utils/responseFormatter.js';

// ============================================================
// CONTROLADOR: Obtener todos los usuarios
// ============================================================

/**
 * Retorna la lista de todos los usuarios
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 */
export const obtenerUsuarios = async (req, res, next) => {
  try {
    const users = await userService.getAllUsers();
    return ok(res, 'Usuarios obtenidos correctamente', users);
  } catch (error) {
    next(error);
  }
};

// ============================================================
// CONTROLADOR: Obtener usuario por ID
// ============================================================

/**
 * Retorna un usuario específico por su ID
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 */
export const obtenerUsuarioPorId = async (req, res, next) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return badRequest(res, 'ID de usuario inválido');
    }

    const user = await userService.getUserById(userId);

    if (!user) {
      return notFound(res, 'Usuario no encontrado');
    }

    return ok(res, 'Usuario obtenido correctamente', user);
  } catch (error) {
    next(error);
  }
};

// ============================================================
// CONTROLADOR: Crear usuario (alternativo a registro)
// ============================================================

/**
 * Crea un nuevo usuario (endpoint alternativo)
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 */
export const crearUsuario = async (req, res, next) => {
  try {
    const { nombre, correo, password } = req.body;

    if (!nombre || !correo || !password) {
      return badRequest(res, 'Nombre, correo y contraseña son requeridos');
    }

    const user = await userService.createUser({ nombre, correo, password });

    return created(res, 'Usuario creado correctamente', {
      id: user.id,
      nombre: user.nombre,
      correo: user.correo
    });
  } catch (error) {
    next(error);
  }
};

// ============================================================
// CONTROLADOR: Actualizar usuario
// ============================================================

/**
 * Actualiza los datos de un usuario
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 */
export const actualizarUsuario = async (req, res, next) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return badRequest(res, 'ID de usuario inválido');
    }

    // Validar datos de actualización
    const validation = validateUpdateUser(req.body);

    if (!validation.isValid) {
      return badRequest(res, 'Datos inválidos', validation.errors);
    }

    // Actualizar usuario
    const updatedUser = await userService.updateUser(userId, req.body);

    if (!updatedUser) {
      return notFound(res, 'Usuario no encontrado');
    }

    return ok(res, 'Usuario actualizado correctamente', updatedUser);
  } catch (error) {
    next(error);
  }
};

// ============================================================
// CONTROLADOR: Actualizar progreso
// ============================================================

/**
 * Incrementa el progreso de un usuario
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 */
export const actualizarProgreso = async (req, res, next) => {
  try {
    // ---- Obtener ID del usuario desde el token ----
    // El middleware de autenticación agrega el usuario al request
    const usuarioId = req.usuario?.id;

    if (!usuarioId) {
      return badRequest(res, 'ID de usuario no proporcionado');
    }

    // ---- Obtener incremento del body ----
    const { incremento } = req.body;

    if (incremento === undefined || incremento === null) {
      return badRequest(res, 'El campo incremento es requerido');
    }

    // ---- Validar incremento ----
    if (typeof incremento !== 'number' || incremento < 0) {
      return badRequest(res, 'El incremento debe ser un número positivo');
    }

    // ---- Actualizar progreso ----
    const nuevoProgreso = await userService.updateUserProgress(usuarioId, incremento);

    return ok(res, 'Progreso actualizado correctamente', {
      progreso: nuevoProgreso
    });

  } catch (error) {
    next(error);
  }
};

// ============================================================
// CONTROLADOR: Eliminar usuario
// ============================================================

/**
 * Elimina un usuario de la base de datos
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 */
export const eliminarUsuario = async (req, res, next) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return badRequest(res, 'ID de usuario inválido');
    }

    const deleted = await userService.deleteUser(userId);

    if (!deleted) {
      return notFound(res, 'Usuario no encontrado');
    }

    return ok(res, 'Usuario eliminado correctamente');
  } catch (error) {
    next(error);
  }
};

// ============================================================
// EXPORTAR CONTROLADORES
// ============================================================

export default {
  obtenerUsuarios,
  obtenerUsuarioPorId,
  crearUsuario,
  actualizarUsuario,
  actualizarProgreso,
  eliminarUsuario
};
// ============================================================
// ARCHIVO: middlewares/authMiddleware.js
// PROPÓSITO: Middleware para verificar autenticación JWT
// DESCRIPCIÓN: Protege rutas verificando que el token sea válido
//              y agrega los datos del usuario al request
// ============================================================

import jwtService from '../utils/jwtService.js';
import ApiError from '../utils/ApiError.js';

// ============================================================
// MIDDLEWARE: Verificar token JWT
// ============================================================

/**
 * Middleware que verifica si el token JWT es válido
 * Si es válido, agrega los datos del usuario a req.usuario
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 * @param {Function} next - Función next de Express
 */
export const verificarToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return next(ApiError.unauthorized('Token no proporcionado'));
  }

  const parts = authHeader.split(' ');

  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return next(ApiError.unauthorized('Formato de token inválido'));
  }

  const token = parts[1];

  try {
    const decoded = jwtService.verifyToken(token);
    req.usuario = decoded;
    next();
  } catch (error) {
    next(error);
  }
};

// ============================================================
// MIDDLEWARE: Verificar rol de usuario
// ============================================================

/**
 * Middleware opcional para verificar roles específicos
 * @param {string[]} rolesPermitidos - Array de roles permitidos
 * @returns {Function} - Middleware de Express
 */
export const verificarRol = (...rolesPermitidos) => {
  return (req, res, next) => {
    if (!req.usuario) {
      return next(ApiError.unauthorized('Usuario no autenticado'));
    }

    const userRole = req.usuario.rol || 'usuario';

    if (!rolesPermitidos.includes(userRole)) {
      return next(ApiError.forbidden('No tienes permiso para acceder a este recurso'));
    }

    next();
  };
};

// ============================================================
// EXPORTAR MIDDLEWARES
// ============================================================

export default {
  verificarToken,
  verificarRol
};
// ============================================================
// ARCHIVO: middlewares/errorHandler.js
// PROPÓSITO: Manejo centralizado de errores en Express
// DESCRIPCIÓN: Captura errores lanzados por controladores y
//              retorna respuestas JSON consistentes.
// ============================================================

import ApiError from '../utils/ApiError.js';
import { errorResponse } from '../utils/responseFormatter.js';

/**
 * Middleware de errores global para Express.
 * Recibe cualquier error de la cadena de middlewares
 * y devuelve una respuesta JSON con status adecuado.
 */
export const errorHandler = (err, req, res, next) => {
  console.error('Error global de la API:', err.message);

  if (err instanceof ApiError) {
    return errorResponse(res, err.statusCode, err.message);
  }

  return errorResponse(res, 500, 'Error interno del servidor');
};

export default errorHandler;

// ============================================================
// ARCHIVO: utils/responseFormatter.js
// PROPÓSITO: Estandarizar respuestas de la API
// DESCRIPCIÓN: Proporciona funciones para formatear respuestas exitosas
//              y de error de manera consistente
// ============================================================

// ============================================================
// RESPUESTA EXITOSA
// ============================================================

/**
 * Formatear respuesta exitosa
 * @param {Object} res - Objeto response de Express
 * @param {number} statusCode - Código de estado HTTP
 * @param {string} message - Mensaje de éxito
 * @param {any} data - Datos a devolver (opcional)
 * @returns {JSON} - Respuesta JSON formateada
 */
export const successResponse = (res, statusCode = 200, message = 'Éxito', data = null) => {
  const response = {
    success: true,
    message
  };

  // Solo agregar data si existe
  if (data !== null) {
    response.data = data;
  }

  return res.status(statusCode).json(response);
};

// ============================================================
// RESPUESTA DE ERROR
// ============================================================

/**
 * Formatear respuesta de error
 * @param {Object} res - Objeto response de Express
 * @param {number} statusCode - Código de estado HTTP
 * @param {string} message - Mensaje de error
 * @param {any} errors - Errores adicionales (opcional)
 * @returns {JSON} - Respuesta JSON formateada
 */
export const errorResponse = (res, statusCode = 500, message = 'Error', errors = null) => {
  const response = {
    success: false,
    message
  };

  // Solo agregar errors si existe
  if (errors !== null) {
    response.errors = errors;
  }

  return res.status(statusCode).json(response);
};

// ============================================================
// RESPUESTAS PREDEFINIDAS COMUNES
// ============================================================

// 200 - OK
export const ok = (res, message = 'Operación exitosa', data = null) => {
  return successResponse(res, 200, message, data);
};

// 201 - Created
export const created = (res, message = 'Recurso creado', data = null) => {
  return successResponse(res, 201, message, data);
};

// 204 - No Content (sin datos para devolver)
export const noContent = (res, message = 'Sin contenido') => {
  return res.status(204).json({ success: true, message });
};

// 400 - Bad Request
export const badRequest = (res, message = 'Solicitud inválida', errors = null) => {
  return errorResponse(res, 400, message, errors);
};

// 401 - Unauthorized
export const unauthorized = (res, message = 'No autorizado') => {
  return errorResponse(res, 401, message);
};

// 403 - Forbidden
export const forbidden = (res, message = 'Acceso prohibido') => {
  return errorResponse(res, 403, message);
};

// 404 - Not Found
export const notFound = (res, message = 'Recurso no encontrado') => {
  return errorResponse(res, 404, message);
};

// 409 - Conflict
export const conflict = (res, message = 'Conflicto de datos', errors = null) => {
  return errorResponse(res, 409, message, errors);
};

// 500 - Internal Server Error
export const internalError = (res, message = 'Error interno del servidor') => {
  return errorResponse(res, 500, message);
};

export default {
  successResponse,
  errorResponse,
  ok,
  created,
  noContent,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  internalError
};
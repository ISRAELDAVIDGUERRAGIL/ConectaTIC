// ============================================================
// ARCHIVO: utils/ApiError.js
// PROPÓSITO: Clase personalizada para manejar errores de API
// DESCRIPCIÓN: Estandariza los errores devolviendo un objeto de error estructurado
// ============================================================

// ============================================================
// CÓDIGOS DE ESTADO HTTP COMUNES
// ============================================================
const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_SERVER_ERROR: 500,
  SERVICE_UNAVAILABLE: 503
};

// ============================================================
// CLASE: ApiError
// ============================================================

/**
 * Clase personalizada para errores de API
 * Permite crear errores con código de estado HTTP y mensaje estructurado
 */
export class ApiError extends Error {
  /**
   * @param {number} statusCode - Código de estado HTTP
   * @param {string} message - Mensaje de error
   * @param {boolean} isOperational - Si es un error operativo (no error de programación)
   */
  constructor(statusCode, message, isOperational = true) {
    // Llamar al constructor de Error
    super(message);

    // Guardar el nombre de la clase
    this.name = this.constructor.name;

    // Guardar el código de estado HTTP
    this.statusCode = statusCode;

    // Guardar si es un error operativo
    this.isOperational = isOperational;

    // Capturar el stack trace (para debugging)
    Error.captureStackTrace(this, this.constructor);
  }

  // ============================================================
  // MÉTODOS ESTÁTICOS PARA CREAR ERRORES COMUNES
  // ============================================================

  /**
   * Crear error 400 - Bad Request
   */
  static badRequest(message) {
    return new ApiError(HTTP_STATUS.BAD_REQUEST, message);
  }

  /**
   * Crear error 401 - Unauthorized
   */
  static unauthorized(message = 'No autorizado') {
    return new ApiError(HTTP_STATUS.UNAUTHORIZED, message);
  }

  /**
   * Crear error 403 - Forbidden
   */
  static forbidden(message = 'Acceso prohibido') {
    return new ApiError(HTTP_STATUS.FORBIDDEN, message);
  }

  /**
   * Crear error 404 - Not Found
   */
  static notFound(message = 'Recurso no encontrado') {
    return new ApiError(HTTP_STATUS.NOT_FOUND, message);
  }

  /**
   * Crear error 409 - Conflict (ej: correo duplicado)
   */
  static conflict(message = 'Conflicto de datos') {
    return new ApiError(HTTP_STATUS.CONFLICT, message);
  }

  /**
   * Crear error 500 - Internal Server Error
   */
  static internal(message = 'Error interno del servidor') {
    return new ApiError(HTTP_STATUS.INTERNAL_SERVER_ERROR, message);
  }
}

// ============================================================
// EXPORTAR CLASE Y CONSTANTES
// ============================================================
export { HTTP_STATUS };
export default ApiError;
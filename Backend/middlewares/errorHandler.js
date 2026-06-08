// ============================================================
// ARCHIVO: middlewares/errorHandler.js
// PROPÓSITO: Manejo centralizado de errores en Express
// DESCRIPCIÓN: Captura errores lanzados por controladores y
//              retorna respuestas JSON consistentes.
// ============================================================

import crypto from 'crypto';
import ApiError from '../utils/ApiError.js';
import { errorResponse } from '../utils/responseFormatter.js';

/**
 * Middleware de errores global para Express.
 * Recibe cualquier error de la cadena de middlewares
 * y devuelve una respuesta JSON con status adecuado.
 */
export const errorHandler = (err, req, res, next) => {
  // Generar ID único para el error (para tracking)
  const errorId = crypto.randomUUID();
  const NODE_ENV = process.env.NODE_ENV || 'development';
  
  // Construir objeto de log estructurado
  const errorLog = {
    errorId,
    timestamp: new Date().toISOString(),
    method: req.method,
    path: req.path,
    query: Object.keys(req.query).length ? req.query : undefined,
    statusCode: err.statusCode || 500,
    message: err.message,
    type: err.constructor.name,
    
    // Stack trace solo en desarrollo
    ...(NODE_ENV === 'development' && { stack: err.stack }),
    
    // Información del usuario si está autenticado
    userId: req.usuario?.id,
    ip: req.ip,
  };

  // Log en JSON para facilitar parsing
  console.error(JSON.stringify(errorLog, null, 2));

  // Determinar statusCode y mensaje
  let statusCode = 500;
  let message = 'Error interno del servidor';
  let errors = null;

  if (err instanceof ApiError) {
    statusCode = err.statusCode;
    message = err.message;
  } else if (err.name === 'ValidationError') {
    statusCode = 400;
    message = 'Error de validación';
    errors = err.errors;
  } else if (err.name === 'CastError') {
    statusCode = 400;
    message = 'ID inválido';
  } else if (err.name === 'MongoServerError' && err.code === 11000) {
    statusCode = 409;
    message = 'Registro duplicado';
  }

  // Respuesta al cliente
  const responseData = {
    success: false,
    message,
    statusCode,
    timestamp: new Date().toISOString(),
    ...(NODE_ENV === 'development' && { errorId }), // Mostrar ID en desarrollo para debugging
  };

  if (errors) {
    responseData.errors = errors;
  }

  return res.status(statusCode).json(responseData);
};

export default errorHandler;

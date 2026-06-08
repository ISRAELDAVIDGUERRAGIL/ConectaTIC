// ============================================================
// ARCHIVO: utils/jwtService.js
// PROPÓSITO: Servicio JWT para firmar y verificar tokens
// DESCRIPCIÓN: Centraliza la lógica de tokens JWT y sus opciones.
// ============================================================

import jwt from 'jsonwebtoken';
import ApiError from './ApiError.js';

// Leer directamente de process.env (sin dotenv en producción)
const JWT_SECRET = process.env.JWT_SECRET || process.env.jwt_secret;
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || process.env.jwt_expires_in || '7d';

if (!JWT_SECRET) {
  console.error('❌ ERROR: JWT_SECRET no está definida');
  console.error('Variables disponibles:', Object.keys(process.env).filter(k => k.toLowerCase().includes('jwt')));
  throw new Error('La variable de entorno JWT_SECRET no está definida');
}

console.log('✅ JWT_SECRET cargada correctamente');

/**
 * Genera un token JWT con el payload del usuario
 * @param {Object} payload - Datos a incluir en el token
 * @returns {string} - Token firmado
 */
export const signToken = (payload) => {
  return jwt.sign(payload, JWT_SECRET, {
    expiresIn: JWT_EXPIRES_IN
  });
};

/**
 * Verifica un token JWT y retorna el payload decodificado
 * @param {string} token - Token JWT a verificar
 * @returns {Object} - Payload decodificado
 * @throws {ApiError} - Si el token es inválido o expirado
 */
export const verifyToken = (token) => {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (error) {
    throw ApiError.unauthorized('Token inválido o expirado');
  }
};

export default {
  signToken,
  verifyToken
};

// ============================================================
// ARCHIVO: services/authService.js
// PROPÓSITO: Lógica de negocio para autenticación
// DESCRIPCIÓN: Maneja registro, login y generación de tokens JWT
// ============================================================

import bcrypt from 'bcryptjs';
import { UsuarioModel } from '../models/usuario.js';
import jwtService from '../utils/jwtService.js';
import ApiError from '../utils/ApiError.js';

const BCRYPT_ROUNDS = 10;

// ============================================================
// FUNCIÓN: Registrar nuevo usuario
// ============================================================

/**
 * Registra un nuevo usuario en la base de datos.
 * @param {Object} userData
 * @returns {Object}
 */
export const registerUser = async (userData) => {
  console.log('🚀 SERVICE: registerUser INICIADO');
  console.log('   userData:', JSON.stringify(userData));
  try {
    const { nombre, correo, password } = userData;

    console.log('📝 Intentando registrar usuario:', { nombre, correo });

    const existingUser = await UsuarioModel.findByEmail(correo);

  if (existingUser) {
    throw ApiError.conflict('El correo electrónico ya está registrado');
  }

  const hashedPassword = await bcrypt.hash(password, BCRYPT_ROUNDS);

  const insertId = await UsuarioModel.create({
    nombre,
    correo,
    password: hashedPassword
  });

  return {
      id: insertId,
      nombre,
      correo
    };
  } catch (error) {
    console.error('❌ ERROR en registerUser:', error.message);
    throw error;
  }
};

// ============================================================
// FUNCIÓN: Iniciar sesión
// ============================================================

/**
 * Autentica un usuario y genera un token JWT.
 * @param {Object} credentials
 * @returns {Object}
 */
export const loginUser = async (credentials) => {
  const { correo, password } = credentials;

  const user = await UsuarioModel.findByEmail(correo);

  if (!user) {
    throw ApiError.unauthorized('Credenciales inválidas');
  }

  const isPasswordValid = await bcrypt.compare(password, user.password);

  if (!isPasswordValid) {
    throw ApiError.unauthorized('Credenciales inválidas');
  }

const token = jwtService.signToken({
      id: user.id,
      nombre: user.nombre,
      correo: user.correo
    });

return {
      token,
      user: {
        id: user.id,
        nombre: user.nombre,
        correo: user.correo,
        progreso: user.progreso
      }
    };
};

export const verifyToken = jwtService.verifyToken;

export default {
  registerUser,
  loginUser,
  verifyToken
};
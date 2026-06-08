// ============================================================
// ARCHIVO: validators/authValidator.js
// PROPÓSITO: Validar datos de autenticación (registro y login)
// DESCRIPCIÓN: Funciones de validación para datos de usuario
// ============================================================

// ============================================================
// EXPRESIONES REGULARES PARA VALIDACIÓN
// ============================================================

// Email: verifica formato básico de email
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Password: mínimo 8 caracteres, con mayúscula, minúscula y número
// Más segura que antes (era solo 6 caracteres)
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

// Nombre: solo letras, espacios y acentos, entre 2 y 100 caracteres
const NAME_REGEX = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]{2,100}$/;

// ============================================================
// FUNCIÓN: Validar datos de registro
// ============================================================

/**
 * Valida los datos necesarios para registrar un nuevo usuario
 * @param {Object} data - Objeto con los datos del usuario
 * @returns {Object} - { isValid: boolean, errors: string[] }
 */
export const validateRegister = (data) => {
  const errors = [];
  const { nombre, correo, password } = data;

  // ---- Validar nombre ----
  if (!nombre || nombre.trim() === '') {
    errors.push('El nombre es requerido');
  } else if (!NAME_REGEX.test(nombre.trim())) {
    errors.push('El nombre debe tener entre 2 y 100 caracteres y solo contener letras');
  }

  // ---- Validar correo ----
  if (!correo || correo.trim() === '') {
    errors.push('El correo electrónico es requerido');
  } else if (!EMAIL_REGEX.test(correo.trim())) {
    errors.push('El formato del correo electrónico no es válido');
  }

  // ---- Validar contraseña ----
  if (!password || password === '') {
    errors.push('La contraseña es requerida');
  } else if (!PASSWORD_REGEX.test(password)) {
    errors.push('La contraseña debe tener al menos 8 caracteres, con mayúscula, minúscula, número y carácter especial (@$!%*?&)');
  }

  // ---- Retornar resultado ----
  return {
    isValid: errors.length === 0,
    errors
  };
};

// ============================================================
// FUNCIÓN: Validar datos de login
// ============================================================

/**
 * Valida los datos necesarios para iniciar sesión
 * @param {Object} data - Objeto con credenciales
 * @returns {Object} - { isValid: boolean, errors: string[] }
 */
export const validateLogin = (data) => {
  const errors = [];
  const { correo, password } = data;

  // ---- Validar correo ----
  if (!correo || correo.trim() === '') {
    errors.push('El correo electrónico es requerido');
  } else if (!EMAIL_REGEX.test(correo.trim())) {
    errors.push('El formato del correo electrónico no es válido');
  }

  // ---- Validar contraseña ----
  if (!password || password === '') {
    errors.push('La contraseña es requerida');
  }

  // ---- Retornar resultado ----
  return {
    isValid: errors.length === 0,
    errors
  };
};

// ============================================================
// FUNCIÓN: Validar datos de usuario (para PUT/PATCH)
// ============================================================

/**
 * Valida los datos para actualizar un usuario
 * @param {Object} data - Objeto con datos a actualizar
 * @returns {Object} - { isValid: boolean, errors: string[] }
 */
export const validateUpdateUser = (data) => {
  const errors = [];
  const { nombre, correo, progreso } = data;

  // ---- Validar nombre (opcional) ----
  if (nombre !== undefined) {
    if (nombre.trim() === '') {
      errors.push('El nombre no puede estar vacío');
    } else if (!NAME_REGEX.test(nombre.trim())) {
      errors.push('El nombre debe tener entre 2 y 100 caracteres y solo contener letras');
    }
  }

  // ---- Validar correo (opcional) ----
  if (correo !== undefined) {
    if (correo.trim() === '') {
      errors.push('El correo no puede estar vacío');
    } else if (!EMAIL_REGEX.test(correo.trim())) {
      errors.push('El correo debe tener un formato válido');
    }
  }

  // ---- Validar progreso (opcional) ----
  if (progreso !== undefined) {
    if (typeof progreso !== 'number') {
      errors.push('El progreso debe ser un número');
    } else if (progreso < 0 || progreso > 100) {
      errors.push('El progreso debe estar entre 0 y 100');
    }
  }

  // ---- Retornar resultado ----
  return {
    isValid: errors.length === 0,
    errors
  };
};

export default {
  validateRegister,
  validateLogin,
  validateUpdateUser
};
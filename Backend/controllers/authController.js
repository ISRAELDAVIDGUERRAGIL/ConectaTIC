// ============================================================
// ARCHIVO: controllers/authController.js
// PROPÓSITO: Controlador de autenticación (registro y login)
// DESCRIPCIÓN: Maneja las solicitudes HTTP relacionadas con auth
//              y coordina con los servicios correspondientes
// ============================================================

// Importar servicios de autenticación
import * as authService from '../services/authService.js';

// Importar validadores
import { validateRegister, validateLogin } from '../validators/authValidator.js';

// Importar formateador de respuestas
import { created, badRequest, unauthorized, internalError, conflict } from '../utils/responseFormatter.js';

// ============================================================
// CONTROLADOR: Registro de usuario
// ============================================================

/**
 * Maneja el registro de nuevos usuarios
 * Valida los datos y llama al servicio de autenticación
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 * @param {Function} next - Función next de Express (para errores)
 */
export const register = async (req, res, next) => {
  try {
    console.log('🔔 CONTROLLER: Received register request', req.body);
    // ---- Obtener datos del body ----
    const { nombre, correo, password } = req.body;

    // ---- Validar datos ----
    const validation = validateRegister({ nombre, correo, password });

    if (!validation.isValid) {
      // Si la validación falla, retornar error 400
      return badRequest(res, 'Datos inválidos', validation.errors);
    }

    // ---- Llamar al servicio de registro ----
    console.log('🔔 Llamando al servicio registerUser...');
    const user = await authService.registerUser({ nombre, correo, password });
    console.log('✅ Usuario creado:', user);

    // ---- Responder con éxito (201 - Created) ----
    return created(res, 'Usuario registrado correctamente', {
      id: user.id,
      nombre: user.nombre,
      correo: user.correo
    });

  } catch (error) {
    console.error('❌ ERROR en controller register:', error.message);
    next(error);
  }
};

// ============================================================
// CONTROLADOR: Login de usuario
// ============================================================

/**
 * Maneja el inicio de sesión de usuarios
 * Valida credenciales y retorna token JWT
 * @param {Object} req - Request de Express
 * @param {Object} res - Response de Express
 * @param {Function} next - Función next de Express
 */
export const login = async (req, res, next) => {
  try {
    // ---- Obtener datos del body ----
    const { correo, password } = req.body;

    // ---- Validar datos ----
    const validation = validateLogin({ correo, password });

    if (!validation.isValid) {
      // Si la validación falla, retornar error 400
      return badRequest(res, 'Datos inválidos', validation.errors);
    }

    // ---- Llamar al servicio de login ----
    const result = await authService.loginUser({ correo, password });

    // ---- Responder con éxito ----
    return res.status(200).json({
      success: true,
      message: 'Login exitoso',
      token: result.token,
      user: result.user
    });

  } catch (error) {
    next(error);
  }
};

// ============================================================
// EXPORTAR CONTROLADORES
// ============================================================

export default {
  register,
  login
};
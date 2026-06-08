// ============================================================
// ARCHIVO: routes/auth.js
// PROPÓSITO: Rutas de autenticación
// DESCRIPCIÓN: Define los endpoints para registro y login
// ============================================================

// Importar Router de Express
import { Router } from 'express';

// Importar controladores de autenticación
import { register, login } from '../controllers/authController.js';

// Crear router
const router = Router();

// ============================================================
// RUTAS
// ============================================================

// POST /api/auth/register - Registrar nuevo usuario
router.post('/register', register);

// POST /api/auth/login - Iniciar sesión (con rate limiting en server.js)
router.post('/login', login);

// ============================================================
// EXPORTAR ROUTER
// ============================================================

export default router;
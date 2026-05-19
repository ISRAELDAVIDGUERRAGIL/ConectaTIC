// ============================================================
// ARCHIVO: routes/usuariosRoutes.js
// PROPÓSITO: Rutas de gestión de usuarios
// DESCRIPCIÓN: Define los endpoints para CRUD de usuarios
//              y actualización de progreso
// ============================================================

// Importar Router de Express
import { Router } from 'express';

// Importar controladores de usuarios
import {
  obtenerUsuarios,
  obtenerUsuarioPorId,
  crearUsuario,
  actualizarUsuario,
  actualizarProgreso,
  eliminarUsuario
} from '../controllers/usuariosController.js';

// Importar middleware de autenticación
import { verificarToken } from '../middlewares/authMiddleware.js';

// Crear router
const router = Router();

// ============================================================
// RUTAS PÚBLICAS (sin autenticación)
// ============================================================

// POST /api/usuarios - Crear usuario (público)
router.post('/', crearUsuario);

// ============================================================
// RUTAS PROTEGIDAS (requieren autenticación)
// ============================================================

// Aplicar middleware de autenticación a todas las rutas siguientes
router.use(verificarToken);

// GET /api/usuarios - Obtener todos los usuarios
router.get('/', obtenerUsuarios);

// GET /api/usuarios/:id - Obtener usuario por ID
router.get('/:id', obtenerUsuarioPorId);

// PUT /api/usuarios/progreso - Actualizar progreso del usuario logueado
router.put('/progreso', actualizarProgreso);

// PUT /api/usuarios/:id - Actualizar usuario
router.put('/:id', actualizarUsuario);

// DELETE /api/usuarios/:id - Eliminar usuario
router.delete('/:id', eliminarUsuario);

// ============================================================
// EXPORTAR ROUTER
// ============================================================

export default router;
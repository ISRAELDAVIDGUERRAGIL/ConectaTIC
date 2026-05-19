// ============================================================
// ARCHIVO: server.js
// PROPÓSITO: Punto de entrada del servidor Express
// DESCRIPCIÓN: Configura la aplicación, middlewares y rutas
// ============================================================

// ============================================================
// IMPORTS
// ============================================================

// Importar Express
import express from 'express';

// Importar CORS (permite solicitudes desde otros dominios)
import cors from 'cors';

// Importar dotenv para variables de entorno
import dotenv from 'dotenv';

// Importar rutas
import authRoutes from './routes/auth.js';
import usuariosRoutes from './routes/usuariosRoutes.js';
import errorHandler from './middlewares/errorHandler.js';

// Cargar variables de entorno
dotenv.config();

// ============================================================
// CONFIGURACIÓN DE EXPRESS
// ============================================================

// Crear aplicación Express
const app = express();

// Puerto del servidor (usar variable de entorno o 3000 por defecto)
const PORT = process.env.PORT || 3000;

// ============================================================
// MIDDLEWARES
// ============================================================

// CORS - Permitir solicitudes desde otros dominios
app.use(cors({
  origin: '*', // En producción, especificar los orígenes permitidos
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Body Parser - Parsear JSON en las solicitudes
app.use(express.json());

// Body Parser - Parsear datos URL-encoded (formularios)
app.use(express.urlencoded({ extended: true }));

// ============================================================
// RUTAS
// ============================================================

// Ruta base - Verificar que el servidor funciona
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'API ConectaTIC funcionando correctamente',
    version: '2.0.0',
    documentation: '/api/docs'
  });
});

// Rutas de autenticación
app.use('/api/auth', authRoutes);

// Rutas de usuarios
app.use('/api/usuarios', usuariosRoutes);

// ============================================================
// MANEJO DE ERRORES 404
// ============================================================

// Esta función se ejecuta cuando ninguna ruta coincide
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Ruta no encontrada',
    path: req.originalUrl
  });
});

// ============================================================
// MANEJO DE ERRORES GENERALES
// ============================================================

// Middleware de manejo de errores global (debe ser el último)
app.use(errorHandler);

// ============================================================
// INICIAR SERVIDOR
// ============================================================

import { initDb } from './config/db.js';

async function startServer() {
  await initDb();
  
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`
  ╔═══════════════════════════════════════════════════╗
  ║         Servidor ConectaTIC v2.0.0                ║
  ║                                                   ║
  ║   Servidor corriendo en: http://0.0.0.0:${PORT}       ║
  ║   Disponible para:                                ║
  ║   • localhost (PC)                                ║
  ║   • 192.168.1.4 (Celular/Emulador)               ║
  ║                                                   ║
  ║   Endpoints:                                      ║
  ║   • POST /api/auth/register                       ║
  ║   • POST /api/auth/login                          ║
  ║   • GET  /api/usuarios                            ║
  ║   • PUT  /api/usuarios/progreso                   ║
  ╚═══════════════════════════════════════════════════╝
    `);
  });
}

startServer();

export default app;
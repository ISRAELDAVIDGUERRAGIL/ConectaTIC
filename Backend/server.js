// ============================================================
// ARCHIVO: server.js
// PROPÓSITO: Punto de entrada del servidor Express
// DESCRIPCIÓN: Configura la aplicación, middlewares y rutas
// ============================================================

// ============================================================
// IMPORTS
// ============================================================

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { initDb } from './config/db.js';
import authRoutes from './routes/auth.js';
import usuariosRoutes from './routes/usuariosRoutes.js';
import errorHandler from './middlewares/errorHandler.js';

// Cargar variables de entorno
dotenv.config();

// ============================================================
// CONFIGURACIÓN
// ============================================================

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// ============================================================
// RATE LIMITERS
// ============================================================

// Rate limiter para endpoints de auth (estricto)
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // Máximo 5 intentos
  message: 'Demasiados intentos de autenticación. Intenta en 15 minutos',
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => NODE_ENV === 'development', // No limitar en desarrollo
});

// Rate limiter general (más permisivo)
const generalLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minuto
  max: 100, // Máximo 100 requests
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => NODE_ENV === 'development',
});

// ============================================================
// MIDDLEWARES DE SEGURIDAD
// ============================================================

// 🔒 Helmet - Añade headers de seguridad
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
    },
  },
}));

// 🔒 CORS - Restringir orígenes permitidos
const allowedOrigins = (process.env.ALLOWED_ORIGINS || 'http://localhost:3000,http://192.168.1.4:3000').split(',');
app.use(cors({
  origin: (origin, callback) => {
    // Permitir si no hay origin o está en la lista blanca
    if (!origin || allowedOrigins.includes(origin.trim())) {
      callback(null, true);
    } else {
      callback(new Error(`CORS no permitido para origen: ${origin}`));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  maxAge: 3600,
  optionsSuccessStatus: 200
}));

// 🔒 HTTPS Redirect en producción
if (NODE_ENV === 'production') {
  app.use((req, res, next) => {
    if (!req.secure && req.get('x-forwarded-proto') !== 'https') {
      return res.redirect('https://' + req.get('host') + req.url);
    }
    next();
  });
}

// ============================================================
// BODY PARSER CON LÍMITES
// ============================================================

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// ============================================================
// REQUEST LOGGING
// ============================================================

app.use((req, res, next) => {
  const startTime = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - startTime;
    const log = {
      timestamp: new Date().toISOString(),
      method: req.method,
      path: req.path,
      query: Object.keys(req.query).length ? req.query : undefined,
      statusCode: res.statusCode,
      durationMs: duration,
      ip: req.ip,
      userAgent: req.get('user-agent'),
    };
    
    // Solo log en producción o para errores
    if (NODE_ENV === 'production' || res.statusCode >= 400) {
      console.log(JSON.stringify(log));
    }
  });
  
  next();
});

// ============================================================
// RUTAS
// ============================================================

// 🏥 Health check
app.get('/api', (req, res) => {
  res.json({
    success: true,
    message: 'API ConectaTIC funcionando correctamente',
    version: '2.0.0',
    timestamp: new Date().toISOString(),
    environment: NODE_ENV,
  });
});

// 🔐 Autenticación (con rate limit)
app.use('/api/auth', authLimiter, authRoutes);

// 👥 Usuarios
app.use('/api/usuarios', generalLimiter, usuariosRoutes);

// ============================================================
// MANEJO DE RUTAS NO ENCONTRADAS
// ============================================================

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Ruta no encontrada: ${req.method} ${req.path}`,
    statusCode: 404,
  });
});

// ============================================================
// MANEJO DE ERRORES GLOBAL
// ============================================================

app.use(errorHandler);

// ============================================================
// INICIAR SERVIDOR
// ============================================================

async function startServer() {
  try {
    // Inicializar base de datos
    console.log('📊 Inicializando base de datos...');
    await initDb();
    
    // Iniciar servidor
    const server = app.listen(PORT, () => {
      console.log(`
╔═══════════════════════════════════════════════════╗
║         Servidor ConectaTIC v2.0.0                ║
║                                                   ║
║   Servidor corriendo en: http://0.0.0.0:${PORT}       ║
║   Entorno: ${NODE_ENV}                           ║
║                                                   ║
║   Endpoints:                                      ║
║   • POST   /api/auth/register                     ║
║   • POST   /api/auth/login                        ║
║   • GET    /api/usuarios                          ║
║   • PUT    /api/usuarios/progreso                 ║
║                                                   ║
║   Rate Limiting ACTIVO                            ║
║   Seguridad ACTIVA                                ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
      `);
    });

    // Graceful shutdown
    process.on('SIGTERM', () => {
      console.log('📍 Recibida señal SIGTERM. Cerrando servidor...');
      server.close(() => {
        console.log('✅ Servidor cerrado gracefully');
        process.exit(0);
      });
    });

  } catch (error) {
    console.error('❌ Error al iniciar servidor:', error.message);
    process.exit(1);
  }
}

// Iniciar servidor
startServer();

export default app;

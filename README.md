# 🎯 ConectaTIC v2.0.0

**Aplicación educativa para adultos mayores - Proyecto Gerencia de TI**

**🚀 NUEVO: Ahora con MySQL (PlanetScale) + Vercel + Flutter Web**

---

## 🌐 Acceso Web

**Aplicación Web:** `https://conectatic.vercel.app`  
**API Backend:** `https://conectatic-api.vercel.app/api`

⚠️ **En desarrollo** - Base de datos persistente con MySQL

---

## 📱 Descargar APK (Android)

**Enlace directo:**
- 📥 [Descargar ConectaTIC v2.3.0](https://drive.google.com/file/d/12HFg2awKNieGQVK7pRbfy0cIiGn_keyq/view?usp=sharing)

**O escanea el QR:**
- ![QR Code](./QR_CONECTATIC_APK_v2.3.0.png)

---

## 🔐 Credenciales de Prueba

Crea tu propia cuenta directamente en la app usando el botón **"Crear cuenta"**.

**Requisitos de contraseña:**
- Mínimo 8 caracteres
- Una mayúscula
- Una minúscula
- Un número
- Un símbolo especial (!, @, #, $, etc.)

**Ejemplo:**
```
Correo: tumail@gmail.com
Contraseña: MiPass123!
```

✅ **Los datos persisten permanentemente** en PlanetScale MySQL

---

## 🖥️ Backend

**URL Servidor:** `https://conectatic-api.vercel.app/api`

**Endpoints:**
- `POST /api/auth/register` - Crear cuenta
- `POST /api/auth/login` - Iniciar sesión
- `GET /api/usuarios` - Listar usuarios
- `PUT /api/usuarios/progreso` - Actualizar progreso
- `GET /api/usuarios/:id` - Obtener usuario
- `PUT /api/usuarios/:id` - Actualizar usuario
- `DELETE /api/usuarios/:id` - Eliminar usuario
- `GET /api` - Health check

**Stack:**
- Framework: Express.js (Node.js)
- Base de datos: PostgreSQL (Vercel Postgres)
- Autenticación: JWT (7 días)
- Hosting: Vercel (100% Gratis)

---

## 📋 Estructura del Proyecto

```
ConectaTIC/
├── Backend/
│   ├── config/              # Configuración de BD
│   ├── controllers/         # Controladores HTTP
│   ├── middlewares/         # Auth, rate limit, errores
│   ├── models/              # Modelos de datos
│   ├── routes/              # Definición de rutas
│   ├── services/            # Lógica de negocio
│   ├── tests/               # Suite de pruebas (67 tests ✅)
│   ├── utils/               # JWT, validación, respuestas
│   ├── validators/          # Validación de inputs
│   ├── package.json
│   ├── server.js            # Punto de entrada
│   └── .env                 # Variables de entorno
│
├── frontend/conectatic_app/ # Flutter
│   └── lib/
│       ├── core/            # Constantes, config
│       ├── providers/       # Estado (Auth)
│       ├── routes/          # Navegación (GoRouter)
│       ├── screens/         # Pantallas UI
│       ├── services/        # API, servicios
│       └── main.dart        # Punto de entrada
│
├── docs/                    # Documentación
├── qr-codes/                # Códigos QR
└── credentials/             # Archivos de credenciales
```

---

## ✅ Características

### Backend
- ✅ Autenticación JWT
- ✅ Encriptación de contraseñas (bcrypt)
- ✅ Rate limiting (5/15min auth, 100/min general)
- ✅ CORS restringido
- ✅ Helmet.js headers de seguridad
- ✅ Validación de inputs
- ✅ Manejo de errores global
- ✅ 67 tests automatizados

### Frontend
- ✅ Interfaz responsiva (Flutter)
- ✅ Gestión de estado (Provider)
- ✅ Navegación mejorada (GoRouter)
- ✅ Almacenamiento local (SharedPreferences)
- ✅ Login/Registro persistente
- ✅ APK compilado para Android

---

## 🚀 Instalación Local

### Backend
```bash
cd Backend
npm install
npm run dev  # Desarrollo
npm start    # Producción
npm test     # Ejecutar tests
```

### Frontend
```bash
cd frontend/conectatic_app
flutter pub get
flutter run          # Emulador/dispositivo
flutter build apk    # Compilar APK
```

---

## 🔒 Seguridad

- ✅ Contraseñas hasheadas (bcrypt - 10 rounds)
- ✅ JWT con expiración
- ✅ SQL injection prevention (whitelist fields)
- ✅ Rate limiting contra fuerza bruta
- ✅ CORS configurado
- ✅ Headers de seguridad HTTP
- ✅ Validación rigurosa de inputs

---

## 📊 Pruebas

**Suite completa (67/67 pasando):**
```bash
npm test                    # Todos
npm run test:unit          # Unitarios (38)
npm run test:integration   # Integración (23)
npm run test:security      # Seguridad (6+)
```

---

## 📝 Documentación

- `docs/ESTADO_FINAL.md` - Arquitectura y estado
- `docs/CHANGELOG_FINAL.md` - Historial de cambios
- `docs/README_DOCUMENTACION.md` - Documentación completa

---

## 🔗 Enlaces Importantes

- **GitHub:** https://github.com/Navas20/ConectaTIC
- **APK:** [Descargar v2.3.0](https://drive.google.com/file/d/12HFg2awKNieGQVK7pRbfy0cIiGn_keyq/view?usp=sharing)
- **Backend:** https://conectatic-production.up.railway.app/api

---

## ⚠️ Limitaciones Conocidas

- ~~Los datos persisten ~24-48 horas~~ ✅ **RESUELTO**: Ahora con MySQL persistente
- ~~Base de datos SQLite~~ ✅ **RESUELTO**: Migrada a PlanetScale MySQL
- ~~Backend en Railway~~ ✅ **RESUELTO**: Migrado a Vercel Serverless

---

## 📞 Soporte

Para problemas o preguntas:
1. Revisa la documentación en `docs/`
2. Consulta `DEPLOYMENT.md` para deployment
3. Revisa logs en Vercel: `vercel logs [proyecto]`
4. Verifica BD en PlanetScale dashboard

---

**Versión:** 2.3.0  
**Estado:** ✅ Producción  
**Última actualización:** 8 de Junio, 2026

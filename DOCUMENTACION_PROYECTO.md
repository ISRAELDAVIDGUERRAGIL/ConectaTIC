# 📚 DOCUMENTACIÓN COMPLETA - ConectaTIC

## Descripción General
**ConectaTIC** es una aplicación educativa para enseñar a personas mayores y sin experiencia tecnológica cómo usar teléfonos celulares, WhatsApp, correo electrónico e Internet de forma segura y práctica.

---

## 🏗️ ARQUITECTURA DEL PROYECTO

### Estructción General
```
ConectaTIC/
├── Backend/           (Servidor API con Node.js + Express)
│   ├── server.js           (Archivo principal del servidor)
│   ├── package.json        (Dependencias del proyecto)
│   ├── config/
│   │   └── db.js           (Configuración de conexión a MySQL)
│   ├── controllers/        (Lógica de negocio)
│   │   ├── authController.js      (Registro y Login)
│   │   └── usuariosController.js  (Gestión de usuarios)
│   ├── middlewares/        (Procesadores de solicitudes)
│   │   └── authMiddleware.js      (Verificación de JWT)
│   ├── models/             (Definición de datos)
│   │   └── usuario.js              (Modelo de Usuario)
│   └── routes/             (Definición de endpoints)
│       ├── authRoutes.js           (Rutas de autenticación)
│       └── usuariosRoutes.js       (Rutas de usuarios)
│
└── frontend/          (Aplicación móvil con Flutter)
    └── conectatic_app/
        ├── lib/
        │   └── main.dart   (Archivo principal con todas las pantallas)
        ├── pubspec.yaml    (Configuración y dependencias de Flutter)
        ├── android/        (Código nativo para Android)
        ├── ios/            (Código nativo para iOS)
        ├── windows/        (Código nativo para Windows)
        └── web/            (Versión web)
```

---

## 🔗 FLUJO DE COMUNICACIÓN

### 1️⃣ Backend → Base de Datos (MySQL)
- El servidor llama a las funciones de los **controllers**
- Los controllers usan el **pool de conexiones** definido en `config/db.js`
- Las queries SQL se ejecutan en la tabla `usuarios`

### 2️⃣ Frontend → Backend (API HTTP)
- La aplicación Flutter hace solicitudes HTTP al servidor:
  - **POST /api/usuarios** → Crear usuario (registro)
  - **POST /api/auth/registro** → Registrar con encriptación de contraseña
  - **POST /api/auth/login** → Autenticar usuario y devolver JWT
  - **GET /api/usuarios** → Obtener lista de usuarios
  - **PUT /api/usuarios/progreso** → Actualizar progreso

---

## 📡 ENDPOINTS DE LA API

### 🔐 Autenticación
| Metodo | Endpoint | Propósito | Datos |
|--------|----------|----------|-------|
| POST | `/api/auth/registro` | Registrar nuevo usuario | `{nombre, correo, contrasena}` |
| POST | `/api/auth/login` | Autenticar usuario | `{correo, contrasena}` |

### 👥 Usuarios
| Metodo | Endpoint | Propósito | Datos |
|--------|----------|----------|-------|
| GET | `/api/usuarios` | Obtener todos los usuarios | - |
| POST | `/api/usuarios` | Crear nuevo usuario | `{nombre, correo, contrasena}` |
| PUT | `/api/usuarios/progreso` | Actualizar progreso | `{idUsuario, incremento}` |

---

## 🔐 SEGURIDAD

### Encriptación de Contraseñas
- Se usa **bcryptjs** para hashear contraseñas de forma segura
- Cuando se registra: `contrasena` → `hash` (encriptada) → se guarda en BD
- Cuando se login: `contrasena` enviada se compara con el `hash` almacenado

### Tokens JWT
- Después de login exitoso, el servidor devuelve un **JWT token**
- El token contiene: `{ id, correo, rol }`
- El token expira según `JWT_EXPIRES_IN` en el `.env`
- El middleware `authMiddleware.js` verifica la validez del token

### Validaciones
- Campo requerido: nombre, correo, contraseña
- Contraseña mínimo 3 caracteres
- Correo único (no se puede registrar dos usuarios con el mismo correo)

---

## 🛠️ TECNOLOGÍAS USADAS

### Backend
- **Node.js + Express** → Framework para servidor web
- **MySQL** → Base de datos relacional
- **bcryptjs** → Encriptación de contraseñas
- **jsonwebtoken** → Autenticación con JWT
- **cors** → Permitir solicitudes desde otros dominios
- **dotenv** → Variables de entorno

### Frontend
- **Flutter (Dart)** → Framework para apps móviles
- **http** → Librería para solicitudes HTTP

---

## 🎨 PANTALLAS DE LA APP

### 1. **SplashScreen** (Bienvenida)
- Muestra el logo e información de ConectaTIC
- Botón "Comenzar" para ir a registro

### 2. **RegisterUserScreen** (Registro)
- Formulario con campos: nombre, correo, contraseña
- Se conecta al backend para registrar el usuario
- Muestra mensajes de éxito o error

### 3. **MainMenuScreen** (Menú Principal)
- Lista de 4 módulos disponibles:
  - ✅ Uso del celular
  - ✅ WhatsApp
  - ✅ Correo electrónico
  - ✅ Internet

### 4. **ModuleDetailScreen** (Detalle de Módulo)
- Muestra información detallada de cada módulo
- Incluye ejemplo práctico
- Botón para marcar como completado

### 5. **ProgressScreen** (Progreso)
- Barra visual del progreso del usuario (40% simulado)
- Explicación sobre cómo aumenta el progreso

---

## 🗄️ BASE DE DATOS

### Tabla: `usuarios`
```sql
CREATE TABLE usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) UNIQUE NOT NULL,
  contrasena VARCHAR(255) NOT NULL (hash de bcrypt),
  rol VARCHAR(50) DEFAULT 'usuario',
  progreso INT DEFAULT 0 (porcentaje 0-100)
);
```

---

## 🚀 CÓMO EJECUTAR EL PROYECTO

### Backend
```bash
cd Backend
npm install          # Instalar dependencias
npm run dev          # Ejecutar en modo desarrollo (http://localhost:3000)
npm start            # Ejecutar en modo producción
```

### Frontend
```bash
cd frontend/conectatic_app
flutter pub get      # Descargar dependencias
flutter run          # Ejecutar la app
```

---

## 📝 VARIABLES DE ENTORNO (.env)

Crear un archivo `.env` en la carpeta Backend con:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_contraseña
DB_NAME=conectatic_bd
DB_PORT=3306
JWT_SECRET=tu_clave_secreta_muy_segura
JWT_EXPIRES_IN=7d
PORT=3000
```

---

## ❌ ERRORES COMUNES

### "Error al conectar con MySQL"
- Verificar que MySQL esté corriendo
- Revisar las credenciales en `.env`

### "Correo ya está registrado"
- El correo ya existe en la BD
- Usar otro correo o limpiar la BD

### "Token inválido o expirado"
- El JWT ya expiró
- El usuario debe hacer login nuevamente

### Conexión rechazada (Frontend → Backend)
- Si usas emulador Android: `http://10.0.2.2:3000` ❌ **NO** `http://localhost:3000`
- Si usas celular físico: usar IP real de la PC (ej: `http://192.168.0.10:3000`)

---

## 📊 DISTRIBUCIÓN DE RESPONSABILIDADES

### Backend (server.js + controllers)
- ✅ Validar datos
- ✅ Encriptar contraseñas
- ✅ Generar y verificar JWT
- ✅ Guardar datos en BD
- ✅ Responder con códigos HTTP apropiados

### Frontend (main.dart)
- ✅ Mostrar pantallas
- ✅ Recopilar datos del usuario
- ✅ Enviar solicitudes HTTP
- ✅ Mostrar mensajes de error/éxito
- ✅ Navegar entre pantallas

---

## 🎯 PRÓXIMAS MEJORAS

- [ ] Agregar más módulos educativos
- [ ] Guardar y sincronizar progreso del usuario con backend
- [ ] Agregar video tutoriales
- [ ] Notificaciones push
- [ ] Painel de administración
- [ ] Tests unitarios
- [ ] Autenticación con Google/redes sociales

---

**Última actualización:** Abril 2026
**Versión:** 1.0.0
**Estado:** ✅ En desarrollo

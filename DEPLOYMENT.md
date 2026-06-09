# 🚀 GUÍA DE DEPLOYMENT - ConectaTIC v2.0.0

**Última actualización:** 8 de Junio 2026  
**Stack:** Express.js + MySQL (PlanetScale) + Vercel + Flutter Web

---

## 📋 TABLA DE CONTENIDOS

1. [Requisitos Previos](#requisitos-previos)
2. [FASE 1: PlanetScale MySQL](#fase-1-planetscale-mysql)
3. [FASE 2: Vercel Backend](#fase-2-vercel-backend)
4. [FASE 3: Flutter Web](#fase-3-flutter-web)
5. [Verificación Post-Deployment](#verificación-post-deployment)
6. [Troubleshooting](#troubleshooting)

---

## ✅ Requisitos Previos

Antes de comenzar, asegúrate de tener:

- [ ] Cuenta en [PlanetScale](https://planetscale.com) (gratuita)
- [ ] Cuenta en [Vercel](https://vercel.com) (gratuita)
- [ ] GitHub repo actualizado
- [ ] Node.js v18+ instalado localmente
- [ ] Flutter SDK (para web build)
- [ ] Git configurado

### Variables de Entorno Necesarias
```
JWT_SECRET           (mínimo 32 caracteres)
DB_HOST             (PlanetScale host)
DB_USER             (PlanetScale usuario)
DB_PASSWORD         (PlanetScale contraseña)
DB_NAME             (base de datos)
ALLOWED_ORIGINS     (dominios permitidos)
```

---

## FASE 1: PlanetScale MySQL

### Paso 1.1: Crear Cuenta PlanetScale

1. Ve a https://planetscale.com
2. Regístrate con GitHub o email
3. Crea una nueva organización
4. Crea base de datos: `conectatic`

### Paso 1.2: Obtener Connection String

```bash
# En PlanetScale dashboard:
1. Haz clic en "Databases" → "conectatic"
2. Haz clic en "Connect"
3. Selecciona "Node.js"
4. Copia la connection string:
   mysql://user:password@host.mysql.databases.cloud/database
```

### Paso 1.3: Crear Tabla en PlanetScale

```bash
# En PlanetScale dashboard:
1. Ve a "SQL Editor"
2. Ejecuta este SQL:
```

```sql
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  progreso INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Paso 1.4: Testear Localmente

```bash
# Copia .env.example a .env.local
cd Backend
cp .env.example .env.local

# Edita .env.local con tus credenciales de PlanetScale
# DB_HOST=your-host.mysql.databases.cloud
# DB_USER=your_user
# DB_PASSWORD=your_password
# DB_NAME=conectatic

# Instala dependencias
npm install

# Prueba conexión
NODE_ENV=development npm run dev

# Deberías ver:
# ✅ Conexión a MySQL establecida correctamente
# ✅ Tabla usuarios verificada/creada
```

---

## FASE 2: Vercel Backend

### Paso 2.1: Conectar GitHub a Vercel

```bash
# 1. Ve a https://vercel.com/dashboard
# 2. Haz clic en "New Project"
# 3. Selecciona tu repo GitHub "ConectaTIC"
# 4. Vercel detectará que es un proyecto Node.js
```

### Paso 2.2: Configurar Variables de Entorno

En Vercel dashboard:

```
Settings → Environment Variables

Agrega:
- NODE_ENV = production
- JWT_SECRET = (tu secreto de 32+ caracteres)
- DB_HOST = (PlanetScale host)
- DB_USER = (PlanetScale usuario)
- DB_PASSWORD = (PlanetScale contraseña)
- DB_NAME = conectatic
- ALLOWED_ORIGINS = https://conectatic.vercel.app,https://localhost:3000
```

### Paso 2.3: Deploy

```bash
# Opción A: Auto-deploy en push a main
git push origin main
# Vercel detectará y deployeará automáticamente

# Opción B: Deploy manual
vercel

# Selecciona las opciones y listo!
```

### Paso 2.4: Verificar Deployment

```bash
# Tu API estará en:
# https://tu-proyecto.vercel.app/api

# Prueba el endpoint:
curl https://tu-proyecto.vercel.app/api
# Deberías recibir:
# { "success": true, "message": "API ConectaTIC funcionando correctamente" }
```

---

## FASE 3: Flutter Web

### Paso 3.1: Build Flutter Web

```bash
cd frontend/conectatic_app

# Habilita Flutter web
flutter config --enable-web

# Build para web
flutter build web --web-renderer html

# Output en: build/web/
```

### Paso 3.2: Configurar URL de API

En `frontend/conectatic_app/lib/core/constants.dart`:

```dart
// Actualiza con tu URL de Vercel
class ApiConstants {
  static const String API_URL = 'https://tu-proyecto.vercel.app/api';
  static const String TIMEOUT = Duration(seconds: 30);
}
```

### Paso 3.3: Deploy a Vercel (Frontend)

```bash
# Crea nuevo proyecto en Vercel para el frontend
cd frontend/conectatic_app

# Opción A: Deploy manual
vercel

# Opción B: Conectar repo a Vercel
# En https://vercel.com/dashboard → New Project
# Selecciona el repo
# Root Directory: frontend/conectatic_app
# Build Command: flutter build web --release
# Output Directory: build/web
```

### Paso 3.4: Test Frontend

```
Tu app estará en: https://conectatic.vercel.app
```

---

## ✅ Verificación Post-Deployment

### Backend

```bash
# 1. Health check
curl https://api.vercel.app/api
# Respuesta esperada: { "success": true, "message": "..." }

# 2. Crear usuario
curl -X POST https://api.vercel.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Test User",
    "correo": "test@example.com",
    "password": "Test123!@#"
  }'

# Respuesta esperada: { "success": true, "id": 1, ... }

# 3. Logs en Vercel
vercel logs [project-name]
```

### Base de Datos

```bash
# En PlanetScale dashboard:
1. Ve a "SQL Editor"
2. Ejecuta:
   SELECT * FROM usuarios;

# Deberías ver los usuarios creados desde el frontend/API
```

### Frontend

```
Verifica en https://conectatic.vercel.app
- Pantalla de login carga
- Botón "Crear cuenta" funciona
- Registra un nuevo usuario
- Inicia sesión
- Dashboard carga correctamente
```

---

## 🔧 Troubleshooting

### Error: "Cannot find module 'mysql2'"

```bash
cd Backend
npm install mysql2
```

### Error: "CORS not allowed"

```
Verifica en Vercel dashboard:
Settings → Environment Variables
ALLOWED_ORIGINS debe incluir tu dominio del frontend
```

### Error: "JWT_SECRET no está definida"

```bash
# Genera una contraseña segura:
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Copia el output a Vercel env vars
```

### Error: "Connection timeout"

```
1. Verifica que PlanetScale host es correcto
2. Verifica usuario/contraseña de PlanetScale
3. Asegúrate que la tabla usuarios existe
4. Revisa logs en Vercel: vercel logs [project]
```

### Error: "Too many connections"

```
PlanetScale plan gratuito: máximo 10 conexiones simultáneas
Solución: Aumentar conexiones en Backend/config/db.js
connectionLimit: 10  →  connectionLimit: 5
```

---

## 📊 Monitoreo Continuado

### Logs en Vercel

```bash
vercel logs [project-name]          # Última 1 hora
vercel logs [project-name] --tail    # Time en vivo
```

### Estadísticas PlanetScale

```
https://app.planetscale.com/
→ Base de datos → conectatic → Insights
- Queries ejecutadas
- Conexiones activas
- Almacenamiento usado
```

### Health Checks

```bash
# Script automático (ejecutar cada 5 minutos)
#!/bin/bash
curl -s https://api.vercel.app/api | grep -q "success"
if [ $? -eq 0 ]; then
  echo "✅ API healthy"
else
  echo "❌ API down - Alert!"
fi
```

---

## 🔐 Seguridad Post-Deployment

- [ ] JWT_SECRET es una contraseña fuerte (32+ caracteres)
- [ ] DATABASE_PASSWORD no está en código (solo en env vars)
- [ ] CORS está restringido a dominios conocidos
- [ ] Rate limiting activo en /api/auth
- [ ] HTTPS forzado (automático en Vercel)
- [ ] Headers de seguridad activos (Helmet.js)

---

## 📞 Soporte

Si encuentras problemas:

1. Revisa logs: `vercel logs [proyecto]`
2. Verifica PlanetScale dashboard
3. Revisa archivos de error en GitHub
4. Consulta la documentación:
   - Express: https://expressjs.com
   - Vercel: https://vercel.com/docs
   - PlanetScale: https://planetscale.com/docs
   - Flutter: https://flutter.dev/docs

---

**Estado:** ✅ Listo para producción  
**Última revisión:** 8 de Junio 2026

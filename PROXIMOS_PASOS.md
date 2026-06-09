# 🚀 PRÓXIMOS PASOS - ConectaTIC Deployment

## ⏭️ Qué Hacer Ahora

Todo el código está **100% listo** para deployment. Solo necesitas:

---

## 1️⃣ PlanetScale MySQL (5 minutos)

### Paso 1: Crear cuenta
```
Visita: https://planetscale.com
Regístrate con GitHub o email
```

### Paso 2: Crear base de datos
```
1. Dashboard → New database
2. Nombre: conectatic
3. Región: La más cercana a tu ubicación
4. Crear base de datos
```

### Paso 3: Obtener credenciales
```
1. En dashboard, abre tu base de datos
2. Click en "Credentials"
3. Copia la connection string (tipo NODE.JS)
4. Copiar ejemplo:
   mysql://xxxxxx:xxxxxx@xxxxxxxx.mysql.databases.cloud/conectatic
```

### Paso 4: Actualizar .env
```bash
cd Backend
cp .env.example .env

# Edita .env con tus datos:
# Reemplaza estos:
DB_HOST=tu-host.mysql.databases.cloud
DB_USER=tu_usuario
DB_PASSWORD=tu_contraseña
DB_NAME=conectatic

# Y genera JWT_SECRET (32+ caracteres aleatorios):
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# Copia el output a JWT_SECRET en .env
```

---

## 2️⃣ Test Local (5 minutos)

```bash
cd Backend
npm install
npm run dev

# Debería mostrar:
# ✅ Conexión a MySQL establecida correctamente
# ✅ Tabla usuarios verificada/creada
# Servidor corriendo en: http://0.0.0.0:3000

# Testear en otra terminal:
curl http://localhost:3000/api
# Respuesta: { "success": true, ... }

# Presiona CTRL+C para detener
```

---

## 3️⃣ Vercel Backend Deploy (10 minutos)

### Paso 1: Crear cuenta Vercel
```
Visita: https://vercel.com
Regístrate con GitHub
```

### Paso 2: Conectar repo
```
1. En Vercel dashboard: New Project
2. Selecciona tu repo ConectaTIC
3. Vercel detectará Node.js automáticamente
```

### Paso 3: Configurar variables de entorno
```
En Vercel dashboard:
Settings → Environment Variables

Agrega:
- NODE_ENV                = production
- JWT_SECRET              = (tu secreto de arriba)
- DB_HOST                 = (PlanetScale host)
- DB_USER                 = (PlanetScale user)
- DB_PASSWORD             = (PlanetScale password)
- DB_NAME                 = conectatic
- ALLOWED_ORIGINS         = https://conectatic.vercel.app,http://localhost:3000
```

### Paso 4: Deploy
```
Haz git push a main:

git add .
git commit -m "Deploy: MySQL + Vercel + Flutter Web"
git push origin main

Vercel deployará automáticamente
URL: https://tu-proyecto.vercel.app
```

### Paso 5: Verificar
```bash
# Tu API estará en:
curl https://tu-proyecto.vercel.app/api
# Respuesta: { "success": true, ... }

# Ver logs:
vercel logs [nombre-proyecto]
```

---

## 4️⃣ Flutter Web Build (20 minutos)

### Paso 1: Build para web
```bash
cd frontend/conectatic_app

# Habilitar Flutter web (primera vez)
flutter config --enable-web

# Build optimizado
flutter build web --release

# Output en: build/web/
```

### Paso 2: Actualizar URL de API
En tu código Flutter, asegúrate que apunta a Vercel:

```dart
// lib/core/constants.dart o similar
const String API_URL = 'https://tu-proyecto.vercel.app/api';
```

### Paso 3: Deploy web a Vercel
```bash
# Opción A: CLI Vercel (si no la has usado)
npm install -g vercel
vercel

# Opción B: GitHub (automático)
# En Vercel dashboard → New Project
# Selecciona el repo
# Root Directory: frontend/conectatic_app
# Build Command: flutter build web --release
# Output Directory: build/web
```

---

## ✅ VERIFICACIÓN FINAL

### Backend
```bash
curl https://tu-proyecto.vercel.app/api
# Debe responder: { "success": true, "message": "..." }

# Ver logs
vercel logs [proyecto]
```

### Base de datos
```
PlanetScale dashboard → database → Insights
Ver queries, conexiones, almacenamiento
```

### Frontend Web
```
Visita: https://conectatic.vercel.app
Debe cargar la app Flutter Web
```

### Crear usuario de prueba
```
1. Haz click en "Crear cuenta"
2. Email: test@example.com
3. Contraseña: Test123!@#
4. Submit
5. Verifica en PlanetScale: SELECT * FROM usuarios;
```

---

## 🎯 CHECKLIST FINAL

- [ ] PlanetScale cuenta creada
- [ ] Base de datos "conectatic" creada
- [ ] Backend/.env actualizado con credenciales
- [ ] npm run dev funciona localmente
- [ ] Vercel conectado con repo GitHub
- [ ] Variables de entorno en Vercel configuradas
- [ ] Backend deployado en Vercel
- [ ] API responde en Vercel (curl test)
- [ ] Flutter Web build creado
- [ ] Frontend deployado en Vercel
- [ ] Puede crear usuario desde web
- [ ] Usuario visible en PlanetScale

---

## 🆘 SI ALGO FALLA

### Error: "Cannot connect to MySQL"
1. Verifica credenciales en .env
2. Verifica que base de datos existe en PlanetScale
3. Verifica que tabla usuarios existe (PlanetScale SQL Editor)

### Error: "CORS not allowed"
1. Verifica ALLOWED_ORIGINS en Vercel env vars
2. Debe incluir el dominio del frontend

### Error: "JWT_SECRET undefined"
1. Verifica que está en Backend/.env
2. Verifica que está en Vercel env vars

### Logs en Vercel
```bash
vercel logs [proyecto] --tail
# Mostrará logs en vivo
```

---

## 📞 DOCUMENTACIÓN DE REFERENCIA

Estos archivos están en tu repo:

- `DEPLOYMENT.md` - Guía completa (8KB)
- `REPORTE_IMPLEMENTACION.md` - Estado del código
- `REPORTE_ERRORES.md` - Errores que se corrigieron
- `Backend/.env.example` - Variables documentadas
- `frontend/conectatic_app/FLUTTER_WEB.md` - Flutter Web

---

## 🎉 ¡LISTO!

Cuando termines estos 4 pasos, tu aplicación estará completamente deployada con:

✅ Frontend web en Vercel (Flutter Web)  
✅ Backend API en Vercel (Express serverless)  
✅ Base de datos permanente en PlanetScale MySQL  
✅ Autenticación JWT funcional  

**Estimado:** 45-60 minutos total

---

**¿Necesitas ayuda con alguno de estos pasos? Avísame cuál es el siguiente y continuamos.**


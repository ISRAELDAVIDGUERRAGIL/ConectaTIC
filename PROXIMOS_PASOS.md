# 🚀 PRÓXIMOS PASOS - ConectaTIC Deployment

## ⏭️ Qué Hacer Ahora (TODO GRATIS CON VERCEL)

Todo el código está **100% listo**. Vercel Postgres viene incluido **gratis** con Vercel.

---

## 1️⃣ Crear Proyecto en Vercel (2 minutos)

### Paso 1: Conectar GitHub
```
Visita: https://vercel.com
Click: "New Project"
Selecciona: Tu repo ConectaTIC
Click: "Import"
```

### Paso 2: Vercel Crea la BD Automáticamente
```
En Vercel dashboard:
1. Abre tu proyecto
2. Ve a "Storage" → "Databases"
3. Click "Create Database"
4. Selecciona "PostgreSQL"
5. ¡Listo! Vercel lo configura todo automáticamente
```

### Paso 3: Agregar Variables de Entorno
```
En Vercel dashboard:
Settings → Environment Variables

Agrega:
- NODE_ENV = production
- JWT_SECRET = (generar comando abajo)
- ALLOWED_ORIGINS = https://tu-proyecto.vercel.app,http://localhost:3000

Las variables POSTGRES_URL* se crean automáticamente ✅
```

### Generar JWT_SECRET
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# Copia el output a JWT_SECRET en Vercel
```

---

## 2️⃣ Deploy Automático (1 minuto)

```bash
# Haz push a main
git add .
git commit -m "feat: Vercel Postgres integration - 100% free"
git push origin main

# Vercel deployará automáticamente
# Tu API estará en: https://tu-proyecto.vercel.app/api
```

---

## 3️⃣ Test Backend (2 minutos)

```bash
# Verificar que funciona
curl https://tu-proyecto.vercel.app/api
# Respuesta: { "success": true, ... }

# Crear usuario
curl -X POST https://tu-proyecto.vercel.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Test",
    "correo": "test@example.com",
    "password": "Test123!@#"
  }'

# Ver logs
vercel logs [nombre-proyecto]
```

---

## 4️⃣ Flutter Web Build (20 minutos)

### Paso 1: Build
```bash
cd frontend/conectatic_app

# Habilitar Flutter web (primera vez)
flutter config --enable-web

# Build
flutter build web --release

# Output: build/web/
```

### Paso 2: Actualizar URL
```dart
// lib/core/constants.dart
const String API_URL = 'https://tu-proyecto.vercel.app/api';
```

### Paso 3: Deploy Web
```bash
# En Vercel → New Project
# Root Directory: frontend/conectatic_app
# Build Command: flutter build web --release
# Output Directory: build/web

# O con CLI:
vercel --cwd frontend/conectatic_app
```

---

## ✅ CHECKLIST FINAL

- [ ] Proyecto creado en Vercel
- [ ] PostgreSQL BD creada en Vercel Storage
- [ ] Variables de entorno agregadas
- [ ] JWT_SECRET generado y agregado
- [ ] ALLOWED_ORIGINS configurado
- [ ] Push a main
- [ ] Backend deployado y testado
- [ ] Flutter Web build creado
- [ ] Frontend deployado
- [ ] Puede crear usuario desde web
- [ ] Usuario visible en BD

---

## 🎉 LISTO EN 25 MINUTOS

**Sin pagar nada. Todo gratis con Vercel.**

---

## 🆘 SI ALGO FALLA

### Error: "Database not found"
```
Vercel dashboard → Storage → Databases
¿Está la BD creada?
Si no, click "Create Database" → PostgreSQL
```

### Error: "CORS not allowed"
```
Vercel Settings → Environment Variables
ALLOWED_ORIGINS debe incluir tu dominio
```

### Error: "JWT_SECRET undefined"
```
Vercel Settings → Environment Variables
Agrega JWT_SECRET
```

### Logs en vivo
```bash
vercel logs [proyecto] --tail
```

---

## 📊 RESUMEN FINAL

**Costo:** 🟢 $0 (Completamente gratis)

**Infraestructura:**
```
Frontend Web:   https://conectatic.vercel.app
                (Flutter Web)

API Backend:    https://tu-proyecto.vercel.app/api
                (Express serverless)

Base de Datos:  Vercel Postgres
                (PostgreSQL incluido)

Todo en: https://vercel.com
```

---

**¿Listo para empezar?** Ve al Paso 1 ☝️

Generado: 8 de Junio 2026



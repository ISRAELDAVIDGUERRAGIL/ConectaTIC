# 📋 REPORTE DE ERRORES - PROYECTO CONECTATIC

**Fecha:** 08 de Junio de 2026  
**Proyecto:** ConectaTIC v2.0.0  
**Estado:** ⚠️ 6 Errores Encontrados (3 Críticos, 2 Moderados, 1 Menor)

---

## 🔴 ERRORES CRÍTICOS

### 1. **Root/package.json - Falta campo `type: "module"`**
- **Ubicación:** Root/package.json
- **Severidad:** 🔴 CRÍTICA
- **Problema:** El proyecto usa ES6 modules (import/export) pero falta `"type": "module"` en package.json
- **Impacto:** El proyecto no funcionará - Node.js lanzará error de sintaxis
- **Solución:** Agregar `"type": "module"` en package.json

**Error esperado:**
```
Error: Cannot use import statement outside a module
```

---

### 2. **Root/check-users.js - Dependencia no declarada: `pg`**
- **Ubicación:** check-users.js (Línea 1)
- **Severidad:** 🔴 CRÍTICA
- **Problema:** Importa `pg` pero no existe en package.json
- **Código:**
```javascript
import pg from 'pg';  // ❌ Módulo no instalado
```
- **Impacto:** El script fallará con "Cannot find module 'pg'"
- **Solución:** Ejecutar `npm install pg` o mover el script a Backend/

---

### 3. **Backend/services/authService.js - Indentación inconsistente (Línea 33-35)**
- **Ubicación:** Backend/services/authService.js (Línea 33)
- **Severidad:** 🔴 CRÍTICA
- **Problema:** Indentación incorrecta rompe la lógica del código
- **Código:**
```javascript
32.     const existingUser = await UsuarioModel.findByEmail(correo);
33. 
34.   if (existingUser) {  // ❌ Solo 2 espacios (debería ser 4)
35.     throw ApiError.conflict('El correo electrónico ya está registrado');
```
- **Impacto:** Sintaxis visual inconsistente, dificulta mantenimiento
- **Solución:** Arreglar indentación a 4 espacios

---

## 🟡 ERRORES MODERADOS

### 4. **Backend/services/authService.js - Indentación inconsistente (Línea 80)**
- **Ubicación:** Backend/services/authService.js (Línea 80)
- **Severidad:** 🟡 MODERADA
- **Problema:** Múltiples líneas con indentación incorrecta
- **Código:**
```javascript
79.   if (!isPasswordValid) {
80.     throw ApiError.unauthorized('Credenciales inválidas');
81.   }
82. 
83. const token = jwtService.signToken({  // ❌ Solo 0 espacios
84.       id: user.id,
```
- **Impacto:** Inconsistencia de estilos, dificulta lectura
- **Solución:** Normalizar indentación a 4 espacios

---

### 5. **Root/generate-qr.js vs generate-qr-final.js - Archivos duplicados**
- **Ubicación:** Raíz del proyecto
- **Severidad:** 🟡 MODERADA
- **Problema:** Dos archivos similares que generan QR
- **Archivos:**
  - `generate-qr.js` (no revisado)
  - `generate-qr-final.js` (existente)
- **Impacto:** Confusión sobre cuál usar, mantenimiento duplicado
- **Solución:** Eliminar uno de los archivos o unificar la lógica

---

## 🟢 ERRORES MENORES / WARNINGS

### 6. **Backend/services/authService.js - Exportación innecesaria (Línea 97)**
- **Ubicación:** Backend/services/authService.js (Línea 97)
- **Severidad:** 🟢 MENOR
- **Problema:** Exporta `verifyToken` que solo es un alias a `jwtService.verifyToken`
- **Código:**
```javascript
97. export const verifyToken = jwtService.verifyToken;  // ⚠️ Re-exportación innecesaria
```
- **Impacto:** Confusión sobre la fuente de la función
- **Recomendación:** Usar directamente `jwtService.verifyToken` desde los consumidores

---

## 📊 RESUMEN DE ERRORES

| Tipo | Cantidad | Prioridad |
|------|----------|-----------|
| 🔴 Críticos | 3 | INMEDIATA |
| 🟡 Moderados | 2 | ALTA |
| 🟢 Menores | 1 | NORMAL |
| **TOTAL** | **6** | - |

---

## 🔧 PLAN DE CORRECCIÓN

### Orden de Prioridad:

1. **[INMEDIATA]** Agregar `"type": "module"` en Root/package.json
   - Sin esto, el proyecto no funcionará

2. **[INMEDIATA]** Declarar dependencia `pg` en package.json
   - O mover check-users.js al Backend

3. **[ALTA]** Arreglar indentación en Backend/services/authService.js
   - Líneas 33-35 y 80-94

4. **[NORMAL]** Revisar y unificar archivos QR (generate-qr.js vs generate-qr-final.js)

5. **[MENOR]** Limpiar re-exportaciones innecesarias

---

## ✅ VERIFICACIÓN POST-CORRECCIÓN

Después de corregir, ejecutar:

```bash
# 1. Instalar dependencias
npm install

# 2. En Backend
cd Backend
npm install

# 3. Ejecutar linter (si existe)
npm run lint

# 4. Ejecutar tests
npm run test

# 5. Probar script check-users
node check-users.js

# 6. Probar servidor
npm run dev
```

---

**Generado por:** Copilot CLI  
**Contexto:** Revisión de código ConectaTIC

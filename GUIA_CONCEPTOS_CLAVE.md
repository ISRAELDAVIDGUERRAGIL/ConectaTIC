# 🎓 GUÍA DE CONCEPTOS CLAVE - ConectaTIC

## 1️⃣ BACKEND (Node.js + Express + MySQL)

### ¿Qué es un Backend?
El **backend** es el servidor que:
- Recibe solicitudes del frontend (app móvil)
- Procesa datos y validaciones
- Interactúa con la base de datos
- Devuelve respuestas al frontend

### 🔄 CICLO DE VIDA DE UNA SOLICITUD HTTP

```
FRONTEND (app)                    BACKEND (servidor)
     |                                  |
     |--- POST /api/auth/login ----|-->|
     |  (correo, contraseña)           |
     |                              [1] Recibe datos
     |                              [2] Valida
     |                              [3] Busca en BD
     |                              [4] Verifica contraseña
     |                              [5] Genera JWT
     |                              [6] Devuelve respuesta
     |<--- 200 OK + token ----------|
     |  {"token": "abc123..."}          |
     |                                  |
```

---

## 2️⃣ FLUJO DE REGISTRO

### Paso 1: Usuario llena el formulario (Frontend)
```
Nombre:  Juan García
Correo:  juan@gmail.com
Pass:    1234
```

### Paso 2: Frontend envía datos al Backend
```javascript
// main.dart (línea 300+)
final response = await http.post(
  'http://10.0.2.2:3000/api/usuarios',
  body: {
    'nombre': 'Juan García',
    'correo': 'juan@gmail.com',
    'contrasena': '1234'
  }
);
```

### Paso 3: Backend recibe y procesa (usuariosController.js)
```javascript
export const crearUsuario = async (req, res) => {
  // 1. Extraer datos
  const { nombre, correo, contrasena } = req.body;
  
  // 2. Validar que no estén vacíos
  if (!nombre || !correo || !contrasena) { error }
  
  // 3. Insertar en BD
  INSERT INTO usuarios VALUES (nombre, correo, contrasena)
  
  // 4. Responder al frontend
  res.status(201).json({ id: 5 })
};
```

### Paso 4: Backend guarda en BD
```sql
-- MySQL
INSERT INTO usuarios (nombre, correo, contrasena) 
VALUES ('Juan García', 'juan@gmail.com', '1234');

-- Resultado:
-- id=5, nombre='Juan García', correo='juan@gmail.com'
```

### Paso 5: Frontend recibe confirmación
```javascript
// Se ejecuta si fue exitoso
if (response.statusCode == 201) {
  Navigator.pushReplacement(...) // Ir a MainMenuScreen
}
```

---

## 3️⃣ ENCRIPTACIÓN DE CONTRASEÑAS (bcryptjs)

### ¿Por qué encriptar?
- **Seguridad**: Si alguien accede a la BD, no ve las contraseñas
- **Irreversible**: No se puede desencriptar (solo comparar)

### Proceso de Registro
```
Contraseña ingresada: "1234"
                   ↓ (bcrypt.hash)
Hash guardado en BD: "$2a$10$kHcVsXFl7zW3.JqV8YbF2edGjQKyAdZiA9A1N9z5T6eZxDfXx5sQe"
```

### Proceso de Login
```
Contraseña ingresada: "1234"
Hash en BD:           "$2a$10$kHcVsXFl7zW3.JqV8YbF2edGjQKyAdZiA9A1N9z5T6eZxDfXx5sQe"
                   ↓ (bcrypt.compare)
¿Coinciden? SÍ → Login exitoso ✅
            NO → Error de contraseña ❌
```

---

## 4️⃣ JWT (JSON Web Tokens)

### ¿Qué es?
Un token que permite mantener la sesión del usuario sin guardar datos en el servidor.

### Estructura
```
JWT = Header.Payload.Signature

Ejemplo:
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
 eyJpZCI6NSwic3ViIjoianVhbiJ9.
 LCa0a2j_xo_5m0U8HTBCNBNCLXBkg7-g-YpeiGJm564"

Descodificado:
{
  "id": 5,
  "correo": "juan@gmail.com",
  "rol": "usuario",
  "exp": 1681234567  // Expira a esta fecha
}
```

### Flujo con JWT
```
1. Login → Servidor genera JWT
2. Frontend almacena JWT
3. Frontend envía JWT con cada solicitud (en header)
4. Servidor verifica que JWT sea válido
5. Si es válido → procesa solicitud
   Si no → error 403 (acceso denegado)
```

---

## 5️⃣ MIDDLEWARES

### ¿Qué es un Middleware?
Una función que se ejecuta **antes** de llegar al controller, para:
- Validar datos
- Verificar autenticación
- Procesar información

### Ejemplo: authMiddleware.js
```javascript
const verificarToken = (req, res, next) => {
  // 1. Obtener token del header
  const token = req.headers['authorization'].split(' ')[1]
  
  // 2. Verificar que existe
  if (!token) { return error 401 }
  
  // 3. Verificar que sea válido
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET)
    req.usuario = decoded  // Pasar al siguiente
    next()  // Continuar al controller
  } catch {
    return error 403 (token inválido)
  }
}

// Uso en routes:
router.put('/perfil', verificarToken, actualizarPerfil)
//                    ↑ Middleware        ↑ Controller
```

---

## 6️⃣ CONEXIÓN A LA BASE DE DATOS

### Archivo: config/db.js
```javascript
const pool = mysql.createPool({
  host: 'localhost',        // Dónde está MySQL
  user: 'root',            // Usuario de MySQL
  password: 'tu_pass',     // Contraseña
  database: 'conectatic_bd' // Nombre de la BD
})

// pool permite reutilizar conexiones
// Sin pool: crear conexión → usar → cerrar (lento)
// Con pool: pool de 10 conexiones siempre disponibles (rápido)
```

### Ejecutar una query
```javascript
const [rows] = await pool.query(
  "SELECT * FROM usuarios WHERE correo = ?",
  ["juan@gmail.com"]
)

// rows = [{ id: 5, nombre: 'Juan', correo: 'juan@gmail.com' }]
```

---

## 7️⃣ FLUTTER (Frontend)

### Estructura de un Widget
```dart
// StatelessWidget = no cambia después de crearse
class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Estructura básica
      appBar: AppBar(title: Text('Título')),
      body: Column(  // Contenedor vertical
        children: [
          Text('Hola'),
          Button(child: Text('Presionar'))
        ]
      )
    );
  }
}

// StatefulWidget = puede cambiar de estado
class FormularioDinamico extends StatefulWidget {
  @override
  State<FormularioDinamico> createState() => _FormularioDinamicoState();
}

class _FormularioDinamicoState extends State<FormularioDinamico> {
  String nombre = '';
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (valor) {
        setState(() { nombre = valor; })  // Redibujar
      }
    );
  }
}
```

### Solicitud HTTP en Flutter
```dart
// main.dart línea ~300
Future<void> registrar() async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:3000/api/usuarios'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nombre': nombreController.text,
      'correo': correoController.text,
      'contrasena': contrasenaController.text
    })
  );
  
  if (response.statusCode == 201) {
    // Éxito → ir a siguiente pantalla
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => MainMenuScreen()
    ));
  } else {
    // Error → mostrar mensaje
    `showError(response.body)`;
  }
}
```

---

## 8️⃣ TABLA DE ERRORES COMUNES

| Error | Causa | Solución |
|-------|-------|----------|
| 400 Bad Request | Falta campo obligatorio | Llenar todos los campos |
| 401 Unauthorized | Token no válido/expirado | Volver a hacer login |
| 403 Forbidden | Token inválido | Verificar JWT_SECRET en .env |
| 404 Not Found | Endpoint no existe | Revisar URL |
| 500 Internal Error | Error en servidor | Ver logs en terminal |
| "Error de conexión" | App no llega a servidor | Revisar URL (10.0.2.2 vs IP real) |
| "Correo ya registrado" | Correo duplicado en BD | Usar otro correo |

---

## 9️⃣ CÓDIGOS DE ESTADO HTTP

```
1XX INFO          → Información
  100 Continue    → Continúa con la solicitud

2XX SUCCESS       → Solicitud exitosa
  200 OK          → Éxito general
  201 Created     → Recurso creado ✅
  204 No Content  → Éxito sin contenido

3XX REDIRECT      → Redirigir
  301 Moved       → Página movida
  302 Found       → Encontrada en otro lugar

4XX CLIENT ERROR  → Error en la solicitud
  400 Bad Request → Datos inválidos ❌
  401 Unauthorized → No autenticado
  403 Forbidden   → No autorizado
  404 Not Found   → No existe

5XX SERVER ERROR  → Error en el servidor
  500 Internal    → Error general ❌
  503 Unavailable → Servidor no disponible
```

---

## 🔟 RESUMEN DEL FLUJO COMPLETO

```
┌─────────────────────────────────────────────────────────┐
│                    USUARIO ABRE APP                     │
└────────────────────────┬────────────────────────────────┘
                         │
                    SplashScreen
                         │
                    "Comenzar"
                         │
                 RegisterUserScreen
                         │
              [Ingresa: nombre, correo, pass]
                         │
                    [Presiona "Guardar"]
                         │
    ┌────────────────────┴────────────────────┐
    │                                         │
    ▼                                         ▼
[FRONTEND]                               [BACKEND]
POST request                           Recibe datos
    │                                      │
    └───────────────────────────────────────┼────────────┐
                                           │            │
                                        Valida      Encripta
                                           │            │
                                        Valida      Inserta
                                           │            │
                                        Verifica     BD (MySQL)
                                           │            │
    ┌───────────────────────────────────────┼────────────┘
    │                                       │
    ▼                                       ▼
Recibe: { id: 5 }              Responde: 201 Created
    │
    └──► MainMenuScreen
         [Mostrar módulos]
         
         Usuario elige módulo
             │
         ModuleDetailScreen
             │
         "Marcar completado"
             │
         PUT /api/usuarios/progreso
             │
         ProgressScreen (40%)
```

---

## 📝 CHECKLIST CONCEPTOS CLAVE

- ✅ Backend = Servidor que procesa datos
- ✅ Frontend = App móvil que muestra UI
- ✅ API = Comunicación entre frontend y backend
- ✅ HTTP = Protocolo para enviar datos
- ✅ JWT = Token para mantener sesión
- ✅ bcryptjs = Encriptar contraseñas
- ✅ MySQL = Base de datos donde guardar info
- ✅ Express = Framework para crear servidor
- ✅ Flutter = Framework para app móvil
- ✅ Middleware = Función que se ejecuta antes del controller
- ✅ Pool de conexiones = Múltiples conexiones reutilizables
- ✅ Stateless vs Stateful = Widgets que cambian o no cambian

---

**Todos los comentarios han sido añadidos a los archivos del proyecto. ¡Ahora cada línea expl ica qué hace y por qué!** 🎉

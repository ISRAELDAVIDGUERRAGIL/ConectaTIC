# 🌐 ConectaTIC - Flutter Web

Versión web de la aplicación ConectaTIC para acceso desde navegador.

## 🚀 Inicio Rápido

### Desarrollo Local

```bash
# Habilitar Flutter web (primera vez)
flutter config --enable-web

# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run -d chrome

# O en Firefox
flutter run -d firefox
```

### Build para Producción

```bash
# Build web optimizado
flutter build web --web-renderer html --release

# Output en: build/web/
# Estos archivos son listos para Vercel
```

## 📦 Estructura

```
conectatic_app/
├── lib/
│   ├── core/              # Constantes y configuración
│   ├── providers/         # Estado (Auth, User)
│   ├── routes/            # Navegación con GoRouter
│   ├── screens/           # Pantallas UI
│   ├── services/          # API client
│   ├── widgets/           # Componentes reutilizables
│   └── main.dart          # Punto de entrada
├── pubspec.yaml           # Dependencias
├── build/
│   └── web/               # Output web (después de flutter build)
└── web/
    ├── index.html         # Página principal
    ├── favicon.ico        # Icono
    └── manifest.json      # PWA manifest
```

## 🔧 Dependencias Principales

- **http:** Comunicación con API
- **provider:** Gestión de estado
- **go_router:** Navegación moderna
- **shared_preferences:** Almacenamiento local
- **google_fonts:** Tipografía
- **flutter_animate:** Animaciones

## 🌐 Configuración de API

Antes de deployear, actualiza la URL de API en:

```dart
// lib/core/constants.dart
class ApiConstants {
  static const String API_URL = 'https://tu-api.vercel.app/api';
}
```

### Ambientes

Para manejar múltiples ambientes:

```dart
const String apiUrl = kDebugMode
    ? 'http://localhost:3000/api'      // Desarrollo
    : 'https://api.vercel.app/api';    // Producción
```

## 📱 PWA (Progressive Web App)

La app incluye configuración PWA para:
- Instalable en escritorio
- Offline capability (con service workers)
- Icono en pantalla principal

Ver `web/manifest.json` para personalizar.

## 📊 Performance

### Optimization Tips

```dart
// Usar lazy loading en listas
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListItem(index),
)

// Evitar rebuilds innecesarios con Consumer
Consumer<AuthProvider>(
  builder: (context, auth, _) => ...,
)

// Usar const constructors cuando sea posible
const SizedBox(height: 16)
```

## 🔐 Seguridad

- [ ] Token JWT almacenado en SharedPreferences
- [ ] HTTPS obligatorio en producción
- [ ] CORS configurado en backend
- [ ] Validación de inputs en frontend

## 🚀 Deploy a Vercel

### Opción 1: Conexión GitHub (Automática)

```bash
# En Vercel dashboard:
1. New Project
2. Selecciona repo ConectaTIC
3. Root Directory: frontend/conectatic_app
4. Build Command: flutter build web --release
5. Output Directory: build/web
```

### Opción 2: CLI Manual

```bash
# Instalar Vercel CLI
npm install -g vercel

# Deploy
cd frontend/conectatic_app
vercel

# Selecciona opciones y listo!
```

## 📝 Notas de Flutter Web

### Limitaciones Conocidas

- Performance inferior a app nativa
- No soporta ciertas features nativas
- Size del bundle más grande (~5MB)

### Workarounds

```dart
// Detectar si es web
import 'dart:io' show Platform;

if (kIsWeb) {
  // Code específico para web
} else if (Platform.isAndroid) {
  // Code para Android
}
```

## 🧪 Testing

```bash
# Tests unitarios
flutter test

# Análisis de código
flutter analyze

# Formato
dart format .
```

## 📞 Troubleshooting

### Error: "Command 'flutter' not found"
```bash
# Agrega Flutter al PATH:
export PATH="$PATH:~/flutter/bin"
```

### Error: "Chrome not found"
```bash
# Instala Chrome o usa Firefox
flutter run -d firefox
```

### Error: CORS al conectar API
```
Verifica en Backend:
ALLOWED_ORIGINS incluye https://tu-frontend.vercel.app
```

## 🔗 Enlaces Útiles

- [Flutter Web Docs](https://flutter.dev/multi-platform/web)
- [GoRouter Docs](https://pub.dev/packages/go_router)
- [Provider Docs](https://pub.dev/packages/provider)
- [Vercel Docs](https://vercel.com/docs)

---

**Última actualización:** 8 de Junio 2026  
**Versión:** 2.0.0

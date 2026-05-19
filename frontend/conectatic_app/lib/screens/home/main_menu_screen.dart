import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';

/// ============================================================
/// PANTALLA: MainMenuScreen (Home)
/// PROPÓSITO: Pantalla principal después del login
/// ESTILO: Gamificado, moderno, limpio, RESPONSIVE
/// ============================================================

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  static final List<Map<String, dynamic>> _celularContent = [
    {'title': 'El botón de Power', 'content': 'El botón de power está en el lateral del celular. Presiónalo para encender o apagar.', 'icon': Icons.power_settings_new_rounded},
    {'title': 'Ajustes del celular', 'content': 'En ajustes puedes cambiar el volumen, brillo, WiFi y más. Busca el ícono de la rueda.', 'icon': Icons.settings_rounded},
    {'title': 'Hacer llamadas', 'content': 'Abre la aplicación de teléfono, marca el número y presiona el botón verde para llamar.', 'icon': Icons.call_rounded},
    {'title': 'La cámara', 'content': 'Abre la cámara para tomar fotos. Apunta y toca el botón circular para capturar.', 'icon': Icons.camera_alt_rounded},
  ];

  static final List<Map<String, dynamic>> _whatsappContent = [
    {'title': '¿Qué es WhatsApp?', 'content': 'WhatsApp es una aplicación para enviar mensajes, fotos, videos y notas de voz a otras personas.', 'icon': Icons.chat_bubble_rounded},
    {'title': 'Enviar un mensaje', 'content': 'Abre un chat, escribe tu mensaje en la caja de texto y toca enviar (la flecha verde).', 'icon': Icons.send_rounded},
    {'title': 'Enviar fotos', 'content': 'Toca el ícono de cámara o adjunta para seleccionar una foto de tu galería y envíala.', 'icon': Icons.photo_library_rounded},
    {'title': 'Notas de voz', 'content': 'Mantén presionado el micrófono, habla y suelta para enviar un mensaje de voz.', 'icon': Icons.mic_rounded},
  ];

  static final List<Map<String, dynamic>> _correoContent = [
    {'title': '¿Qué es un correo?', 'content': 'El correo electrónico es como una carta digital. Se envía a través de internet.', 'icon': Icons.email_rounded},
    {'title': 'Escribir un correo', 'content': 'Abre Gmail, toca "+" para nuevo correo. Escribe el destinatario, el asunto y el mensaje.', 'icon': Icons.edit_rounded},
    {'title': 'Leer un correo', 'content': 'Toca un correo en tu bandeja de entrada para leerlo. Desliza para ver los siguientes.', 'icon': Icons.inbox_rounded},
    {'title': 'Responder un correo', 'content': 'Abre un correo y toca "Responder" para escribir una contestación.', 'icon': Icons.reply_rounded},
  ];

  static final List<Map<String, dynamic>> _internetContent = [
    {'title': '¿Qué es internet?', 'content': 'Internet es una red mundial que conecta millones de computadoras y celulares.', 'icon': Icons.language_rounded},
    {'title': 'El navegador', 'content': 'El navegador (Chrome, Safari) es una app para ver páginas web y buscar información.', 'icon': Icons.search_rounded},
    {'title': 'Buscar en internet', 'content': 'Abre el navegador, escribe lo que quieres buscar en la barra y toca buscar.', 'icon': Icons.find_in_page_rounded},
    {'title': 'El WiFi', 'content': 'El WiFi te conecta a internet sin cables. Actívalo en ajustes y conecta a una red.', 'icon': Icons.wifi_rounded},
  ];

  static final List<Map<String, dynamic>> _celularExercises = [
    {'type': 'multiple_choice', 'question': '¿Qué botón enciende el celular?', 'options': ['Cámara', 'Power', 'Volumen', 'Menú'], 'correct': 1, 'explanation': 'El botón power enciende y apaga el celular'},
    {'type': 'true_false', 'question': 'El botón de volumen controla el sonido.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'El botón de volumen sirve para subir o bajar el sonido'},
    {'type': 'order', 'question': 'Ordena: Apagar celular', 'words': ['Apagar', 'celular', 'Power'], 'correctOrder': [2, 0, 1], 'explanation': 'Se presiona el botón power para apagar'},
    {'type': 'multiple_choice', 'question': '¿Dónde están los ajustes del celular?', 'options': ['En la cámara', 'En ajustes', 'En WhatsApp', 'En contactos'], 'correct': 1, 'explanation': 'Los ajustes están en el ícono de ajustes (rueda)'},
    {'type': 'true_false', 'question': 'Se puede hacer llamadas desde el celular.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'El celular permite hacer y recibir llamadas'},
    {'type': 'multiple_choice', 'question': '¿Para qué sirve la cámara?', 'options': ['Para llamadas', 'Para fotos', 'Para internet', 'Para mensajes'], 'correct': 1, 'explanation': 'La cámara sirve para tomar fotografías'},
  ];

  static final List<Map<String, dynamic>> _whatsappExercises = [
    {'type': 'multiple_choice', 'question': '¿Qué es WhatsApp?', 'options': ['Una cámara', 'Una app de mensajes', 'Un navegador', 'Un juego'], 'correct': 1, 'explanation': 'WhatsApp es una aplicación para enviar mensajes'},
    {'type': 'true_false', 'question': 'Por WhatsApp se pueden enviar fotos.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'WhatsApp permite enviar fotos, videos y mensajes de voz'},
    {'type': 'order', 'question': 'Ordena: Enviar mensaje', 'words': ['Escribir', 'mensaje', 'Abrir', 'Enviar'], 'correctOrder': [2, 0, 1, 3], 'explanation': 'Primero abres WhatsApp, luego escribes el mensaje y lo envías'},
    {'type': 'multiple_choice', 'question': '¿Qué es una nota de voz?', 'options': ['Un video', 'Un mensaje de audio', 'Una foto', 'Un emoji'], 'correct': 1, 'explanation': 'La nota de voz es un mensaje de audio que se graba'},
    {'type': 'true_false', 'question': 'WhatsApp es gratis.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'WhatsApp es una aplicación gratuita'},
    {'type': 'multiple_choice', 'question': '¿Cómo saber si alguien leyó tu mensaje?', 'options': ['No se puede', 'Por las palomitas', 'Por la cámara', 'Por un emoji'], 'correct': 1, 'explanation': 'Las palomitas azules indican que el mensaje fue leído'},
  ];

  static final List<Map<String, dynamic>> _correoExercises = [
    {'type': 'multiple_choice', 'question': '¿Qué es un correo electrónico?', 'options': ['Un mensaje de texto', 'Una carta digital', 'Una llamada', 'Una foto'], 'correct': 1, 'explanation': 'El correo electrónico es como una carta digital'},
    {'type': 'true_false', 'question': 'Gmail es un servicio de correo.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'Gmail es el servicio de correo de Google'},
    {'type': 'order', 'question': 'Ordena: Escribir correo', 'words': ['Nuevo', 'escribir', 'destinatario', 'enviar'], 'correctOrder': [0, 2, 1, 3], 'explanation': 'Primero creas un nuevo correo, agregas el destinatario, escribes y envías'},
    {'type': 'multiple_choice', 'question': '¿Qué es el destinatario?', 'options': ['El que recibe', 'El que envía', 'El assunto', 'El mensaje'], 'correct': 0, 'explanation': 'El destinatario es la persona que recibe el correo'},
    {'type': 'true_false', 'question': 'Se pueden agregar archivos a un correo.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'Se pueden adjuntar fotos, documentos y otros archivos'},
    {'type': 'multiple_choice', 'question': '¿Qué es responder un correo?', 'options': ['Borrarlo', 'Escribir de vuelta', 'Archivarlo', 'Reenviarlo'], 'correct': 1, 'explanation': 'Responder es escribir una contestación al correo recibido'},
  ];

  static final List<Map<String, dynamic>> _internetExercises = [
    {'type': 'multiple_choice', 'question': '¿Qué es internet?', 'options': ['Una app', 'Una red mundial de información', 'Un juego', 'Una cámara'], 'correct': 1, 'explanation': 'Internet es una red mundial que conecta computadoras y celulares'},
    {'type': 'true_false', 'question': 'El navegador sirve para buscar información.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'El navegador (Chrome, Safari) permite buscar y ver páginas web'},
    {'type': 'order', 'question': 'Ordena: Buscar en internet', 'words': ['Navegador', 'escribir', 'búsqueda', 'abrir'], 'correctOrder': [0, 3, 1, 2], 'explanation': 'Primero abres el navegador, luego escribes lo que quieres buscar'},
    {'type': 'multiple_choice', 'question': '¿Qué es el WiFi?', 'options': ['Un juego', 'Una conexión inalámbrica', 'Un correo', 'Una cámara'], 'correct': 1, 'explanation': 'El WiFi es una conexión inalámbrica a internet'},
    {'type': 'true_false', 'question': 'Se puede ver videos por internet.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'YouTube y otras plataformas permiten ver videos en internet'},
    {'type': 'multiple_choice', 'question': '¿Qué es una página web?', 'options': ['Un documento', 'Un sitio con información', 'Una foto', 'Un mensaje'], 'correct': 1, 'explanation': 'Una página web es un sitio con información que se puede ver en el navegador'},
  ];

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de pantalla para hacerlo responsive
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    
    // Calcular tamaños relativos (responsive)
    final padding = width * 0.06; // 6% del ancho
    final titleSize = width > 400 ? 28.0 : 24.0;
    final iconSize = width > 400 ? 28.0 : 24.0;
    final cardPadding = width > 400 ? 20.0 : 16.0;

    // Obtener usuario del provider
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

// Lista de módulos/cursos disponibles con contenido y ejercicios
    final modules = [
      {
        'titulo': 'Uso del celular',
        'descripcion': 'Aprende a usar tu celular desde cero',
        'icon': Icons.phone_android,
        'color': const Color(0xFF58CC02),
        'content': _celularContent,
        'exercises': _celularExercises,
        'videoPath': 'assets/videos/modulo1.mp4',
      },
      {
        'titulo': 'WhatsApp',
        'descripcion': 'Enviar mensajes, fotos y notas de voz',
        'icon': Icons.chat_bubble,
        'color': const Color(0xFF25D366),
        'content': _whatsappContent,
        'exercises': _whatsappExercises,
        'videoPath': 'assets/videos/modulo2.mp4',
      },
      {
        'titulo': 'Correo electrónico',
        'descripcion': 'Crear, leer y responder correos',
        'icon': Icons.email,
        'color': const Color(0xFF1CB0F6),
        'content': _correoContent,
        'exercises': _correoExercises,
      },
      {
        'titulo': 'Internet',
        'descripcion': 'Buscar información de forma segura',
        'icon': Icons.language,
        'color': const Color(0xFFFFC800),
        'content': _internetContent,
        'exercises': _internetExercises,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.015),
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school_rounded,
                color: const Color(0xFF58CC02),
                size: iconSize,
              ),
            ),
            SizedBox(width: width * 0.025),
            const Text('ConectaTIC'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, size: iconSize),
            onPressed: () async {
              await authProvider.logout();
              if (!context.mounted) return;
              context.go('/auth');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, user, width),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saludo al usuario
                Text(
                  '¡Hola de nuevo! 👋',
                  style: TextStyle(
                    fontSize: titleSize * 0.85,
                    color: const Color(0xFF3C3C3C).withOpacity(0.7),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  user?.nombre ?? 'Usuario',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3C3C3C),
                  ),
                ),
                
                SizedBox(height: height * 0.03),
                
                // Card de progreso
                _buildProgressCard(context, user?.progreso ?? 0, constraints.maxWidth)
                    .animate()
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
                
                SizedBox(height: height * 0.04),
                
                // Título de cursos
                Row(
                  children: [
                    Icon(Icons.play_circle_rounded, color: const Color(0xFF58CC02), size: iconSize),
                    SizedBox(width: width * 0.025),
                    Text(
                      'Continuar aprendiendo',
                      style: TextStyle(
                        fontSize: titleSize * 0.9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3C3C3C),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: height * 0.02),
                
                // Lista de módulos
                ...modules.asMap().entries.map((entry) {
                  final index = entry.key;
                  final module = entry.value;
                  return _buildModuleCard(context, module, constraints.maxWidth)
                      .animate()
                      .fade(delay: (100 * index).ms, duration: 400.ms)
                      .slideX(begin: 0.1, end: 0);
                }),
                
                SizedBox(height: height * 0.03),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget del Drawer
  Widget _buildDrawer(BuildContext context, user, double screenWidth) {
    final isWide = screenWidth > 400;
    
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header del menú
            Container(
              padding: EdgeInsets.all(isWide ? 20 : 16),
              decoration: const BoxDecoration(
                color: Color(0xFF58CC02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isWide ? 10 : 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_circle,
                      size: isWide ? 36 : 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isWide ? 10 : 8),
                  Text(
                    '¡Hola, ${user?.nombre ?? 'Usuario'}!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWide ? 16 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    user?.correo ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isWide ? 12 : 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Opciones del menú
            ListTile(
              leading: Icon(Icons.home_rounded, size: isWide ? 26 : 22),
              title: Text('Inicio', style: TextStyle(fontSize: isWide ? 16 : 14)),
              contentPadding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 16, vertical: 4),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_rounded, size: isWide ? 26 : 22),
              title: Text('Mi progreso', style: TextStyle(fontSize: isWide ? 16 : 14)),
              contentPadding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 16, vertical: 4),
              onTap: () {
                Navigator.pop(context);
                context.go('/progress');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: const Color(0xFFFF4B4B), size: isWide ? 26 : 22),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(color: const Color(0xFFFF4B4B), fontSize: isWide ? 16 : 14),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 16, vertical: 4),
              onTap: () async {
                Navigator.pop(context);
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget para la card de progreso
  Widget _buildProgressCard(BuildContext context, int progreso, double screenWidth) {
    final isWide = screenWidth > 350;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 24 : 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF58CC02), Color(0xFF46A302)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58CC02).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isWide ? 10 : 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: isWide ? 28 : 24,
                ),
              ),
              SizedBox(width: isWide ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu progreso',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isWide ? 14 : 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$progreso%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWide ? 28 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: const Color(0xFFFFC800), size: isWide ? 20 : 16),
                    SizedBox(width: 4),
                    Text(
                      '+$progreso XP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isWide ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isWide ? 20 : 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso / 100,
              minHeight: isWide ? 10 : 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: isWide ? 12 : 8),
          Text(
            progreso < 100 
                ? '¡Sigue así! Cada lección cuenta 🚀'
                : '¡Felicidades! Has completado todo 🎉',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isWide ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para las cards de módulos
  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> module, double screenWidth) {
    final isWide = screenWidth > 350;
    final iconSize = isWide ? 60.0 : 50.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: isWide ? 16 : 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: () => context.push(
            '/module',
            extra: {
              'titulo': module['titulo'],
              'descripcion': module['descripcion'],
              'content': module['content'],
              'exercises': module['exercises'],
              'videoPath': module['videoPath'],
            },
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(isWide ? 20 : 16),
            child: Row(
              children: [
                // Icono del módulo
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: (module['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    module['icon'] as IconData,
                    color: module['color'] as Color,
                    size: isWide ? 30 : 26,
                  ),
                ),
                SizedBox(width: isWide ? 16 : 12),
                
                // Título y descripción
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module['titulo'] as String,
                        style: TextStyle(
                          fontSize: isWide ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3C3C3C),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        module['descripcion'] as String,
                        style: TextStyle(
                          fontSize: isWide ? 14 : 12,
                          color: const Color(0xFF3C3C3C).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Flecha
                Container(
                  padding: EdgeInsets.all(isWide ? 10 : 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xFF3C3C3C),
                    size: isWide ? 18 : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
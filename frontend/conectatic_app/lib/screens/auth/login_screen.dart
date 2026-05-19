import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

/// ============================================================
/// PANTALLA: LoginScreen
/// PROPÓSITO: Autenticación de usuarios existentes
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  String? _errorMessage;
  String _debugStatus = 'Listo';

  @override
  void dispose() {
    // Limpiar controladores al destruir el widget
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  /// Método para procesar el inicio de sesión
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _debugStatus = '1. Iniciando...');
    
    final authProvider = context.read<AuthProvider>();
    
    try {
      setState(() => _debugStatus = '2. Llamando al servidor...');
      
      final result = await authProvider.login(
        correo: _correoController.text.trim(),
        password: _contrasenaController.text,
      ).timeout(const Duration(seconds: 15));

      setState(() => _debugStatus = '3. Respuesta recibida: $result');

      // Si hay error, mostrar pantalla completa de error
      if (result['success'] != true) {
        if (mounted) {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (ctx) => Scaffold(
                appBar: AppBar(title: const Text('ERROR')),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 80, color: Colors.red),
                        const SizedBox(height: 20),
                        Text(
                          'Error: ${result['message'] ?? 'Desconocido'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Detalles: $result',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return;
      }

      // Si login exitoso, ir al home
      if (result['success'] == true) {
        print('Login exitoso!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido!'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go('/home');
        }
        return;
      }

      // Si falló, mostrar error
      _errorMessage = result['message'] as String? ?? 'Error desconocido';
      print('Login falló: $_errorMessage');
      
      // También mostrar en la UI como texto
      setState(() {
        _errorMessage = 'Error: $_errorMessage';
      });
      return;
    } catch (e) {
      if (!mounted) return;
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: const Text('ERROR DE CONEXIÓN')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    const Text(
                      'No se pudo conectar al servidor',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Error: $e',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('INTENTAR DE NUEVO'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observar estado de carga
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/auth'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DEBUG STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text(
                'DEBUG: $_debugStatus',
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            
            // Título principal
            Text(
              '¡Bienvenido de vuelta! 👋',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3C3C3C),
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtítulo
            Text(
              'Ingresa tu correo y contraseña para continuar',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF3C3C3C).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            
            // Formulario de login
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo de correo
                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email_outlined),
                      prefixIconColor: const Color(0xFF58CC02),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      if (!value.contains('@')) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Campo de contraseña
                  TextFormField(
                    controller: _contrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      prefixIconColor: const Color(0xFF58CC02),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  
                  // Mensaje de error
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4B4B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFF4B4B)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Color(0xFFFF4B4B)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Color(0xFFFF4B4B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón de iniciar sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white, 
                                strokeWidth: 3,
                              ),
                            )
                          : const Text('Continuar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Enlace a registro
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('¿No tienes cuenta? Crear una'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

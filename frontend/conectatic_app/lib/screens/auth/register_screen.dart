import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

/// ============================================================
/// PANTALLA: RegisterScreen
/// PROPÓSITO: Registro de nuevos usuarios
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Key del formulario para validación
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  
  // Mensaje de error
  String? _errorMessage;

  @override
  void dispose() {
    // Limpiar controladores al destruir el widget
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  /// Método para procesar el registro
  Future<void> _submit() async {
    // Validar formulario primero
    if (!_formKey.currentState!.validate()) return;

    // Obtener provider de autenticación
    final authProvider = context.read<AuthProvider>();
    
    // Llamar al servicio de registro
    final result = await authProvider.register(
      nombre: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      password: _contrasenaController.text,
    );

    // Verificar si el widget sigue montado
    if (!mounted) return;

    // Si el registro fue exitoso, navegar al login
    if (result['success'] == true) {
      context.go('/login');
      return;
    }

    // Si falló, mostrar error
    setState(() {
      final errors = result['errors'];
      if (errors != null && errors is List) {
        _errorMessage = errors.join('\n');
      } else {
        _errorMessage = result['message'] as String? ?? 'No se pudo registrar';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_errorMessage!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Observar estado de carga
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Crear cuenta'),
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
            // Título principal
            Text(
              '¡Únete a ConectaTIC! 🎉',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3C3C3C),
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtítulo
            Text(
              'Crea tu cuenta para empezar a aprender',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF3C3C3C).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            
            // Formulario de registro
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo de nombre
                  TextFormField(
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: const Icon(Icons.person_outlined),
                      prefixIconColor: const Color(0xFF58CC02),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
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
                      helperText: 'Mínimo 6 caracteres',
                      helperStyle: TextStyle(
                        color: const Color(0xFF3C3C3C).withOpacity(0.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es requerida';
                      }
                      if (value.length < 6) {
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
                  
                  // Botón de crear cuenta
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
                          : const Text('Crear cuenta'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Enlace a login
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('¿Ya tienes cuenta? Iniciar sesión'),
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
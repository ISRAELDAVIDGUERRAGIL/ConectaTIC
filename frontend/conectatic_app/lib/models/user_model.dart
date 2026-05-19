/// Modelo de usuario autenticado en ConectaTIC.
class UserModel {
  final int id;
  final String nombre;
  final String correo;
  final int progreso;
  final String? rol;

  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.progreso,
    this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      progreso: json['progreso'] as int,
      rol: json['rol'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'progreso': progreso,
      if (rol != null) 'rol': rol,
    };
  }
}

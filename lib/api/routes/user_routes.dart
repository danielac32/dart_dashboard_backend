import 'dart:async';
import 'dart:js_interop';

import 'package:alfred/alfred.dart';

import '../controllers/user_controller.dart';


/// Middleware para validar los campos email y password
FutureOr validateLoginUserMiddleware(HttpRequest req, HttpResponse res) async {
    // Parsear el cuerpo de la solicitud como un Map<String, dynamic>
    final body = await req.bodyAsJsonMap;

    // Extraer los campos email y password
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    // Validar que ambos campos existan
    if (email == null || password == null) {
      throw AlfredException(400, {'error': 'Los campos email y password son requeridos'});
    }
    // Validar el formato del correo electrónico
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      throw AlfredException(400, {'error': 'El formato del correo electrónico es inválido'});
    }
    print("validateLogin ok");
}


FutureOr checkPassWordLengthRegisterMiddleware(HttpRequest req, HttpResponse res) async {
  // Parsear el cuerpo de la solicitud como un Map<String, dynamic>
  final body = await req.bodyAsJsonMap;
  //final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (password == null || password.isEmpty) {
    throw AlfredException(400, {'error': 'campo password requeridos'});
  }
  if (password.length < 6) {
    throw AlfredException(400, {'error': 'contraseña menor a 6'});
  }

}


/// Middleware para validar los campos email y password
FutureOr validateRegisterUserMiddleware(HttpRequest req, HttpResponse res) async {
  // Parsear el cuerpo de la solicitud como un Map<String, dynamic>
  final body = await req.bodyAsJsonMap;

  // Extraer los campos email y password
  final email = body['email'] as String?;
  final password = body['password'] as String?;
  final role = body['role'] as String?;
  final name = body['name'] as String?;
  final department = body['department'] as String?;


  // Validar que ambos campos existan
  if (email == null || email.isEmpty) {
    throw AlfredException(400, {'error': 'campo email requeridos'});
  }
  if (password == null || password.isEmpty) {
    throw AlfredException(400, {'error': 'campo password requeridos'});
  }
  if (role == null || role.isEmpty) {
    throw AlfredException(400, {'error': 'campo role requeridos'});
  }
  if (name == null || name.isEmpty) {
    throw AlfredException(400, {'error': 'campo name requeridos'});
  }
  if (department == null || department.isEmpty) {
    throw AlfredException(400, {'error': 'campo department requeridos'});
  }
  // Validar el formato del correo electrónico
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    throw AlfredException(400, {'error': 'El formato del correo electrónico es inválido'});
  }
  print("validateRegister ok");
}



void configureUserRoutes(Alfred app, UserController userController) {
  // Grupo de rutas para autenticación
  app.post('/auth/register', userController.registerUser,middleware: [validateRegisterUserMiddleware,checkPassWordLengthRegisterMiddleware]);
  app.post('/auth/login', userController.loginUser,middleware: [validateLoginUserMiddleware]);

  // Grupo de rutas para gestión de usuarios
  app.get('/users', userController.listUsers);
  app.get('/users/:id', userController.getUserProfile);
  app.put('/users/:id', userController.updateUserProfile);
  app.delete('/users/:id', userController.deleteUser);

  // Puedes agregar middleware específico para rutas protegidas
  app.all('/users/*', (req, res) {
    // Middleware de autenticación para rutas de usuarios
    if (req.headers['authorization'] == null) {
      throw AlfredException(401, {'error': 'No autorizado'});
    }
    // Aquí validarías el token JWT
    return true;
  });
}
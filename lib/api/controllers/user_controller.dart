import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend/model/app_strings.dart';
import 'package:dart_dashboard_backend/model/model.dart';

import '../../model/service.dart';

class RegisterUserRequest {
  final String email;
  final String password;
  final String name;
  final String department;
  final String role;

  RegisterUserRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.department,
    this.role = AppStrings.user, // Valor predeterminado para el rol
  });

  /// Método estático para crear una instancia desde un Map<String, dynamic>
  static RegisterUserRequest fromJson(Map<String, dynamic> json) {
    final email = json['email'] as String?;
    final password = json['password'] as String?;
    final name = json['name'] as String?;
    final department = json['department'] as String?;
    final role = json['role'] as String?;

    if (email == null || password == null || name == null || department == null) {
      throw AlfredException(400, {'error': 'Todos los campos son requeridos: email, password, name, department'});
    }

    return RegisterUserRequest(
      email: email,
      password: password,
      name: name,
      department: department,
      role: role ?? AppStrings.user,
    );
  }

  void show(){
       print("$email - $password - $name - $department - $role");
  }
}


class UserController {
  final AppService _appService;

  UserController(this._appService);

  Future<Map<String, dynamic>> registerUser(HttpRequest request, HttpResponse response) async {
    try {
      final body = await request.bodyAsJsonMap;
      final userRequest = RegisterUserRequest.fromJson(body);
      userRequest.show();

      final userId = await _appService.registerUser(
        email: userRequest.email,
        password: userRequest.password,
        name: userRequest.name,
        department: userRequest.department,
        role: userRequest.role,
      );

      // Devolver una respuesta exitosa
      return {
        'success': true,
        'userId': userId,
        'message': 'Usuario registrado exitosamente',
      };
    } catch (e) {
      throw AlfredException(400, {'error': e.toString()});
    }
  }

  Future<Map<String, dynamic>> loginUser(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;

    if (body['email'] == null || body['password'] == null) {
      throw AlfredException(400, {'error': 'Email y contraseña son requeridos'});
    }

    final user = await _appService.authenticateUser(
      body['email'] as String,
      body['password'] as String,
    );

    if (user == null) {
      throw AlfredException(401, {'error': 'Credenciales inválidas'});
    }

    return {
      'success': true,
      'user': user,//.toJson(),
      'token': 'generar-token-jwt', // Implementar JWT aquí
    };
  }

  Future<Map<String, dynamic>> getUserProfile(HttpRequest request, HttpResponse response) async {
    final userId = int.parse(request.params['id']!);
    final user = await _appService.getUserById(userId);

    if (user == null) {
      throw AlfredException(404, {'error': 'Usuario no encontrado'});
    }

    return user.toJson();
  }

  Future<Map<String, dynamic>> updateUserProfile(HttpRequest request, HttpResponse response) async {
    final userId = int.parse(request.params['id']!);
    final body = await request.bodyAsJsonMap;

    final success = await _appService.updateUserProfile(
      userId,
      name: body['name'] as String?,
      password: body['password'] as String?,
    );

    return {
      'success': success,
      'message': success
          ? 'Usuario actualizado correctamente'
          : 'Error al actualizar usuario'
    };
  }

  Future<Map<String, dynamic>> deleteUser(HttpRequest request, HttpResponse response) async {
    final userId = int.parse(request.params['id']!);
    final success = await _appService.deleteUserAccount(userId);

    return {
      'success': success,
      'message': success
          ? 'Usuario eliminado correctamente'
          : 'Error al eliminar usuario'
    };
  }

  Future<List<User>> listUsers(HttpRequest request, HttpResponse response) async {
    final role = request.uri.queryParameters['role'];
    final department = request.uri.queryParameters['department'];

    final users = await _appService.getUsersByFilter(
      role: role,
      department: department,
    );

    return users;//.map((user) => user.toJson()).toList();
  }
}
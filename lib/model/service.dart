import 'package:dart_dashboard_backend/model/repository.dart';

import 'model.dart';
class AppService {
  final DataRepository _repository;

  AppService(this._repository);

  // ========== Servicios de Usuario ==========
  Future<int> registerUser({
    required String email,
    required String password,
    required String name,
    required String department,
    String role = 'USER',
  }) async {
    if (_repository.getUserByEmail(email) != null) {
      throw Exception('El usuario con este email ya existe');
    }

    final user = User(
      email: email,
      password: password,
      name: name,
      department: department,
      role: role,
    );

    return _repository.createUser(user);
  }

  Future<bool> updateUserProfile(int userId, {String? name, String? password}) async {
    final user = _repository.getUserById(userId);
    if (user == null) return false;

    if (name != null) user.name = name;
    if (password != null) user.password = password;

    return _repository.updateUser(user);
  }

  Future<bool> deleteUserAccount(int userId) async {
    // Primero eliminamos los permisos asociados
    final permissions = _repository.getPermissionsByUser(userId);
    for (final perm in permissions) {
      _repository.deletePermission(perm.id);
    }

    return _repository.deleteUser(userId);
  }

  Future<User?> authenticateUser(String email, String password) async {
    final user = _repository.getUserByEmail(email);
    return user != null && user.password == password ? user : null;
  }

  Future<List<User>> getUsersByFilter({String? role, String? department}) async {
    if (role != null) return _repository.getUsersByRole(role);
    if (department != null) return _repository.getUsersByDepartment(department);
    return _repository.getAllUsers();
  }

  // ========== Servicios de Permisos ==========
  Future<bool> assignPermissionToUser({
    required int userId,
    required String section,
    bool canCreate = false,
    bool canEdit = false,
    bool canDelete = false,
    bool canPublish = false,
  }) async {
    final user = _repository.getUserById(userId);
    if (user == null) return false;

    final permission = Permission(
      section: section,
      canCreate: canCreate,
      canEdit: canEdit,
      canDelete: canDelete,
      canPublish: canPublish,
    );
    permission.user.target = user;

    return _repository.createPermission(permission) > 0;
  }

  Future<List<String>> getUserSections(int userId) async {
    return _repository.getSectionsByUser(userId);
  }

  // ========== Servicios de Publicaciones ==========
  // Organismos de Gobernación
  Future<int> createOrganismo({
    required int autorId,
    required String nombre,
    required int valor1,
    required int valor2,
    required int valor3,
  }) async {
    final autor = _repository.getUserById(autorId);
    if (autor == null) throw Exception('Usuario no encontrado');

    final org = OrganismoGobernacion(
      nombre: nombre,
      valor1: valor1,
      valor2: valor2,
      valor3: valor3,
    );
    org.autor.target = autor;

    return _repository.createOrganismo(org);
  }

  // Alcaldías (similar para las demás entidades)
  Future<int> createAlcaldia({
    required int autorId,
    required String nombre,
    required int valor1,
    required int valor2,
    required int valor3,
  }) async {
    final autor = _repository.getUserById(autorId);
    if (autor == null) throw Exception('Usuario no encontrado');

    final alcaldia = Alcaldia(
      nombre: nombre,
      valor1: valor1,
      valor2: valor2,
      valor3: valor3,
    );
    alcaldia.autor.target = autor;

    return _repository.createAlcaldia(alcaldia);
  }

  // Programación Financiera
  Future<int> createProgramacionFinanciera({
    required int autorId,
    required String titulo,
    String? descripcion,
    required List<Map<String, dynamic>> meses,
  }) async {
    final autor = _repository.getUserById(autorId);
    if (autor == null) throw Exception('Usuario no encontrado');

    final programacion = ProgramacionFinanciera(
      titulo: titulo,
      descripcion: descripcion,
    );
    programacion.autor.target = autor;

    final programacionId = _repository.createProgramacion(programacion);

    for (final mesData in meses) {
      final mes = Mes(
        nombre: mesData['nombre'],
        valor: mesData['valor'],
        tipo: mesData['tipo'],
      );
      mes.programacionFinanciera.target = programacion;
      programacion.meses.add(mes);
    }

    _repository.updateProgramacion(programacion);
    return programacionId;
  }

  Future<User?> getUserById(int userId) async{
    return _repository.getUserById(userId);
  }
  Future<List<Permission>> getPermissionsByUser(int userId) async {
    final user = _repository.getUserById(userId);
    if (user == null) throw Exception('Usuario no encontrado');
    return _repository.getPermissionsByUser(userId);
  }

// Métodos similares para ResumenGestion y Noticia...
}
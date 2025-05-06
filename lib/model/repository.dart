import 'package:objectbox/objectbox.dart';
import '../objectbox.g.dart';
import 'model.dart';


class DataRepository {
  final Store store;
  late final Box<User> _userBox;
  late final Box<Permission> _permissionBox;
  late final Box<OrganismoGobernacion> _organismoBox;
  late final Box<Alcaldia> _alcaldiaBox;
  late final Box<ProgramacionFinanciera> _programacionBox;
  late final Box<ResumenGestion> _resumenBox;
  late final Box<Noticia> _noticiaBox;

  DataRepository(this.store) {
    _userBox = store.box<User>();
    _permissionBox = store.box<Permission>();
    _organismoBox = store.box<OrganismoGobernacion>();
    _alcaldiaBox = store.box<Alcaldia>();
    _programacionBox = store.box<ProgramacionFinanciera>();
    _resumenBox = store.box<ResumenGestion>();
    _noticiaBox = store.box<Noticia>();
  }

  // Métodos para usuarios

  bool deletePermission(int permissionId) => _permissionBox.remove(permissionId);

  List<User> getAllUsers() => _userBox.getAll();


  int createUser(User user) => _userBox.put(user);

  bool updateUser(User user) => _userBox.put(user) > 0;

  bool deleteUser(int userId) => _userBox.remove(userId);

  User? getUserById(int id) => _userBox.get(id);

  User? getUserByEmail(String email) {
    final query = _userBox.query(User_.email.equals(email)).build();
    final user = query.findFirst();
    query.close();
    return user;
  }

  List<User> getUsersByRole(String role) {
    final query = _userBox.query(User_.role.equals(role)).build();
    final users = query.find();
    query.close();
    return users;
  }

  List<User> getUsersByDepartment(String department) {
    final query = _userBox.query(User_.department.equals(department)).build();
    final users = query.find();
    query.close();
    return users;
  }

  // Métodos para permisos
  int createPermission(Permission permission) => _permissionBox.put(permission);

  List<Permission> getPermissionsByUser(int userId) {
    final query = _permissionBox.query(Permission_.user.equals(userId)).build();
    final permissions = query.find();
    query.close();
    return permissions;
  }

  List<String> getSectionsByUser(int userId) {
    final permissions = getPermissionsByUser(userId);
    return permissions.map((p) => p.section).toSet().toList();
  }

  // Métodos para publicaciones
  // Organismos de Gobernación
  int createOrganismo(OrganismoGobernacion org) => _organismoBox.put(org);
  List<OrganismoGobernacion> getAllOrganismos() => _organismoBox.getAll();
  bool updateOrganismo(OrganismoGobernacion org) => _organismoBox.put(org) > 0;
  bool deleteOrganismo(int id) => _organismoBox.remove(id);

  // Alcaldías (similar estructura para las demás entidades)
  int createAlcaldia(Alcaldia alcaldia) => _alcaldiaBox.put(alcaldia);
  List<Alcaldia> getAllAlcaldias() => _alcaldiaBox.getAll();
  bool updateAlcaldia(Alcaldia alcaldia) => _alcaldiaBox.put(alcaldia) > 0;
  bool deleteAlcaldia(int id) => _alcaldiaBox.remove(id);

  // Programación Financiera
  int createProgramacion(ProgramacionFinanciera prog) => _programacionBox.put(prog);
  List<ProgramacionFinanciera> getAllProgramaciones() => _programacionBox.getAll();
  bool updateProgramacion(ProgramacionFinanciera prog) => _programacionBox.put(prog) > 0;
  bool deleteProgramacion(int id) => _programacionBox.remove(id);

  // Resumen de Gestión
  int createResumen(ResumenGestion resumen) => _resumenBox.put(resumen);
  List<ResumenGestion> getAllResumenes() => _resumenBox.getAll();
  bool updateResumen(ResumenGestion resumen) => _resumenBox.put(resumen) > 0;
  bool deleteResumen(int id) => _resumenBox.remove(id);

  // Noticias
  int createNoticia(Noticia noticia) => _noticiaBox.put(noticia);
  List<Noticia> getAllNoticias() => _noticiaBox.getAll();
  bool updateNoticia(Noticia noticia) => _noticiaBox.put(noticia) > 0;
  bool deleteNoticia(int id) => _noticiaBox.remove(id);
}
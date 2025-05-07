import 'package:dart_dashboard_backend/model/app_strings.dart';
import 'package:objectbox/objectbox.dart';


import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  String email;
  String password;
  String name;
  String role; // SUPER_ADMIN, DEPARTMENT_ADMIN, EDITOR, VIEWER, GUEST
  String department; // DGAdministracion, DGEgreso, etc.

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  @Backlink('user')
  final permissions = ToMany<Permission>();

  @Backlink('autor')
  final organismosGobernacion = ToMany<OrganismoGobernacion>();

  @Backlink('autor')
  final alcaldias = ToMany<Alcaldia>();

  @Backlink('autor')
  final programacionesFinancieras = ToMany<ProgramacionFinanciera>();

  @Backlink('autor')
  final resumenesGestion = ToMany<ResumenGestion>();

  @Backlink('autor')
  final noticias = ToMany<Noticia>();

  User({
    required this.email,
    required this.password,
    required this.name,
    this.role = AppStrings.user,
    required this.department,
  });

  // Método toJson() para serializar el objeto User
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password, // Considera no incluir la contraseña por seguridad
      'name': name,
      'role': role,
      'department': department,
      'createdAt': createdAt.toIso8601String(), // Serializa la fecha como String
      'updatedAt': updatedAt.toIso8601String(), // Serializa la fecha como String
     /* 'permissions': permissions.map((permission) => permission.toJson()).toList(), // Serializa las relaciones
      'organismosGobernacion': organismosGobernacion.map((organismo) => organismo.toJson()).toList(),
      'alcaldias': alcaldias.map((alcaldia) => alcaldia.toJson()).toList(),
      'programacionesFinancieras': programacionesFinancieras.map((programacion) => programacion.toJson()).toList(),
      'resumenesGestion': resumenesGestion.map((resumen) => resumen.toJson()).toList(),
      'noticias': noticias.map((noticia) => noticia.toJson()).toList(),*/
    };
  }
}

@Entity()
class Permission {
  @Id()
  int id = 0;

  final user = ToOne<User>();

  String section; // ORGANISMOS_GOBERNACION, ALCALDIAS, etc.

  bool canCreate = false;
  bool canEdit = false;
  bool canDelete = false;
  bool canPublish = false;

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Permission({
    required this.section,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canPublish = false,
  });
}

@Entity()
class OrganismoGobernacion {
  @Id()
  int id = 0;

  String nombre;
  int valor1;
  int valor2;
  int valor3;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  OrganismoGobernacion({
    required this.nombre,
    required this.valor1,
    required this.valor2,
    required this.valor3,
  });
}

@Entity()
class Alcaldia {
  @Id()
  int id = 0;

  String nombre;
  int valor1;
  int valor2;
  int valor3;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Alcaldia({
    required this.nombre,
    required this.valor1,
    required this.valor2,
    required this.valor3,
  });
}

@Entity()
class ProgramacionFinanciera {
  @Id()
  int id = 0;

  String titulo;
  String? descripcion;

  final autor = ToOne<User>();
  final meses = ToMany<Mes>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  ProgramacionFinanciera({
    required this.titulo,
    this.descripcion,
  });
}

@Entity()
class Mes {
  @Id()
  int id = 0;

  String nombre;
  double valor;
  String tipo; // PRESUPUESTO_INICIAL, PRESUPUESTO_FINAL, GASTO_REAL

  final programacionFinanciera = ToOne<ProgramacionFinanciera>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Mes({
    required this.nombre,
    required this.valor,
    required this.tipo,
  });
}

@Entity()
class ResumenGestion {
  @Id()
  int id = 0;

  String titulo;
  String descripcion;
  String imagenUrl;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  ResumenGestion({
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
  });
}

@Entity()
class Noticia {
  @Id()
  int id = 0;

  String titulo;
  String contenido;
  String? imagenUrl;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Noticia({
    required this.titulo,
    required this.contenido,
    this.imagenUrl,
  });
}
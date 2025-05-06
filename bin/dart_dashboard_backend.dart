import 'package:dart_dashboard_backend/model/app_strings.dart';
import 'package:dart_dashboard_backend/model/repository.dart';
import 'package:dart_dashboard_backend/model/service.dart';
import 'package:dart_dashboard_backend/objectbox.g.dart';
import 'package:dart_dashboard_backend/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

// Esta función sería generada por build_runner


void main(List<String> arguments) async {
  // Inicializar la base de datos
  final store = Store(
    getObjectBoxModel(),
    directory: 'objectbox-db', // Directorio para almacenar la base de datos
  );

  try {
    // Crear instancias del repositorio y servicio

    final userRepo = DataRepository(store);
    final appService = AppService(userRepo);

    //final userRepo = UserRepository(store);
    //final userService = UserService(userRepo);


    final userId = await appService.registerUser(
      email: 'admin@example.com',
      password: 'secure123',
      name: 'Admin Principal',
      department: 'DGAdministracion',
      role: 'SUPER_ADMIN',
    );
    print('Usuario creado con ID: $userId');

    // Asignar permisos
    await appService.assignPermissionToUser(
      userId: userId,
      section: 'CONFIGURACION',
      canCreate: true,
      canEdit: true,
      canDelete: true,
      canPublish: true,
    );
    await appService.assignPermissionToUser(
      userId: userId,
      section: 'CONFIGURACION2',
      canCreate: true,
      canEdit: true,
      canDelete: true,
      canPublish: true,
    );
    await appService.assignPermissionToUser(
      userId: userId,
      section: 'CONFIGURACION3',
      canCreate: true,
      canEdit: true,
      canDelete: true,
      canPublish: true,
    );
    await appService.assignPermissionToUser(
      userId: userId,
      section: 'CONFIGURACION4',
      canCreate: true,
      canEdit: true,
      canDelete: true,
      canPublish: true,
    );

    // Crear una publicación
    final orgId = await appService.createOrganismo(
      autorId: userId,
      nombre: 'Ministerio de Hacienda',
      valor1: 1000,
      valor2: 2000,
      valor3: 3000,
    );
    print('Organismo creado con ID: $orgId');

    // Consultar usuarios
    final admins = await appService.getUsersByFilter(role: 'SUPER_ADMIN');
    print('\nAdministradores:');
    for (final admin in admins){
      final permisos = await appService.getPermissionsByUser(admin.id);
      for(final p in permisos){
          print('${p.section}(${p.canCreate ? "C" : ""}${p.canEdit ? "E" : ""}${p.canDelete ? "D" : ""}${p.canPublish ? "P" : ""})');
      }
    }
    /*admins.forEach((u) async {
      final permisos = await appService.getPermissionsByUser(u.id);
       permisos.forEach((p) async {
         print('${p.section}(${p.canCreate ? "C" : ""}${p.canEdit ? "E" : ""}${p.canDelete ? "D" : ""}${p.canPublish ? "P" : ""})');
      });
    });*/

  } catch (e) {
    print('Error durante las pruebas: $e');
  } finally {
    // Cerrar la base de datos al finalizar
    store.close();
    print('\n=== PRUEBAS COMPLETADAS ===');
  }
}

// export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/lib/objectbox
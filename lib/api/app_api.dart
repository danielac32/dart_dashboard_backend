

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend/api/routes/user_routes.dart';

import '../model/service.dart';
import 'controllers/user_controller.dart';


class AppApi {
  final Alfred app = Alfred();
  final AppService appService;

  AppApi({required this.appService});

  Future<void> start({int port = 3000}) async {

    // Inicializar controladores
    final userController = UserController(appService);



    // Configurar rutas
    configureUserRoutes(app, userController);
    //app.all('*', cors(origin: 'myorigin.com'));
    // Middleware global para manejo de errores

    app.all('*', (req, res) {

      if (res.statusCode == 404) {
        print('Ruta no encontrada');
        throw AlfredException(404, {'error': 'Ruta no encontrada'});
      }
    });


    // Iniciar servidor
    await app.listen(port);
    print('Servidor escuchando en http://localhost:$port');
  }
}
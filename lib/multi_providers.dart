import 'package:ees/controllers/home_controller.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/orders_controller.dart';
import 'controllers/static_controller.dart';

class MultiProviders {
  static List<ChangeNotifierProvider> providers() {
    return [
      ChangeNotifierProvider<AuthController>(
        create: (context) => AuthController(),
      ),
      ChangeNotifierProvider<CartProvider>(
        create: (context) => CartProvider(),
      ),
      ChangeNotifierProvider<HomeProvider>(
        create: (context) => HomeProvider(),
      ),
      ChangeNotifierProvider<OrdersController>(
          create: (context) => OrdersController()),
      ChangeNotifierProvider<StaticProvider>(
        create: (context) => StaticProvider(),
      )
    ];
  }
}

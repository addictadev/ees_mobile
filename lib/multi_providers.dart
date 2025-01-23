import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';

class MultiProviders {
  static List<ChangeNotifierProvider> providers() {
    return [
      ChangeNotifierProvider<AuthController>(
        create: (context) => AuthController(),
      ),
      // ChangeNotifierProvider<UserAddressesController>(
      //   create: (context) => UserAddressesController(),
      // ),
      // ChangeNotifierProvider<HomeMarketController>(
      //   create: (context) => HomeMarketController()
      //     ..getHomeData()
      //     ..getAllCategories()
      //     ..getallProduct()
      //     ..getFavouriteShops()
      //     ..getPopularMarkets(),
      // ),
      // ChangeNotifierProvider<CartController>(
      //   create: (context) => CartController(),
      // ),
      // ChangeNotifierProvider<NotificationController>(
      //   create: (context) => NotificationController(),
      // ),
      // ChangeNotifierProvider<OrderController>(
      //   create: (context) => OrderController(),
      // ),
      //   ChangeNotifierProvider<BlogsController>(
      //   create: (context) => BlogsController(),
      // ),
      //OrderController
    ];
  }
}

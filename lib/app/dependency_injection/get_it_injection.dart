import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/local/shared_pref_serv.dart';
import '../navigation_services/navigation_manager.dart';

final getIt = GetIt.instance;

Future<void> initDependencyInjection() async {
  getIt.registerSingleton<NavigationManager>(NavigationManager());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService(getIt()));
}

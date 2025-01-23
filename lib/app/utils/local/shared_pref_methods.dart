import '../../dependency_injection/get_it_injection.dart';
import 'shared_pref_serv.dart';

class SharedPrefMethods {
  static final shedPref = getIt<SharedPreferencesService>();

  static bool isUser() {
    return shedPref.getString('userType') == 'customer';
  }
}

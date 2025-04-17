import 'dart:async';
import 'dart:io';
import 'package:ees/app.dart';
import 'package:ees/app/dependency_injection/get_it_injection.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ConnectivityService {
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  static final ConnectivityService _instance = ConnectivityService._internal();

  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;
  Timer? _connectivityTimer;
  bool _lastConnectionStatus = false;

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void initialize() {
    _checkConnectivity();

    _connectivityTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await hasInternetConnection();

    if (isConnected != _lastConnectionStatus) {
      _lastConnectionStatus = isConnected;
      _connectivityController.add(isConnected);
    }
  }

  Future<void> checkNow() async {
    _checkConnectivity();
  }

  void dispose() {
    _connectivityTimer?.cancel();
    _connectivityController.close();
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                "لا يوجد اتصال بالانترنت",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "من فضلك تأكد من اتصالك بالانترنت",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "اعادة المحاولة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    initDependencyInjection(),
    translator.init(
      localeType: LocalizationDefaultType.device,
      languagesList: <String>['ar', 'en'],
      assetsDirectory: 'assets/translation/',
    ),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  final connectivityService = ConnectivityService();
  connectivityService.initialize();
  bool hasInternet = await connectivityService.hasInternetConnection();

  runApp(
    Phoenix(
      child: AppLoader(
        connectivityService: connectivityService,
        hasInitialInternet: hasInternet,
      ),
    ),
  );

  configLoading();
}

class AppLoader extends StatefulWidget {
  final ConnectivityService connectivityService;
  final bool hasInitialInternet;

  const AppLoader({
    super.key,
    required this.connectivityService,
    required this.hasInitialInternet,
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late bool hasInternet;

  @override
  void initState() {
    super.initState();
    hasInternet = widget.hasInitialInternet;

    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.connectivityService.connectivityStream,
      initialData: hasInternet,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          if (!hasInternet) {
            hasInternet = true;
          }
          return MyApp();
        } else {
          return NoInternetWidget(
            onRetry: () async {
              await widget.connectivityService.checkNow();
            },
          );
        }
      },
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.primary
    ..backgroundColor = AppColors.white
    ..indicatorColor = AppColors.primary
    ..userInteractions = true
    ..dismissOnTap = false;
}

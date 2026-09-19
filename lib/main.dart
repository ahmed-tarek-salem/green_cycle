import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/app_update/app_update_controller.dart';
import 'package:green_cycle/modules/app_update/app_update_listener.dart';
import 'package:green_cycle/theme/app_themes.dart';
import 'package:green_cycle/utilities/global/app_environment.dart';
import 'package:green_cycle/utilities/navigation/app_pages.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:green_cycle/utilities/storage/local_storage.dart';

var localStorage = Get.put(LocalStorage());

void main() {
  /// Global environment switch — flip to [AppEnvironment.dev] to point the
  /// whole app at the staging APIs, or [AppEnvironment.prod] for production.
  appEnvironment = AppEnvironment.prod;
  initApp();
}

/// init app for both flavors
Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioClient.initialize('ar');
  await localStorage.init();
  // Starts the version check in the background, the launch flow never waits
  // for it. `AppUpdateListener` reacts whenever the answer arrives.
  Get.put(AppUpdateController(), permanent: true);
  // Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// run app
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 728),
        builder: (context, child) {
          return GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            builder: ((context, child) {
              child = FlutterSmartDialog.init()(context, child);
              child = MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(1.0)),
                child: child,
              );
              return AppUpdateListener(child: child);
            }),

            supportedLocales: const [Locale('ar')],
            debugShowCheckedModeBanner: false,
            title: 'Go Green',
            theme: AppThemes().lightThemeData('ar'),
            darkTheme: AppThemes().lightThemeData('ar'),
            initialRoute: AppRoutes.splash,
            getPages: AppPages.routes,
            locale: const Locale('ar'),
            // initialBinding: InitialBindings(),
            defaultTransition: Transition.fadeIn,
          );
        });
  }
}

import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_bindings.dart';
import 'package:green_cycle/modules/home_layout/home_layout_screen.dart';
import 'package:green_cycle/modules/login/login_bindings.dart';
import 'package:green_cycle/modules/login/login_screen.dart';
import 'package:green_cycle/modules/sign_up/sign_up_bindigns.dart';
import 'package:green_cycle/modules/sign_up/sign_up_screen.dart';
import 'package:green_cycle/modules/splash/splash_screen.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => const SignupScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: AppRoutes.homeLayoutScreen,
      page: () => const HomeLayoutScreen(),
      binding: HomeLayoutBindings(),
    )
  ];
}

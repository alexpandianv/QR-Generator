import 'package:get/get.dart';
import 'package:qr_generator/view/qr_show_screen.dart';
import '../view/login_screen.dart';
import '../view/splash_screen.dart';
class AppPages {
  static final routes = [
    GetPage(name: Routes.SplashScreen, page: () => SplashScreen()),
    GetPage(name: Routes.LOGIN, page: () => LoginOtpScreen()),
    GetPage(name: Routes.QRSHOWBOARD, page: () => QRShowScreen()),
  ];
}


abstract class Routes {

  static const SplashScreen = '/SplashScreen';

  static const LOGIN = '/login';
  static const QRSHOWBOARD = '/QRShow';
}

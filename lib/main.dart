import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

import 'incubatee_portal/incubatee_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static LegacyAppBridge of(BuildContext context) => LegacyAppBridge();

  @override
  Widget build(BuildContext context) {
    return const IncubateeApp();
  }
}

class LegacyAppBridge {
  void setThemeMode(ThemeMode mode) {}

  String getRoute() => '/';

  List<String> getRouteStack() => const ['/'];
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:meal_planner/imports.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,

      initialRoute: '/login',

      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => PageProvider()),
          ],
          child: child!,
        );
      },

      routes: {
        '/': (context) => const BasePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

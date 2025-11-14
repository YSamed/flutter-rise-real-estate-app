import 'package:flutter/material.dart';
import 'package:partice_project/theme/theme.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:partice_project/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:partice_project/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mülktaş",
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: RoutesName.homeScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

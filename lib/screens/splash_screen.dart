import 'package:flutter/material.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/services/storage_service.dart';
import 'package:partice_project/utils/route_name.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 2 saniye bekle (splash göster)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Auth kontrolü
    final isLoggedIn = await StorageService.isLoggedIn();

    if (isLoggedIn) {
      // Kullanıcı giriş yapmış - ana ekrana yönlendir
      Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
    } else {
      // Kullanıcı giriş yapmamış - login ekranına yönlendir
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          center: Alignment(10, 10),
          // near the top right
          colors: <Color>[
            Color(0xff21628A),
            Color(0xff234F68),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.clamp,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage("lib/assets/logo.png"),
              ),
            ),
            Text(
              "Rise",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: AppColors.whiteColor),
            ),
            Text(
              "Real Estate",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}

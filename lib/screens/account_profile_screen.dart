import 'package:flutter/material.dart';
import 'package:partice_project/components/app_button.dart';
import 'package:partice_project/components/gap.dart';
import 'package:partice_project/components/header_title.dart';
import 'package:partice_project/components/shared/screen.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/providers/auth_provider.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:provider/provider.dart';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkAuthStatus();
    });
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.loginScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.status == AuthStatus.authenticated;
    final user = authProvider.user;

    return Screen(
      isBackButton: false,
      isBottomTab: true,
      child: Column(
        children: [
          const HeaderTitle(
            title: "Profil",
            bottomTitle: "Hesap bilgilerinizi görüntüleyin ve düzenleyin.",
            subtitle: "",
          ),
          Gap(
            isWidth: false,
            isHeight: true,
            height: height * 0.03,
          ),
          if (isLoggedIn) ...[
            if (user != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.firstName != null || user.lastName != null) ...[
                      Text(
                        "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Gap(isWidth: false, isHeight: true, height: height * 0.01),
                    ],
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Kullanıcı bilgileri yükleniyor...",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
            Gap(
              isWidth: false,
              isHeight: true,
              height: height * 0.03,
            ),
            AppButton(
              onPress: _handleLogout,
              title: "Çıkış Yap",
              textColor: AppColors.whiteColor,
              bgColor: Colors.red,
              height: 50,
            ),
          ],
        ],
      ),
    );
  }
}

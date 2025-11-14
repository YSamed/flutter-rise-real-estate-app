import 'package:flutter/material.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/providers/auth_provider.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:provider/provider.dart';

class LocationBottomSheet extends StatelessWidget {
  final VoidCallback? onProfileTap;
  
  const LocationBottomSheet({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.status == AuthStatus.authenticated;
    
    return InkWell(
      onTap: isLoggedIn
          ? () {
              if (onProfileTap != null) {
                onProfileTap!();
              } else {
                Navigator.pushNamed(context, RoutesName.profileScreen);
              }
            }
          : () {
              Navigator.pushNamed(context, RoutesName.loginScreen);
            },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primaryColor)),
        child: Center(
          child: isLoggedIn
              ? const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2022/10/20/11/26/landscape-7534634_640.jpg"),
                )
              : const Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                ),
        ),
      ),
    );
  }
}

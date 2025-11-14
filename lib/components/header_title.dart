import 'package:flutter/material.dart';
import 'package:partice_project/components/app_button.dart';
import 'package:partice_project/components/gap.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/providers/auth_provider.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:provider/provider.dart';

class HeaderTitle extends StatelessWidget {
  final String title, title1, subtitle, middle, bottomTitle, bottomTitle2;
  final bool isMiddle, isBottomTitle, isUnderTitle;
  const HeaderTitle({
    Key? key,
    required this.title,
    this.title1 = "",
    this.subtitle = "",
    required this.bottomTitle,
    this.middle = " & ",
    this.bottomTitle2 = "",
    this.isMiddle = false,
    this.isUnderTitle = false,
    this.isBottomTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.status == AuthStatus.authenticated;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: isMiddle
              ? [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Text(
                    middle,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 25),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ]
              : [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: AppColors.textPrimary, fontSize: 25),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ],
        ),
        isUnderTitle
            ? Text(
                title1,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )
            : Text(""),
        Gap(
            isWidth: false,
            isHeight: true,
            height: isUnderTitle ? height * 0.02 : 0),
        Text(
          bottomTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.faqColor, fontSize: 12),
        ),
        isBottomTitle
            ? Text(
                bottomTitle2,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )
            : Text(""),
        if (!isLoggedIn) ...[
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          AppButton(
            onPress: () {
              Navigator.pushNamed(context, RoutesName.loginScreen);
            },
            title: "Giriş Yap",
            textColor: AppColors.whiteColor,
            height: 50,
          ),
        ],
      ],
    );
  }
}

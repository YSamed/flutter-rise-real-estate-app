import 'package:flutter/material.dart';
import 'package:partice_project/components/bottomSheet/edit_location.dart';
import 'package:partice_project/components/gap.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/screens/promotion/promotion_screen.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;
  
  const HomeHeader({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          width: 80,
          fit: BoxFit.cover,
          image: AssetImage("lib/assets/logo.png"),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: RoutesName.promotionScreem),
                  screen: PromotionScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.primaryColor)),
                child: const Center(
                  child: Icon(Icons.notifications),
                ),
              ),
            ),
            Gap(isWidth: true, isHeight: false, width: width * 0.03),
            LocationBottomSheet(onProfileTap: onProfileTap),
          ],
        ),
      ],
    );
  }
}

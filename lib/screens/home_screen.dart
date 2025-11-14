import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partice_project/components/gap.dart';
import 'package:partice_project/components/home/category_card.dart';
import 'package:partice_project/components/home/featured_card.dart';
import 'package:partice_project/components/home/home_category.dart';
import 'package:partice_project/components/home/home_header.dart';
import 'package:partice_project/components/home/property_card.dart';
import 'package:partice_project/components/home/row_title_home.dart';
import 'package:partice_project/components/home/top_location.dart';
import 'package:partice_project/components/shared/screen.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/providers/auth_provider.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const HomeScreen({super.key, this.onProfileTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchInput = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkAuthStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchInput.dispose();
    searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Screen(
      isBackButton: false,
      isBottomTab: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(onProfileTap: widget.onProfileTap),
          Gap(isWidth: false, isHeight: true, height: height * 0.01),
          authProvider.status == AuthStatus.authenticated
              ? Row(
                  children: [
                    Text(
                      "Merhaba",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap(isWidth: true, isHeight: false, width: width * 0.01),
                    Text(
                      "${authProvider.user?.username ?? ''}",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                  ],
                )
              : Text(
                  "Merhaba",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
          Gap(isWidth: false, isHeight: true, height: height * 0.03),
          Container(
            height: height / 12,
            width: double.infinity,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Gap(isWidth: true, isHeight: false, width: width * 0.03),
              const HomeCategory(title: "Ev", active: false),
              Gap(isWidth: true, isHeight: false, width: width * 0.03),
              const HomeCategory(title: "Arsa", active: false),
              Gap(isWidth: true, isHeight: false, width: width * 0.03),
              const HomeCategory(title: "Satılık", active: false),
              Gap(isWidth: true, isHeight: false, width: width * 0.03),
              const HomeCategory(title: "Kiralık", active: false),
            ]),
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.03),
          Container(
            height: height / 4,
            width: double.infinity,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              const PropertyCard(
                  title: "Aradığınız Ev\nve Arsalar Burada",
                  subtitle: "Geniş portföyümüzde hayalinizdeki mülkü bulun",
                  path: "lib/assets/images/property.jpg"),
              Gap(isWidth: true, isHeight: false, width: width * 0.05),
              const PropertyCard(
                  title: "İster Kiral\nİster Sat",
                  subtitle: "Kiralama ve satış için geniş seçenekler",
                  path: "lib/assets/images/property1.jpg"),
              Gap(isWidth: true, isHeight: false, width: width * 0.05),
              const PropertyCard(
                  title: "Emlak İçin\nHer Şey Burada",
                  subtitle: "Tüm emlak ihtiyaçlarınız için tek adres",
                  path: "lib/assets/images/property2.jpg"),
              Gap(isWidth: true, isHeight: false, width: width * 0.05),
            ]),
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          RowTitleHome(
            title: "En Popüler Şehirler",
            subtitle: "Tümü",
            onPress: () {},
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          Container(
            height: height / 15,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const TopLocation(
                  path: "lib/assets/images/property.jpg",
                  location: "İstanbul",
                ),
                Gap(isWidth: true, isHeight: false, width: width * 0.03),
                const TopLocation(
                  path: "lib/assets/images/property1.jpg",
                  location: "Ankara",
                ),
                Gap(isWidth: true, isHeight: false, width: width * 0.03),
                const TopLocation(
                  path: "lib/assets/images/property2.jpg",
                  location: "İzmir",
                ),
                Gap(isWidth: true, isHeight: false, width: width * 0.03),
                const TopLocation(
                  path: "lib/assets/images/property.jpg",
                  location: "Bursa",
                ),
                Gap(isWidth: true, isHeight: false, width: width * 0.03),
                const TopLocation(
                  path: "lib/assets/images/property3.jpg",
                  location: "Adana",
                ),
                Gap(isWidth: true, isHeight: false, width: width * 0.03),
                const TopLocation(
                  path: "lib/assets/images/property2.jpg",
                  location: "Yogartha",
                ),
              ],
            ),
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.03),
          RowTitleHome(
            title: "Kategoriler",
            subtitle: "",
            onPress: () {},
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          Row(
            children: [
              CategoryCard(
                title: "Ev",
                icon: Icons.home,
                path:
                    "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?auto=compress&cs=tinysrgb&w=800",
                onTap: () {},
              ),
              Gap(isWidth: true, isHeight: false, width: width * 0.03),
              CategoryCard(
                title: "Arsa",
                icon: Icons.landscape,
                path:
                    "https://images.pexels.com/photos/210617/pexels-photo-210617.jpeg?auto=compress&cs=tinysrgb&w=800",
                onTap: () {},
              ),
            ],
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          Row(
            children: [
              CategoryCard(
                title: "Daire",
                icon: Icons.business,
                path:
                    "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?auto=compress&cs=tinysrgb&w=800",
                onTap: () {},
              ),
              Gap(isWidth: true, isHeight: false, width: width * 0.03),
              CategoryCard(
                title: "Mağaza",
                icon: Icons.store,
                path:
                    "https://images.pexels.com/photos/210617/pexels-photo-210617.jpeg?auto=compress&cs=tinysrgb&w=800",
                onTap: () {},
              ),
            ],
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.03),
          RowTitleHome(
            title: "İlanlar",
            subtitle: "Tüm İlanlar",
            onPress: () {
              Navigator.pushNamed(context, RoutesName.featuredScreen);
            },
          ),
          Gap(isWidth: false, isHeight: true, height: height * 0.02),
          Container(
            height: height / 4,
            width: double.infinity,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              const FeaturedCard(
                  path: "lib/assets/images/property2.jpg",
                  category: "Daire",
                  title: "Modern Yaşam\nApartmanı",
                  rating: "4.9",
                  location: "İstanbul, Türkiye",
                  payment: "10"),
              Gap(isWidth: true, isHeight: false, width: width * 0.05),
              const FeaturedCard(
                  path: "lib/assets/images/property1.jpg",
                  category: "Villa",
                  title: "Lüks Villa\nRezidans",
                  rating: "4.8",
                  location: "Ankara, Türkiye",
                  payment: "10"),
              Gap(isWidth: true, isHeight: false, width: width * 0.05),
              const FeaturedCard(
                  path: "lib/assets/images/property.jpg",
                  category: "Ev",
                  title: "Şehir Merkezi\nMüstakil Ev",
                  rating: "4.7",
                  location: "İzmir, Türkiye",
                  payment: "10"),
              Gap(isWidth: true, isHeight: false, width: width * 0.05),
            ]),
          ),
        ],
      ),
    );
  }
}

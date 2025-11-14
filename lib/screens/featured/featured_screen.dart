import 'package:flutter/material.dart';
import 'package:partice_project/components/app_input.dart';
import 'package:partice_project/components/gap.dart';
import 'package:partice_project/components/home/explore_card.dart';
import 'package:partice_project/components/home/featured_card.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/models/property_model.dart';
import 'package:partice_project/models/auth_models.dart';
import 'package:partice_project/services/property_service.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  final searchInput = TextEditingController();
  final searchFocus = FocusNode();
  List<Property> properties = [];
  bool isLoading = true;
  bool isGridView = false;
  String? errorMessage;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties({String? search}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await PropertyService.getProperties(search: search);
      setState(() {
        properties = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e is ApiError ? e.message : 'Bir hata oluştu';
        isLoading = false;
      });
    }
  }

  void _onSearch(String value) {
    setState(() {
      searchQuery = value;
    });
    _loadProperties(search: value.isEmpty ? null : value);
  }

  @override
  void dispose() {
    super.dispose();
    searchInput.dispose();
    searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "İlanlar",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: AppColors.textPrimary),
              ),
              Gap(
                isWidth: false,
                isHeight: true,
                height: height * 0.005,
              ),
              Gap(
                isWidth: false,
                isHeight: true,
                height: height * 0.02,
              ),
              AppInput(
                  myController: searchInput,
                  focusNode: searchFocus,
                  onFiledSubmitedValue: (value) => _onSearch(value ?? ''),
                  onChanged: _onSearch,
                  keyBoardType: TextInputType.text,
                  leftIcon: true,
                  icon: Icon(Icons.search),
                  isFilled: true,
                  isCompact: true,
                  obscureText: false,
                  hinit: "Konum, kategori veya ilan ara...",
                  onValidator: (value) {
                    return null;
                  }),
              Gap(
                isWidth: false,
                isHeight: true,
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${properties.length} ',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: AppColors.textPrimary),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'ilan',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Container(
                    width: width / 3.5,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // TODO: Filter dialog
                          },
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            size: 25,
                            color: Color(0xffA1A5C1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isGridView = false;
                            });
                          },
                          child: Icon(
                            Icons.table_bar,
                            size: 25,
                            color: !isGridView
                                ? AppColors.primaryColor
                                : const Color(0xffA1A5C1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isGridView = true;
                            });
                          },
                          child: Icon(
                            Icons.view_agenda,
                            size: 25,
                            color: isGridView
                                ? AppColors.primaryColor
                                : const Color(0xffA1A5C1),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Gap(
                isWidth: false,
                isHeight: true,
                height: height * 0.03,
              ),
              Expanded(
                child: _buildPropertyList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Gap(isWidth: false, isHeight: true, height: 20),
            ElevatedButton(
              onPressed: () => _loadProperties(),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (properties.isEmpty) {
      return Center(
        child: Text(
          'İlan bulunamadı',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return ExploreCard(
            title: property.title,
            rating: property.rating?.toStringAsFixed(1) ?? '0.0',
            location: property.location,
            path: property.imageUrl ??
                property.images?.firstOrNull ??
                'lib/assets/images/property.jpg',
            isHeart: property.isFavorite ?? false,
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FeaturedCard(
            path: property.imageUrl ??
                property.images?.firstOrNull ??
                'lib/assets/images/property.jpg',
            category: property.category,
            title: property.title,
            rating: property.rating?.toStringAsFixed(1) ?? '0.0',
            location: property.location,
            payment: property.price?.toStringAsFixed(0) ?? '0',
          ),
        );
      },
    );
  }
}

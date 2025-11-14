import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:partice_project/constant/colors.dart';

class AccordionApp extends StatelessWidget {
  const AccordionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Accordion(
        maxOpenSections: 1,
        scaleWhenAnimating: true,
        openAndCloseAnimation: true,
        headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        children: [
          AccordionSection(
            isOpen: true,
            rightIcon: const Icon(Icons.add, color: AppColors.textPrimary),
            headerBackgroundColor: AppColors.whiteColor,
            headerBackgroundColorOpened: AppColors.primaryColor,
            contentBorderColor: AppColors.whiteColor,
            contentBackgroundColor: AppColors.inputBackground,
            header: Text(
              'Why choose buy in Rise?',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            content: Text(
                "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.textPrimary, fontSize: 14)),
            contentHorizontalPadding: 20,
          ),
          AccordionSection(
            isOpen: true,
            rightIcon: const Icon(Icons.add, color: AppColors.textPrimary),
            headerBackgroundColor: AppColors.whiteColor,
            headerBackgroundColorOpened: AppColors.primaryColor,
            contentBorderColor: AppColors.whiteColor,
            contentBackgroundColor: AppColors.inputBackground,
            header: Text(
              'Why choose buy in Rise?',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            content: Text(
                "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.textPrimary, fontSize: 14)),
            contentHorizontalPadding: 20,
          ),
        ],
      ),
    );
  }
}

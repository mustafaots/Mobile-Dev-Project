import 'package:easy_vacation/main.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String selectedLang = 'en';

  final Map<String, Widget> languages = {
  'en': Image.asset('assets/images/gb.png', height: 30,),
  'fr': Image.asset('assets/images/fr.png', height: 30,),
  'ar': Image.asset('assets/images/dz.png', height: 30,),
};

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryTextColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: languages.entries.map((entry) {
              final bool isSelected = selectedLang == entry.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLang = entry.key;
                    });
                    MainApp.setLocale(context, Locale(entry.key));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.4),
                              blurRadius: 10, // how blurry the glow is
                              spreadRadius: 1, // how much it spreads
                              offset: const Offset(0, 0), // center the glow
                            ),
                          ]
                        : [],
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: entry.value
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
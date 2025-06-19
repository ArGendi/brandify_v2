import 'package:brandify/main.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/view/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/language/language_cubit.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset(
                "assets/images/logo_primary.png",
                width: 80,
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.selectPreferredLanguage,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.languageSelectionDesc,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildLanguageOption(
                context,
                AppLocalizations.of(context)!.english,
                'en',
                Icons.language,  // Using language icon for English
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                context,
                AppLocalizations.of(context)!.arabic,
                'ar',
                Icons.translate,  // Using translate icon for Arabic
              ),
              const Spacer(),
              CustomButton(
                text: AppLocalizations.of(context)!.continueText,
                onPressed: () {
                  navigatorKey.currentState!.push(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String code,
    IconData icon,  // Changed from String flagAsset to IconData icon
  ) {
    final languageCubit = BlocProvider.of<LanguageCubit>(context);
    final isSelected = Cache.getLanguage() == code;

    return InkWell(
      onTap: () => languageCubit.changeLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? mainColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? mainColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(  // Replace Image.asset with Icon
              icon,
              size: 32,
              color: isSelected ? mainColor : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mainColor : Colors.grey[800],
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: mainColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
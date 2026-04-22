import 'dart:async';
import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/constant/app_branding.dart';
import 'package:flutter/material.dart';
import 'package:neoncave_arena/DB/local_handler.dart';
import 'package:neoncave_arena/routes/app_routes.dart'; 
import 'package:neoncave_arena/theme/colors.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();
  final SharedWebService sharedWebService = SharedWebService.instance();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      // Start small
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.2),
        weight: 35.0,
      ),
      // Hold at slightly larger size
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 15.0,
      ),
      // Hold at normal size
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 25.0,
      ),
      // Zoom out
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 25.0,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    colorChanger(context);
    _startAnimation();
  }

  void _startAnimation() {
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        getUser();
      }
    });
  }

  Future<void> getUser() async {
    final user = sharedPreferenceHelper.isUserLoggedIn;
    if (user == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MyRoutes.mainScreen,
        arguments: false,
        (_) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MyRoutes.onBoardingPage,
        (_) => false,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void colorChanger(BuildContext context) async {
    final appColor = Provider.of<AppColor>(context, listen: false);
    String themeModeName;
    LocalHandler localHandler = LocalHandler();
    try {
      themeModeName = await localHandler.getTheme();
    } catch (e) {
      print("Error fetching theme: $e");
      return;
    }
    print("{❌❌❌❌themeMode.name $themeModeName}");
    if (themeModeName.toLowerCase() == "dark") {
      appColor.setTheme(ThemeMode.dark);
    } else {
      appColor.setTheme(ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBG,
      body: Consumer<AppColor>(builder: (context, appColor, child) {
        return Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AppBranding.splashLogo(context, appColor.getTheme),
              );
            },
          ),
        );
      }),
    );
  }
}

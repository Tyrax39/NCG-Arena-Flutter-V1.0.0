import 'package:neoncave_arena/DB/shared_preference_helper.dart';
import 'package:neoncave_arena/screens/language/view_model/language_view_model.dart';
import 'package:neoncave_arena/screens/organization_detail/view_model/organization_detail_view_model.dart';
import 'package:neoncave_arena/screens/team/view_model/team_view_model.dart';
import 'package:neoncave_arena/screens/tournament_detail/view_model/tournament_detail_view_model.dart';
import 'package:neoncave_arena/screens/wallet/view_model/wallet_view_model.dart';
import 'package:neoncave_arena/localization/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:neoncave_arena/utils/firebase_runtime.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';
import 'theme/colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'screens/main/view_model/main_screen_view_model.dart';
import 'package:neoncave_arena/backend/shared_web_service.dart';
import 'package:neoncave_arena/constant/app_branding.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseRuntime.initializeBackground();
}

bool darkModeOn = false;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> initializeStripe() async {
  try {
    debugPrint('Starting Stripe initialization...');
    final siteSettingResponse =
        await SharedWebService.instance().siteSettingData();
    
    debugPrint('Site settings response status: ${siteSettingResponse.status}');
    
    if (siteSettingResponse.status == 200 &&
        siteSettingResponse.setting != null) {
      final settings = siteSettingResponse.setting!;
      debugPrint('Stripe public key available: ${settings.stripePublicKey != null}');
      debugPrint('Stripe public key length: ${settings.stripePublicKey?.length ?? 0}');
      
      if (settings.stripePublicKey != null &&
          settings.stripePublicKey!.isNotEmpty) {
        Stripe.publishableKey = settings.stripePublicKey!;
        await Stripe.instance.applySettings();
        debugPrint('Stripe initialized successfully with key: ${settings.stripePublicKey!.substring(0, 10)}...');
      } else {
        debugPrint('Stripe public key not found in site settings');
        // Don't set Stripe.publishableKey to null, just leave it unset
      }
    } else {
      debugPrint('Failed to fetch site settings for Stripe. Status: ${siteSettingResponse.status}');
      // Don't set Stripe.publishableKey to null, just leave it unset
    }
  } catch (e) {
    debugPrint('Error initializing Stripe: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await FirebaseRuntime.initialize();
  await initializeStripe();

  if (FirebaseRuntime.isInitialized) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(message.notification?.body);
      debugPrint(message.notification?.title);
    });
  } else {
    debugPrint('Firebase features are disabled for this run.');
  }

  tz.initializeTimeZones();
  await SharedPreferenceHelper.initializeSharedPreferences();
  
  // Initialize AppColor and wait for theme initialization
  final appColor = AppColor();
  await appColor.initializeTheme();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppColor>.value(
            value: appColor,
          ),
          ChangeNotifierProvider<MainScreenProvider>(
            create: (context) => MainScreenProvider(),
          ),
          ChangeNotifierProvider<OrganizationViewModel>(
            create: (context) => OrganizationViewModel(),
          ),
          ChangeNotifierProvider<LanguageViewModel>(
            create: (context) => LanguageViewModel(),
          ),
          ChangeNotifierProvider<TournamentDetailViewmodel>(
            create: (context) => TournamentDetailViewmodel(),
          ),
          ChangeNotifierProvider<WalletViewModel>(
            create: (context) => WalletViewModel(),
          ),
          ChangeNotifierProvider<TeamViewModel>(
            create: (context) => TeamViewModel(),
          ),
        ],
        child: EasyLocalization(
          path: 'assets/localization',
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('es'),
            Locale('fr'),
            Locale('hi'),
            Locale('zh'),
          ],
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: const MyApp(),
        ),
      ),
    );
  });
}

AppColor appColor = AppColor();

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRoutes();
    return Consumer<LanguageViewModel>(
      builder: (context, value, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Consumer<AppColor>(
            builder: (context, appColor, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                title: AppBranding.appDisplayName,
                initialRoute: MyRoutes.splashView,
                onGenerateRoute: router.generateRoutes,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: appColor.getTheme,
                locale: value.appLocale ?? context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: [
                  ...context.localizationDelegates,
                  FlutterQuillLocalizations.delegate,
                ],
              );
            },
          ),
        );
      },
    );
  }
}

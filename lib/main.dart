import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/go212_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/phone_entry_screen.dart';
import 'features/auth/otp_screen.dart';
import 'features/services/gowash/gowash_intro_screen.dart';
import 'features/services/goride/goride_detail_screen.dart';
import 'features/booking/gowash_booking_screen.dart';
import 'features/booking/payment_screen.dart';
import 'features/booking/success_screen.dart';
import 'app/main_shell.dart';
import 'features/home/home_screen.dart';
import 'package:feature_gofix/presentation/pages/gofix_landing_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_gofix/presentation/bloc/gofix_bloc.dart';
import 'package:feature_gofix/presentation/bloc/gofix_event.dart';
import 'package:feature_gofix/data/repositories/gofix_repository_impl.dart';
import 'package:feature_gofix/data/data_sources/gofix_remote_data_source.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  // GLOBAL WRAP: Ensuring GoFixBloc is available everywhere ( image_absolute_fix )
  runApp(
    BlocProvider(
      create: (context) => GoFixBloc(
        repository: GoFixRepositoryImpl(
          remoteDataSource: GoFixRemoteDataSourceImpl(),
        ),
      )..add(LoadGoFixCategories()),
      child: const Go212App(),
    ),
  );
}

class Go212App extends StatelessWidget {
  const Go212App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GO212',
      debugShowCheckedModeBanner: false,
      theme: Go212Theme.light(),
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const SplashScreen();
            break;
          case '/onboarding':
            page = const OnboardingScreen();
            break;
          case '/welcome':
            page = const WelcomeScreen();
            break;
          case '/signup':
            page = const PhoneEntryScreen(isSignUp: true);
            break;
          case '/login':
            page = const PhoneEntryScreen(isSignUp: false);
            break;
          case '/otp':
            page = const OtpScreen();
            break;
          case '/main':
            page = const MainShell();
            break;
          case '/service/gowash':
            page = const GoWashIntroScreen();
            break;
          case '/service/goride':
            page = const GoRideDetailScreen();
            break;
          case '/booking/gowash':
            page = const GoWashBookingScreen();
            break;
          case '/payment':
            page = const PaymentScreen();
            break;
          case '/success':
            page = const SuccessScreen();
            break;
          case '/service/gofix':
            page = const GoFixLandingPage();
            break;
          default:
            page = _PlaceholderScreen(routeName: settings.name ?? 'Unknown');
            break;
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            if (settings.name == '/' || settings.name == '/main') {
              return FadeTransition(opacity: animation, child: child);
            }
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
      },
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String routeName;
  const _PlaceholderScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    final serviceName = routeName.split('/').last;
    final displayName = serviceName.isNotEmpty
        ? serviceName[0].toUpperCase() + serviceName.substring(1)
        : 'Service';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          displayName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  size: 36,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                displayName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cette page sera bientôt disponible.\nRestez connecté !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Retour', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

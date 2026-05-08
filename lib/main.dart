import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/go212_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/phone_entry_screen.dart';
import 'features/auth/otp_screen.dart';
import 'features/services/gowash/gowash_detail_screen.dart';
import 'features/services/goride/goride_detail_screen.dart';
import 'features/booking/gowash_booking_screen.dart';
import 'features/booking/payment_screen.dart';
import 'features/booking/success_screen.dart';
import 'app/main_shell.dart';
import 'features/services/gobike/gobike_intro_screen.dart';
import 'features/services/gobike/gobike_services_screen.dart';
import 'features/services/gobike/gobike_rental_form_screen.dart';
import 'features/services/gobike/gobike_duration_screen.dart';
import 'features/services/gobike/gobike_packs_screen.dart';
import 'features/services/gobike/gobike_group_reservation_screen.dart';
import 'features/services/gobike/gobike_customize_screen.dart';
import 'features/services/gobike/gobike_loading_screen.dart';
import 'features/services/gobike/gobike_delivery_choice_screen.dart';
import 'features/services/gobike/gobike_agency_selection_screen.dart';
import 'features/services/gobike/gobike_agency_detail_screen.dart';
import 'features/services/gobike/gobike_map_selection_screen.dart';
import 'features/services/gobike/gobike_checkout_screen.dart';
import 'features/services/gobike/gobike_add_card_screen.dart';
import 'features/services/gobike/gobike_success_screen.dart';
import 'features/services/gobike/gobike_tracking_connection_screen.dart';
import 'features/services/gobike/gobike_live_tracking_screen.dart';
import 'features/services/gobike/gobike_review_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
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
  runApp(const Go212App());
}

class Go212App extends StatelessWidget {
  const Go212App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GO212',
      debugShowCheckedModeBanner: false,
      theme: Go212Theme.light(),
      initialRoute: '/',
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
            page = const GoWashDetailScreen();
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
          case '/service/gobike':
            page = const GoBikeIntroScreen();
            break;
          case '/service/gobike/services':
            page = const GoBikeServicesScreen();
            break;
          case '/service/gobike/rental-form':
            page = const GoBikeRentalFormScreen();
            break;
          case '/service/gobike/duration':
            page = const GoBikeDurationScreen();
            break;
          case '/service/gobike/packs':
            page = const GoBikePacksScreen();
            break;
          case '/service/gobike/group-reservation':
            page = const GoBikeGroupReservationScreen();
            break;
          case '/service/gobike/customize':
            page = const GoBikeCustomizeScreen();
            break;
          case '/service/gobike/loading':
            page = const GoBikeLoadingScreen();
            break;
          case '/service/gobike/delivery-choice':
            page = const GoBikeDeliveryChoiceScreen();
            break;
          case '/service/gobike/agency-selection':
            page = const GoBikeAgencySelectionScreen();
            break;
          case '/service/gobike/agency-detail':
            page = const GoBikeAgencyDetailScreen();
            break;
          case '/service/gobike/map-selection':
            page = const GoBikeMapSelectionScreen();
            break;
          case '/service/gobike/checkout':
            final receptionMode = settings.arguments as String? ?? 'delivery';
            page = GoBikeCheckoutScreen(receptionMode: receptionMode);
            break;
          case '/service/gobike/add-card':
            page = const GoBikeAddCardScreen();
            break;
          case '/service/gobike/success':
            final receptionMode = settings.arguments as String? ?? 'delivery';
            page = GoBikeSuccessScreen(receptionMode: receptionMode);
            break;
          case '/service/gobike/tracking-connection':
            page = const GoBikeTrackingConnectionScreen();
            break;
          case '/service/gobike/live-tracking':
            page = const GoBikeLiveTrackingScreen();
            break;
          case '/service/gobike/review':
            page = const GoBikeReviewScreen();
            break;
          default:
            // For unimplemented service routes, show a placeholder
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
    // Extract service name from route
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

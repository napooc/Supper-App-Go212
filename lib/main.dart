import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/go212_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/phone_entry_screen.dart';
import 'features/auth/otp_screen.dart';
import 'features/services/gowash/gowash_detail_screen.dart';
import 'features/booking/gowash_booking_screen.dart';
import 'features/booking/payment_screen.dart';
import 'features/booking/success_screen.dart';
import 'app/main_shell.dart';
import 'features/goride/kyc/kyc_cin_screen.dart';
import 'features/goride/kyc/kyc_scan_screen.dart';
import 'features/goride/kyc/kyc_selfie_screen.dart';
import 'features/goride/kyc/kyc_verify_screen.dart';
import 'features/goride/kyc/kyc_success_screen.dart';
import 'features/goride/transition/goride_transition_screen.dart';
import 'features/goride/booking/goride_persons_screen.dart';
import 'features/goride/booking/goride_duration_screen.dart';
import 'features/goride/booking/goride_details_screen.dart';
import 'features/goride/booking/goride_delivery_screen.dart';
import 'features/goride/booking/goride_summary_screen.dart';
import 'features/goride/booking/goride_payment_screen.dart';
import 'features/goride/booking/goride_confirm_screen.dart';
import 'features/goride/booking/goride_tracking_screen.dart';
import 'features/goride/booking/goride_agence_screen.dart';
import 'features/goride/booking/goride_review_screen.dart';
import 'features/goride/booking/goride_thankyou_screen.dart';

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
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/onboarding':
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case '/signup':
            return MaterialPageRoute(
                builder: (_) => const PhoneEntryScreen(isSignUp: true));
          case '/login':
            return MaterialPageRoute(
                builder: (_) => const PhoneEntryScreen(isSignUp: false));
          case '/otp':
            return MaterialPageRoute(builder: (_) => const OtpScreen());
          case '/main':
            return MaterialPageRoute(builder: (_) => const MainShell());
          case '/service/gowash':
            return MaterialPageRoute(
                builder: (_) => const GoWashDetailScreen());
          case '/service/goride':
            return MaterialPageRoute(
                builder: (_) => const GoRideKycCinScreen());
          case '/booking/gowash':
            return MaterialPageRoute(
                builder: (_) => const GoWashBookingScreen());
          case '/payment':
            return MaterialPageRoute(builder: (_) => const PaymentScreen());
          case '/success':
            return MaterialPageRoute(builder: (_) => const SuccessScreen());
          // ── GoRide ──────────────────────────────────────
          case '/goride/kyc/cin':
            return MaterialPageRoute(
                builder: (_) => const GoRideKycCinScreen());
          case '/goride/kyc/scan':
            return MaterialPageRoute(
                builder: (_) => const GoRideKycScanScreen());
          case '/goride/kyc/selfie':
            return MaterialPageRoute(
                builder: (_) => const GoRideKycSelfieScreen());
          case '/goride/kyc/verify':
            return MaterialPageRoute(
                builder: (_) => const GoRideKycVerifyScreen());
          case '/goride/kyc/success':
            return MaterialPageRoute(
                builder: (_) => const GoRideKycSuccessScreen());
          case '/goride/transition':
            return MaterialPageRoute(
                builder: (_) => const GoRideTransitionScreen());
          case '/goride/booking/persons':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRidePersonsScreen());
          case '/goride/booking/duration':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideDurationScreen());
          case '/goride/booking/details':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideDetailsScreen());
          case '/goride/booking/delivery':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideDeliveryScreen());
          case '/goride/booking/summary':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideSummaryScreen());
          case '/goride/booking/payment':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRidePaymentScreen());
          case '/goride/booking/confirm':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideConfirmScreen());
          case '/goride/tracking':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideTrackingScreen());
          case '/goride/agence':
          case '/goride/booking/agence':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const GoRideAgenceScreen());
          case '/goride/review':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const GoRideReviewScreen());
          case '/goride/thankyou':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoRideThankYouScreen());
          default:
            return MaterialPageRoute(
                builder: (_) => const _PlaceholderScreen());
        }
      },
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GO212')),
      body: const Center(child: Text('Page en construction')),
    );
  }
}

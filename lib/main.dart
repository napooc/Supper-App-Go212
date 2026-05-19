import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/main_shell.dart';
import 'core/theme/go212_theme.dart';
import 'features/auth/otp_screen.dart';
import 'features/auth/phone_entry_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/booking/gowash_booking_screen.dart';
import 'features/booking/payment_screen.dart';
import 'features/booking/success_screen.dart';
import 'features/goride/booking/goride_agence_screen.dart';
import 'features/goride/booking/goride_confirm_screen.dart';
import 'features/goride/booking/goride_delivery_screen.dart';
import 'features/goride/booking/goride_details_screen.dart';
import 'features/goride/booking/goride_duration_screen.dart';
import 'features/goride/booking/goride_payment_screen.dart';
import 'features/goride/booking/goride_persons_screen.dart';
import 'features/goride/booking/goride_review_screen.dart';
import 'features/goride/booking/goride_summary_screen.dart';
import 'features/goride/booking/goride_thankyou_screen.dart';
import 'features/goride/booking/goride_tracking_screen.dart';
import 'features/goride/kyc/kyc_cin_screen.dart';
import 'features/goride/kyc/kyc_scan_screen.dart';
import 'features/goride/kyc/kyc_selfie_screen.dart';
import 'features/goride/kyc/kyc_success_screen.dart';
import 'features/goride/kyc/kyc_verify_screen.dart';
import 'features/goride/transition/goride_transition_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/services/gobike/gobike_add_card_screen.dart';
import 'features/services/gobike/gobike_agency_detail_screen.dart';
import 'features/services/gobike/gobike_agency_selection_screen.dart';
import 'features/services/gobike/gobike_checkout_screen.dart';
import 'features/services/gobike/gobike_customize_screen.dart';
import 'features/services/gobike/gobike_delivery_choice_screen.dart';
import 'features/services/gobike/gobike_duration_screen.dart';
import 'features/services/gobike/gobike_group_reservation_screen.dart';
import 'features/services/gobike/gobike_intro_screen.dart';
import 'features/services/gobike/gobike_live_tracking_screen.dart';
import 'features/services/gobike/gobike_loading_screen.dart';
import 'features/services/gobike/gobike_map_selection_screen.dart';
import 'features/services/gobike/gobike_packs_screen.dart';
import 'features/services/gobike/gobike_rental_form_screen.dart';
import 'features/services/gobike/gobike_review_screen.dart';
import 'features/services/gobike/gobike_services_screen.dart';
import 'features/services/gobike/gobike_success_screen.dart';
import 'features/services/gobike/gobike_tracking_connection_screen.dart';
import 'features/services/gobike/gobike_bike_map_screen.dart';
import 'features/services/gobike/gobike_bike_payment_screen.dart';
import 'features/services/gobike/gobike_active_ride_screen.dart';
import 'features/services/gowash/gowash_detail_screen.dart';
import 'features/services/gowash/gowash_intro_screen.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
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
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const OtpScreen());
          case '/main':
            return MaterialPageRoute(builder: (_) => const MainShell());
          case '/service/gowash':
            return MaterialPageRoute(
                builder: (_) => const GoWashIntroScreen());
          case '/service/gowash/detail':
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
          case '/service/gobike':
            return MaterialPageRoute(builder: (_) => const GoBikeIntroScreen());
          case '/service/gobike/services':
            return MaterialPageRoute(
                builder: (_) => const GoBikeServicesScreen());
          case '/service/gobike/rental-form':
            return MaterialPageRoute(
                builder: (_) => const GoBikeRentalFormScreen());
          case '/service/gobike/duration':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoBikeDurationScreen());
          case '/service/gobike/packs':
            return MaterialPageRoute(builder: (_) => const GoBikePacksScreen());
          case '/service/gobike/group-reservation':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoBikeGroupReservationScreen());
          case '/service/gobike/customize':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoBikeCustomizeScreen());
          case '/service/gobike/loading':
            return MaterialPageRoute(
                builder: (_) => const GoBikeLoadingScreen());
          case '/service/gobike/delivery-choice':
            return MaterialPageRoute(
                builder: (_) => const GoBikeDeliveryChoiceScreen());
          case '/service/gobike/agency-selection':
            return MaterialPageRoute(
                builder: (_) => const GoBikeAgencySelectionScreen());
          case '/service/gobike/agency-detail':
            return MaterialPageRoute(
                builder: (_) => const GoBikeAgencyDetailScreen());
          case '/service/gobike/map-selection':
            return MaterialPageRoute(
                builder: (_) => const GoBikeMapSelectionScreen());
          case '/service/gobike/checkout':
            // Args can be a Map (new pricing flow) or a plain String (legacy)
            final _checkoutArgs = settings.arguments;
            final receptionMode = _checkoutArgs is Map
                ? (_checkoutArgs['deliveryMode'] as String? ?? 'delivery')
                : (_checkoutArgs as String? ?? 'delivery');
            return MaterialPageRoute(
                builder: (_) =>
                    GoBikeCheckoutScreen(receptionMode: receptionMode));
          case '/service/gobike/add-card':
            return MaterialPageRoute(
                builder: (_) => const GoBikeAddCardScreen());
          case '/service/gobike/success':
            final _successArgs = settings.arguments;
            final successReceptionMode = _successArgs is Map
                ? (_successArgs['deliveryMode'] as String? ?? 'delivery')
                : (_successArgs as String? ?? 'delivery');
            return MaterialPageRoute(
                builder: (_) =>
                    GoBikeSuccessScreen(receptionMode: successReceptionMode));
          case '/service/gobike/tracking-connection':
            return MaterialPageRoute(
                builder: (_) => const GoBikeTrackingConnectionScreen());
          case '/service/gobike/live-tracking':
            return MaterialPageRoute(
                builder: (_) => const GoBikeLiveTrackingScreen());
          case '/service/gobike/bike-map':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const GoBikeBikeMapScreen());
          case '/service/gobike/bike-payment':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => GoBikeBikePaymentScreen(station: settings.arguments is BikeStation ? settings.arguments as BikeStation : null));
          case '/service/gobike/active-ride':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => GoBikeActiveRideScreen(station: settings.arguments is BikeStation ? settings.arguments as BikeStation : null));
          case '/service/gobike/review':
            return MaterialPageRoute(
                builder: (_) => const GoBikeReviewScreen());
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

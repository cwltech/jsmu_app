import 'package:flutter/material.dart';

import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/customer/booking/screens/booking_checkout_screen.dart';
import '../features/customer/booking/screens/my_bookings_screen.dart';
import '../features/customer/catalog/screens/service_details_screen.dart';
import '../features/customer/home/screens/home_screen.dart';
import '../features/customer/profile/screens/customer_profile_screen.dart';
import '../features/customer/tracking/screens/live_tracking_screen.dart';
import '../features/partner/screens/partner_dashboard_screen.dart';
import '../features/partner/screens/partner_dispatch_screen.dart';
import '../features/partner/screens/partner_earnings_screen.dart';
import '../features/partner/screens/partner_profile_screen.dart';
import '../features/partner/screens/job_execution_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case AppRoutes.signUp:
      case AppRoutes.signIn:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const CustomerProfileScreen(),
          settings: settings,
        );
      case AppRoutes.partnerProfile:
        return MaterialPageRoute(
          builder: (_) => const PartnerProfileScreen(),
          settings: settings,
        );
      case AppRoutes.services:
      case '/services':
      case AppRoutes.serviceDetails:
        return MaterialPageRoute(
          builder: (_) => const ServiceDetailsScreen(),
          settings: settings,
        );
      case '/booking-checkout':
      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => const BookingCheckoutScreen(),
          settings: settings,
        );
      case AppRoutes.myBookings:
        return MaterialPageRoute(
          builder: (_) => const MyBookingsScreen(),
          settings: settings,
        );
      case AppRoutes.liveTracking:
        return MaterialPageRoute(
          builder: (_) => const LiveTrackingScreen(),
          settings: settings,
        );
      case AppRoutes.partnerDispatch:
        return MaterialPageRoute(
          builder: (_) => const PartnerDispatchScreen(),
          settings: settings,
        );
      case AppRoutes.partnerDashboard:
        return MaterialPageRoute(
          builder: (_) => const PartnerDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.partnerEarnings:
        return MaterialPageRoute(
          builder: (_) => const PartnerEarningsScreen(),
          settings: settings,
        );
      case AppRoutes.partnerJobExecution:
        return MaterialPageRoute(
          builder: (_) => const JobExecutionScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}

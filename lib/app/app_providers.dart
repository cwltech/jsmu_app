import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/customer/booking/providers/booking_provider.dart';
import '../features/customer/catalog/providers/service_catalog_provider.dart';
import '../features/customer/home/providers/home_provider.dart';
import '../features/customer/tracking/providers/tracking_provider.dart';
import '../features/partner/providers/partner_provider.dart';

class AppProviders {
  AppProviders._();

  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => ServiceCatalogProvider()),
    ChangeNotifierProvider(create: (_) => BookingProvider()),
    ChangeNotifierProvider(create: (_) => TrackingProvider()),
    ChangeNotifierProvider(create: (_) => PartnerProvider()),
  ];
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../home/widgets/service_detail_popup.dart';
import '../models/service_item_model.dart';
import '../providers/service_catalog_provider.dart';

/// Explore Services Screen
/// Displays 2-column grid of service cards matching the Most Booked Services
/// styling with interactive domain chip filters, card detail popups, add to cart,
/// floating cart bar right above the bottom navigation bar.
class ServiceDetailsScreen extends StatefulWidget {
  final bool showBottomBar;
  const ServiceDetailsScreen({super.key, this.showBottomBar = true});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

// Alias for ExploreServicesScreen
typedef ExploreServicesScreen = ServiceDetailsScreen;

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  String _selectedDomain = 'All Services';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _domains = const [
    'All Services',
    'Taps & Mixers',
    'Toilets & Cistern',
    'Pipes & Leaks',
    'Water Tank & Motors',
    'Sanitary Ware',
    'Inspection & Audit',
  ];

  final List<Map<String, dynamic>> _services = const [
    // 1. TAPS & MIXERS
    {
      'id': 'mb-1',
      'title': 'Mixer Tap & Leak Fix',
      'domain': 'Taps & Mixers',
      'categoryTag': 'TAP & BASIN FITTING',
      'duration': '45 mins',
      'rating': 4.9,
      'reviewsCount': '1.2k',
      'subtitle': '30-day post-service guarantee',
      'price': 299,
      'originalPrice': 399,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-tap-2',
      'title': 'Kitchen Sink Tap Fit',
      'domain': 'Taps & Mixers',
      'categoryTag': 'KITCHEN FITTINGS',
      'duration': '35 mins',
      'rating': 4.8,
      'reviewsCount': '980',
      'subtitle': 'Wall & deck mounted tap fitment',
      'price': 249,
      'originalPrice': 349,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-tap-3',
      'title': 'Shower & Spout Fix',
      'domain': 'Taps & Mixers',
      'categoryTag': 'BATH FITTINGS',
      'duration': '40 mins',
      'rating': 4.9,
      'reviewsCount': '750',
      'subtitle': 'Dual temperature flow tuning',
      'price': 349,
      'originalPrice': 499,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-tap-4',
      'title': 'Angle Valve Replace',
      'domain': 'Taps & Mixers',
      'categoryTag': 'VALVES & CONNECTORS',
      'duration': '20 mins',
      'rating': 4.9,
      'reviewsCount': '1.5k',
      'subtitle': 'High-pressure braided hose fit',
      'price': 179,
      'originalPrice': 249,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=500&q=80',
    },

    // 2. TOILETS & CISTERN
    {
      'id': 'mb-2',
      'title': 'Wall Hung Commode',
      'domain': 'Toilets & Cistern',
      'categoryTag': 'SANITARY INSTALL',
      'duration': '60 mins',
      'rating': 4.8,
      'reviewsCount': '850',
      'subtitle': 'Flush tank & bracket setup',
      'price': 699,
      'originalPrice': 899,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-toi-2',
      'title': 'Flush Tank Repair',
      'domain': 'Toilets & Cistern',
      'categoryTag': 'TOILET REPAIR',
      'duration': '35 mins',
      'rating': 4.7,
      'reviewsCount': '1.1k',
      'subtitle': 'Syphon & push button overhaul',
      'price': 349,
      'originalPrice': 449,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-toi-3',
      'title': 'Floor Mount Commode',
      'domain': 'Toilets & Cistern',
      'categoryTag': 'SANITARY INSTALL',
      'duration': '50 mins',
      'rating': 4.8,
      'reviewsCount': '920',
      'subtitle': 'Wax seal & floor bolt securing',
      'price': 549,
      'originalPrice': 749,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-toi-4',
      'title': 'Jet Spray & Bidet Fit',
      'domain': 'Toilets & Cistern',
      'categoryTag': 'TOILET ACCESSORIES',
      'duration': '25 mins',
      'rating': 4.9,
      'reviewsCount': '1.4k',
      'subtitle': 'Leak-free brass coupler install',
      'price': 199,
      'originalPrice': 299,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
    },

    // 3. PIPES & LEAKS
    {
      'id': 'mb-3',
      'title': 'Pipe Seepage & Leak',
      'domain': 'Pipes & Leaks',
      'categoryTag': 'LEAK REPAIR',
      'duration': '50 mins',
      'rating': 4.7,
      'reviewsCount': '410',
      'subtitle': 'Solvent seal & replacement',
      'price': 449,
      'originalPrice': 599,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-pipe-2',
      'title': 'Drain Unclog & Clear',
      'domain': 'Pipes & Leaks',
      'categoryTag': 'DRAINAGE CARE',
      'duration': '40 mins',
      'rating': 4.8,
      'reviewsCount': '1.5k',
      'subtitle': 'Mechanical snake blockage removal',
      'price': 399,
      'originalPrice': 549,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-pipe-3',
      'title': 'Brass Gate Valve Fix',
      'domain': 'Pipes & Leaks',
      'categoryTag': 'PLUMBING HARDWARE',
      'duration': '45 mins',
      'rating': 4.9,
      'reviewsCount': '820',
      'subtitle': 'Main overhead inflow line valve',
      'price': 499,
      'originalPrice': 649,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-pipe-4',
      'title': 'PVC Waste Pipe Fit',
      'domain': 'Pipes & Leaks',
      'categoryTag': 'DRAIN REPAIR',
      'duration': '30 mins',
      'rating': 4.8,
      'reviewsCount': '670',
      'subtitle': 'Anti-odour trap & coupling fit',
      'price': 299,
      'originalPrice': 399,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
    },

    // 4. WATER TANK & MOTORS
    {
      'id': 'srv-tank-1',
      'title': 'Water Tank Ball Valve',
      'domain': 'Water Tank & Motors',
      'categoryTag': 'WATER TANK CARE',
      'duration': '35 mins',
      'rating': 4.9,
      'reviewsCount': '640',
      'subtitle': 'Brass float valve & auto shut-off',
      'price': 499,
      'originalPrice': 699,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-tank-2',
      'title': 'Water Tank Cleaning',
      'domain': 'Water Tank & Motors',
      'categoryTag': 'TANK SANITATION',
      'duration': '90 mins',
      'rating': 4.9,
      'reviewsCount': '1.8k',
      'subtitle': '4-stage vacuum sludge removal',
      'price': 899,
      'originalPrice': 1199,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-tank-3',
      'title': 'Automatic Pump Switch',
      'domain': 'Water Tank & Motors',
      'categoryTag': 'PUMP & MOTORS',
      'duration': '45 mins',
      'rating': 4.8,
      'reviewsCount': '510',
      'subtitle': 'Dry-run sensor & starter panel',
      'price': 599,
      'originalPrice': 799,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
    },

    // 5. SANITARY WARE
    {
      'id': 'srv-san-1',
      'title': 'Wash Basin Fitment',
      'domain': 'Sanitary Ware',
      'categoryTag': 'SANITARY WARE',
      'duration': '45 mins',
      'rating': 4.8,
      'reviewsCount': '710',
      'subtitle': 'Under-counter or wall mount setup',
      'price': 399,
      'originalPrice': 549,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-san-2',
      'title': 'Pedestal Basin Setup',
      'domain': 'Sanitary Ware',
      'categoryTag': 'BASIN FITTING',
      'duration': '50 mins',
      'rating': 4.8,
      'reviewsCount': '560',
      'subtitle': 'Full silicone waterproofing seal',
      'price': 499,
      'originalPrice': 699,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=500&q=80',
    },

    // 6. INSPECTION & AUDIT
    {
      'id': 'mb-4',
      'title': 'Plumbing Inspection',
      'domain': 'Inspection & Audit',
      'categoryTag': 'INSPECTION',
      'duration': '30 mins',
      'rating': 4.9,
      'reviewsCount': '540',
      'subtitle': 'Full audit + leak check report',
      'price': 199,
      'originalPrice': 299,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 'srv-insp-2',
      'title': 'Water Pressure Audit',
      'domain': 'Inspection & Audit',
      'categoryTag': 'DIAGNOSTICS',
      'duration': '25 mins',
      'rating': 4.8,
      'reviewsCount': '430',
      'subtitle': 'Bar gauge flow pressure test',
      'price': 249,
      'originalPrice': 349,
      'rateType': 'Standard Rate',
      'imageUrl':
          'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredServices {
    return _services.where((srv) {
      final matchesDomain =
          _selectedDomain == 'All Services' || srv['domain'] == _selectedDomain;
      final matchesQuery =
          _searchQuery.isEmpty ||
          (srv['title'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (srv['categoryTag'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (srv['subtitle'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesDomain && matchesQuery;
    }).toList();
  }

  void _openServiceDetailPopup(
    BuildContext context,
    Map<String, dynamic> service,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ServiceDetailPopup(
        package: {
          'title': service['title'],
          'category': service['categoryTag'],
          'price': service['price'],
          'originalPrice': service['originalPrice'],
          'rating': service['rating'],
          'reviewsCount': service['reviewsCount'],
          'duration': service['duration'],
          'imageUrl': service['imageUrl'],
        },
      ),
    );
  }

  void _addToCart(BuildContext context, Map<String, dynamic> service) {
    final catalog = context.read<ServiceCatalogProvider>();
    final model = ServiceItemModel(
      id: service['id'] as String,
      badge: service['duration'] as String? ?? '30 mins',
      title: service['title'] as String,
      duration: service['duration'] as String? ?? '30 mins',
      rating: (service['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: service['reviewsCount'] as String? ?? '500+',
      price: service['price'] as num,
      originalPrice: service['originalPrice'] as num,
      discountPercent:
          (((service['originalPrice'] as num) - (service['price'] as num)) /
                  (service['originalPrice'] as num) *
                  100)
              .round(),
      features: const [
        '30-day post service warranty',
        'Certified background-checked expert',
        'Genuine parts & industrial-grade PTFE sealant',
      ],
      imageUrl: service['imageUrl'] as String,
    );

    catalog.addToCart(model);
    AppSnackbar.showSuccess(
      context,
      'Added "${service['title']}" to your cart',
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<ServiceCatalogProvider>();
    const Color bgWarm = Color(0xFFFBF8F4);
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Scaffold(
      backgroundColor: bgWarm,
      appBar: AppBar(
        backgroundColor: bgWarm,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // Root bottom bar tab
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EAE4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: primaryRust,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Gurugram, Sector 48',
                      style: GoogleFonts.plusJakartaSans(
                        color: textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textDark,
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  'JSMU Doorstep & Repairs',
                  style: GoogleFonts.plusJakartaSans(
                    color: textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Cart Icon Button with Real-time Count Badge
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: textDark,
                    size: 24,
                  ),
                  if (catalog.totalItemCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1.5,
                        ),
                        decoration: const BoxDecoration(
                          color: primaryRust,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${catalog.totalItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // User Profile Avatar Button
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(right: 16, left: 4),
              decoration: BoxDecoration(
                color: primaryRust,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/profile_user.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header & Search Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore Services',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: textDark,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Doorstep repair & installation by verified pros',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EBE5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_filteredServices.length} Services',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Interactive Live Search Field
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFEFE8E1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val.trim()),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            color: textDark,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Search taps, leaks, cistern, tank fix...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: textMuted.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: primaryRust,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: textMuted,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Domain Chip Filters (Horizontal Scroll)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: _domains.map((domain) {
                            final isSelected = _selectedDomain == domain;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedDomain = domain),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF822711)
                                        : const Color(0xFFF1EAE4),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF822711,
                                              ).withValues(alpha: 0.25),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    domain,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF4A3E39),
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // 2-Column Grid of Service Cards matching Most Booked Cards
              if (_filteredServices.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No services found for "$_searchQuery"',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try searching for "tap", "commode", "pipe" or clear filters',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _selectedDomain = 'All Services';
                            });
                          },
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: catalog.totalItemCount > 0 ? 100 : 24,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.635,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final service = _filteredServices[index];
                      return _buildServiceCard(context, service, catalog);
                    }, childCount: _filteredServices.length),
                  ),
                ),
            ],
          ),

          // Floating Cart Bar (Appears right above bottom bar when cart has items)
          if (catalog.totalItemCount > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: _buildFloatingCartBar(context, catalog),
            ),
        ],
      ),
      bottomNavigationBar: widget.showBottomBar
          ? _buildBottomNavigationBar(context, catalog)
          : null,
    );
  }

  // Service Card matching the exact Figma & Home screen Most Booked card
  Widget _buildServiceCard(
    BuildContext context,
    Map<String, dynamic> service,
    ServiceCatalogProvider catalog,
  ) {
    const Color primaryRust = Color(0xFF822711);
    final isAdded = catalog.getQuantity(service['id'] as String) > 0;
    final qty = catalog.getQuantity(service['id'] as String);

    return GestureDetector(
      onTap: () => _openServiceDetailPopup(context, service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF0EBE6), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Image Box with Rounded Corners and Badges
            Container(
              height: 188,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.surfaceCard,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: service['imageUrl'] as String,
                      fit: BoxFit.cover,
                      placeholder: (c, u) =>
                          Container(color: AppColors.surfaceCard),
                      errorWidget: (c, u, e) =>
                          Container(color: AppColors.surfaceMuted),
                    ),
                  ),

                  // Duration Badge (#FFDAD3 background as in reference)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        service['duration'] as String,
                        style: const TextStyle(
                          color: Color(0xFF721500),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // Rating Badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF59E0B),
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${service['rating']} (${service['reviewsCount']})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Category Tag in Rust Caps
            Text(
              (service['categoryTag'] as String).toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF9E2A0E),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Service Title
            Text(
              service['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
                color: Color(0xFF1A1A1A),
                height: 1.15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Subtitle
            Text(
              service['subtitle'] as String,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF757575),
                height: 1.15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0EBE6)),
            const SizedBox(height: 6),

            // Pricing and Action Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            Formatters.formatCurrency(service['price'] as int),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Formatters.formatCurrency(
                              service['originalPrice'] as int,
                            ),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 11,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        service['rateType'] as String,
                        style: const TextStyle(
                          color: Color(0xFF0F7B42),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // + Book Button (Interactive Add to Cart or Stepper)
                if (isAdded)
                  GestureDetector(
                    onTap: () => _openServiceDetailPopup(context, service),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: primaryRust,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Added ($qty)',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: primaryRust,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () => _addToCart(context, service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRust,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      '+ Book',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Floating Cart Bar (appears directly above Bottom Navigation Bar)
  Widget _buildFloatingCartBar(
    BuildContext context,
    ServiceCatalogProvider catalog,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF822711),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF822711).withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${catalog.totalItemCount} Service${catalog.totalItemCount > 1 ? 's' : ''} • ${Formatters.formatCurrency(catalog.totalCartPrice)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'View Cart & schedule technician slot',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Cart',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF822711),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Color(0xFF822711),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Persistent Bottom Navigation Bar
  Widget _buildBottomNavigationBar(
    BuildContext context,
    ServiceCatalogProvider catalog,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0EBE6), width: 1.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isActive: false,
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
              _buildNavItem(
                icon: Icons.home_repair_service_rounded,
                label: 'Services',
                isActive: true, // Explore Services is the active tab!
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                label: 'Bookings',
                badgeCount: '1',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/my-bookings'),
              ),
              _buildNavItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Cart',
                badgeCount: catalog.totalItemCount > 0
                    ? '${catalog.totalItemCount}'
                    : null,
                isActive: false,
                onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Account',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    String? badgeCount,
  }) {
    const activeColor = Color(0xFF862D17);
    const inactiveColor = Color(0xFF4A3E39);
    const activePillColor = Color(0xFFFDECE8);

    Widget iconWidget = Icon(
      icon,
      color: isActive ? activeColor : inactiveColor,
      size: 23,
    );

    if (badgeCount != null && badgeCount.isNotEmpty) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -3,
            right: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
              decoration: const BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
              alignment: Alignment.center,
              child: Text(
                badgeCount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? activePillColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: iconWidget,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: isActive ? activeColor : inactiveColor,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

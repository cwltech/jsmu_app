import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:jsmu/core/constants/app_colors.dart';
import 'package:jsmu/core/constants/app_sizes.dart';
import 'package:jsmu/core/constants/app_strings.dart';
import 'package:jsmu/core/network/mock_data.dart';
import 'package:jsmu/core/services/location_service.dart';
import 'package:jsmu/core/theme/app_text_styles.dart';
import 'package:jsmu/core/utils/formatters.dart';
import 'package:jsmu/core/widgets/app_loader.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';

import '../models/service_category.dart';
import '../providers/home_provider.dart';
import '../widgets/category_packages_sheet.dart';
import '../widgets/service_detail_popup.dart';
import '../../booking/screens/booking_checkout_screen.dart';
import '../../booking/screens/my_bookings_screen.dart';
import '../../catalog/screens/service_details_screen.dart';
import '../../profile/screens/customer_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final ScrollController _handpickedScrollController = ScrollController();
  final PageController _bannerPageController = PageController();
  final PageController _heroPageController = PageController();
  int _activeBannerIndex = 0;
  int _currentHeroIndex = 0;
  Timer? _heroTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchHomeData();
      _autoDetectLocation();
      _startHeroAutoSlide();
    });
  }

  void _startHeroAutoSlide() {
    _heroTimer?.cancel();
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_heroPageController.hasClients) return;
      final nextIndex = (_currentHeroIndex + 1) % 3;
      _heroPageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  Future<void> _autoDetectLocation() async {
    try {
      final loc = await LocationService.getCurrentLocation(
        askPermission: false,
      );
      if (mounted && !loc.isDefault) {
        context.read<HomeProvider>().setSelectedLocation(loc.title);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroPageController.dispose();
    _searchController.dispose();
    _handpickedScrollController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return PopScope(
      canPop: homeProvider.activeNavIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && homeProvider.activeNavIndex != 0) {
          homeProvider.setActiveNavIndex(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: homeProvider.activeNavIndex == 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(62),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0EBE6), width: 1.0),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: 8,
                      ),
                      child: _buildHeader(context, homeProvider),
                    ),
                  ),
                ),
              )
            : null,
        body: IndexedStack(
          index: homeProvider.activeNavIndex,
          children: [
            // Tab 0: Home Feed
            _buildHomeFeed(context, homeProvider),

            // Tab 1: Explore Services
            const ServiceDetailsScreen(showBottomBar: false),

            // Tab 2: Bookings
            const MyBookingsScreen(),

            // Tab 3: Cart / Checkout
            const BookingCheckoutScreen(),

            // Tab 4: Account / Profile
            const CustomerProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context, homeProvider),
      ),
    );
  }

  Widget _buildHomeFeed(BuildContext context, HomeProvider homeProvider) {
    return homeProvider.isLoading && homeProvider.categories.isEmpty
        ? const Center(child: AppLoader(message: 'Loading home services...'))
        : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: homeProvider.refreshHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.p12),

                  // 1. Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildSearchBar(context, homeProvider),
                  ),

                  const SizedBox(height: AppSizes.p16),

                  // 3. Hero Promo Banner ("Doorstep Plumbing & Sanitary Services")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildHeroPromoBanner(context),
                  ),

                  const SizedBox(height: AppSizes.p16),

                  // 4. Trust Badges Row (45 Mins, Verified Techs, 30-Day Warranty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildTrustBadgesRow(),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // 5. Explore Service Categories (8 Categories Grid with 3D Icons)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildCategoriesSection(context, homeProvider),
                  ),

                  const SizedBox(height: AppSizes.p16),

                  // 6. Quick Filter Chips Row (Full-width edge-to-edge Rust Banner)
                  _buildQuickFilterChips(context, homeProvider),

                  const SizedBox(height: AppSizes.p24),

                  // 7. Most Booked Services (2x2 Grid with Book Buttons)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildMostBookedServicesSection(
                      context,
                      homeProvider,
                    ),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // 8. Promotional Banners (Full-width edge-to-edge)
                  _buildPromotionalBannersSection(context),

                  const SizedBox(height: AppSizes.p24),

                  // 9. Handpicked for You (Carousel with Navigation Arrows)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildHandpickedSection(context, homeProvider),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // 10. The JSMU Service Guarantee Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildGuaranteeCard(),
                  ),

                  const SizedBox(height: AppSizes.p20),

                  // 11. Customer Testimonial Social Proof Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildCustomerReviewCard(),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // 12. CP Fittings Installation & Repair Promotional Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildCpFittingsBanner(context),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // 13. Popular Services Catalog (+ ADD Buttons)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                    ),
                    child: _buildPopularServicesCatalog(context),
                  ),

                  const SizedBox(height: AppSizes.p32),
                ],
              ),
            ),
          );
  }

  // 1. TOP HEADER (Location & Profile)
  Widget _buildHeader(BuildContext context, HomeProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSizes.p12),
            GestureDetector(
              onTap: () async {
                AppSnackbar.showInfo(context, 'Detecting real location...');
                final loc = await LocationService.getCurrentLocation(
                  askPermission: true,
                );
                provider.setSelectedLocation(loc.title);
                if (context.mounted) {
                  AppSnackbar.showSuccess(
                    context,
                    'Location set to ${loc.title}',
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSizes.p4),
                      Text(
                        'SERVICE AREA',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        provider.selectedLocation,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                AppSnackbar.showInfo(context, 'No new notifications right now');
              },
              icon: const Badge(
                backgroundColor: AppColors.primary,
                smallSize: 8,
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => provider.setActiveNavIndex(4),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                  fit: BoxFit.cover,
                  placeholder: (c, u) =>
                      Container(color: AppColors.surfaceCard),
                  errorWidget: (c, u, e) =>
                      const Icon(Icons.person, color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. SEARCH BAR
  Widget _buildSearchBar(BuildContext context, HomeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p14),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textMuted,
              size: 22,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: provider.setSearchQuery,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: AppStrings.searchPlumbingPlaceholder,
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: AppSizes.p14),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/service-details');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. HERO PROMO BANNER (Doorstep Plumbing & Sanitary Services)
  Widget _buildHeroPromoBanner(BuildContext context) {
    final slides = const [
      {
        'tag': 'FIRST BOOKING OFFER',
        'title': 'Doorstep Plumbing &\nSanitary Services',
        'desc':
            'Get certified plumbers at your doorstep. Fully insured & hassle-free.',
        'image': 'assets/images/banner/hero_woman.png',
      },
      {
        'tag': 'UP TO 40% OFF',
        'title': 'Express Leak Repair\n& Pipe Fittings',
        'desc':
            'Instant 45-min arrival with high-pressure leak check & warranty.',
        'image':
            'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=500&q=80',
      },
      {
        'tag': 'JSMU ASSURED',
        'title': 'Complete Bathroom\n& Sanitary Overhaul',
        'desc':
            'Premium genuine brand fixtures with 2-year warranty & guarantee.',
        'image':
            'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80',
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _heroPageController,
            itemCount: slides.length,
            onPageChanged: (idx) {
              setState(() {
                _currentHeroIndex = idx;
              });
            },
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  top: 0,
                  right: 8,
                  bottom: 0,
                  left: 0,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFA2432B), Color(0xFF862D17)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF862D17).withValues(alpha: 0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Right image with prominent rounded top-left corner arch
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(95),
                          bottomRight: Radius.circular(28),
                        ),
                        child: SizedBox(
                          width: 155,
                          height: 148,
                          child: slide['image']!.startsWith('assets/')
                              ? Image.asset(
                                  slide['image']!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  errorBuilder: (c, e, s) => CachedNetworkImage(
                                    imageUrl:
                                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=500&q=80',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: slide['image']!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  placeholder: (c, u) => Container(
                                    color: const Color(
                                      0xFF862D17,
                                    ).withValues(alpha: 0.3),
                                  ),
                                  errorWidget: (c, u, e) => const SizedBox(),
                                ),
                        ),
                      ),
                    ),
                    // Left Text & Actions
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tag Badge with Sparkle Icon
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 11,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  slide['tag']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Heading
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.52,
                            child: Text(
                              slide['title']!,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18.5,
                                height: 1.18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Subtitle
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.48,
                            child: Text(
                              slide['desc']!,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontSize: 10.5,
                                height: 1.32,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          // Book Now Button with Translucent Pill and White Arrow Circle
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/service-details',
                            ),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 5, 5, 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.20),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Book Now',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Color(0xFF862D17),
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator Dots matching screenshot
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (idx) {
            final isActive = _currentHeroIndex == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 5,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF862D17)
                    : const Color(0xFFE4DAD2),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 4. TRUST BADGES ROW (45 Mins, Verified Techs, 30-Day Warranty)
  Widget _buildTrustBadgesRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSingleTrustBadge(
            icon: Icons.timer_outlined,
            title: '45 Mins Arrival',
          ),
        ),
        const SizedBox(width: AppSizes.p8),
        Expanded(
          child: _buildSingleTrustBadge(
            icon: Icons.verified_user_outlined,
            title: 'Verified Technicians',
          ),
        ),
        const SizedBox(width: AppSizes.p8),
        Expanded(
          child: _buildSingleTrustBadge(
            icon: Icons.verified_outlined,
            title: '30-Day Warranty',
          ),
        ),
      ],
    );
  }

  Widget _buildSingleTrustBadge({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.p10,
        horizontal: AppSizes.p6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: AppSizes.p6),
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 5. EXPLORE SERVICE CATEGORIES (8 Categories in 4x2 Grid with 3D Icons)
  Widget _buildCategoriesSection(BuildContext context, HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.exploreServiceCategories,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.tapToScheduleExperts,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/service-details'),
              child: Row(
                children: [
                  Text(
                    AppStrings.viewAll,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final cat = provider.categories[index];
            return _buildCategoryCard(context, cat);
          },
        ),
      ],
    );
  }

  void _showCategoryPackagesPopup(BuildContext context, ServiceCategory cat) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => CategoryPackagesPopup(category: cat),
    );
  }

  Widget _buildCategoryCard(BuildContext context, ServiceCategory cat) {
    return GestureDetector(
      onTap: () => _showCategoryPackagesPopup(context, cat),
      child: Column(
        children: [
          // Outer warm light-cream container with subtle border
          AspectRatio(
            aspectRatio: 1.15,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFCF2EB),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFF1E6DC), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                // Inner pure white squircle with gentle shadow
                child: Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _buildCategoryIconWidget(cat),
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          // Category Title (two lines, centered, bold charcoal)
          Text(
            cat.name,
            style: AppTextStyles.labelSmall.copyWith(
              color: const Color(0xFF1E1E1E),
              fontWeight: FontWeight.w700,
              fontSize: 10.5.sp,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIconWidget(ServiceCategory cat) {
    // 1. Resolve local generated 3D asset image
    String? localAsset = cat.assetPath;
    if (localAsset == null || localAsset.isEmpty) {
      final k = cat.iconKey.toLowerCase();
      final name = cat.name.toLowerCase();
      if (k.contains('sanitary') || name.contains('sanitary')) {
        localAsset = 'assets/images/categories/cat_sanitary_ware.jpg';
      } else if (k.contains('hardware') || name.contains('hardware')) {
        localAsset = 'assets/images/categories/cat_plumbing_hardware.jpg';
      } else if (k.contains('cp') || name.contains('cp')) {
        localAsset = 'assets/images/categories/cat_cp_fittings.jpg';
      } else if (k.contains('pvc') || name.contains('pvc')) {
        localAsset = 'assets/images/categories/cat_pvc_fittings.jpg';
      } else if (k.contains('tool') || name.contains('tool')) {
        localAsset = 'assets/images/categories/cat_plumbing_tools.jpg';
      } else if (k.contains('bath') || name.contains('bathroom')) {
        localAsset = 'assets/images/categories/cat_bathroom_accessories.jpg';
      } else if (k.contains('kitchen') || name.contains('kitchen')) {
        localAsset = 'assets/images/categories/cat_kitchen_fittings.jpg';
      } else if (k.contains('other') || name.contains('other')) {
        localAsset = 'assets/images/categories/cat_other_products.jpg';
      }
    }

    if (localAsset != null) {
      return Image.asset(
        localAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (cat.imageUrl != null && cat.imageUrl!.isNotEmpty) {
            return CachedNetworkImage(
              imageUrl: cat.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (c, u) => _buildFallbackCategoryIcon(cat.iconKey),
              errorWidget: (c, u, e) => _buildFallbackCategoryIcon(cat.iconKey),
            );
          }
          return _buildFallbackCategoryIcon(cat.iconKey);
        },
      );
    }

    if (cat.imageUrl != null && cat.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: cat.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (c, u) => _buildFallbackCategoryIcon(cat.iconKey),
        errorWidget: (c, u, e) => _buildFallbackCategoryIcon(cat.iconKey),
      );
    }
    return _buildFallbackCategoryIcon(cat.iconKey);
  }

  Widget _buildFallbackCategoryIcon(String key) {
    final k = key.toLowerCase();
    IconData icon;
    Color accentColor;

    if (k.contains('sanitary')) {
      icon = Icons.water_drop_rounded;
      accentColor = const Color(0xFF26A69A);
    } else if (k.contains('hardware')) {
      icon = Icons.speed_rounded;
      accentColor = const Color(0xFFD48806);
    } else if (k.contains('cp') || k.contains('fitting')) {
      icon = Icons.shower_rounded;
      accentColor = const Color(0xFF0288D1);
    } else if (k.contains('pvc')) {
      icon = Icons.alt_route_rounded;
      accentColor = const Color(0xFFE53935);
    } else if (k.contains('tool')) {
      icon = Icons.home_repair_service_rounded;
      accentColor = const Color(0xFF1E88E5);
    } else if (k.contains('bath')) {
      icon = Icons.dry_cleaning_rounded;
      accentColor = const Color(0xFF8D6E63);
    } else if (k.contains('kitchen')) {
      icon = Icons.kitchen_rounded;
      accentColor = const Color(0xFF5E35B1);
    } else {
      icon = Icons.propane_tank_rounded;
      accentColor = const Color(0xFF3949AB);
    }

    return Container(
      color: accentColor.withValues(alpha: 0.08),
      child: Center(child: Icon(icon, color: accentColor, size: 26)),
    );
  }

  // 6. QUICK FILTER CHIPS (Inside full-width rust banner as in Image 1)
  Widget _buildQuickFilterChips(BuildContext context, HomeProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(color: Color(0xFF80220B)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Row(
          children: MockData.quickFilters.map((filter) {
            final isSelected = provider.selectedQuickFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => provider.setSelectedQuickFilter(filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF80220B)
                          : const Color(0xFF2E2824),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 7. MOST BOOKED SERVICES (2x2 Grid with Book Buttons)
  Widget _buildMostBookedServicesSection(
    BuildContext context,
    HomeProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.mostBookedServices,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.mostBookedSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/service-details'),
              child: Row(
                children: [
                  Text(
                    AppStrings.seeAll,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        // Filter pills for most booked services matching reference
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: MockData.bookedServiceTabs.map((tab) {
              final isSelected = provider.selectedBookedFilter == tab;
              return Padding(
                padding: const EdgeInsets.only(right: AppSizes.p8),
                child: GestureDetector(
                  onTap: () => provider.setSelectedBookedFilter(tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                      vertical: AppSizes.p8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF822711)
                          : const Color(0xFFF1EAE4),
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                    child: Text(
                      tab,
                      style: AppTextStyles.labelSmall.copyWith(
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
        const SizedBox(height: AppSizes.p14),
        // 2x2 Grid of Service Cards matching Image perfectly
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.mostBookedServices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.635,
          ),
          itemBuilder: (context, index) {
            final service = MockData.mostBookedServices[index];
            return _buildBookedServiceCard(context, service);
          },
        ),
      ],
    );
  }

  Widget _buildBookedServiceCard(
    BuildContext context,
    Map<String, dynamic> service,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
            height: 158.h,
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
                // Time Badge (#FFDAD3 background as requested)
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
            style: TextStyle(
              color: Color(0xFF9E2A0E),
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            service['title'] as String,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.5.sp,
              color: Color(0xFF1A1A1A),
              height: 1.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            service['subtitle'] as String,
            style: TextStyle(
              fontSize: 11.sp,
              color: Color(0xFF757575),
              height: 1.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0EBE6)),
          SizedBox(height: 6.h),
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
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.sp,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          Formatters.formatCurrency(
                            service['originalPrice'] as int,
                          ),
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 10.sp,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      service['rateType'] as String,
                      style: TextStyle(
                        color: Color(0xFF0F7B42),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF822711),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '+  Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 8. PROMOTIONAL BANNER (Edge-to-Edge Banner matching user screenshot)
  Widget _buildPromotionalBannersSection(BuildContext context) {
    final banners = const [
      {
        'image': 'assets/images/banner/home_bn1.png',
        'category': 'PVC Fittings & Pipes',
      },
      {'image': 'assets/images/banner/home_bn2.png', 'category': 'CP Fittings'},
    ];

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 412 / 237,
        child: PageView.builder(
          controller: _bannerPageController,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (ctx) =>
                      CategoryPackagesPopup(categoryName: banner['category']!),
                );
              },
              child: Image.asset(
                banner['image']!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: const Color(0xFFF9F4EE),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 9. HANDPICKED FOR YOU (Carousel)
  Widget _buildHandpickedSection(BuildContext context, HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOP BOOKED',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFFC44828),
                    letterSpacing: 0.6,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  AppStrings.handpickedForYou,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_handpickedScrollController.hasClients) {
                      _handpickedScrollController.animateTo(
                        _handpickedScrollController.offset - 220,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.p6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p6),
                GestureDetector(
                  onTap: () {
                    if (_handpickedScrollController.hasClients) {
                      _handpickedScrollController.animateTo(
                        _handpickedScrollController.offset + 220,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.p6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p14),
        SizedBox(
          height: 230,
          child: ListView.separated(
            controller: _handpickedScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: provider.popularServices.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.p12),
            itemBuilder: (context, index) {
              final service = provider.popularServices[index];
              return Container(
                width: 215,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 115,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: service.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (c, u) =>
                                Container(color: AppColors.surfaceCard),
                            errorWidget: (c, u, e) =>
                                Container(color: AppColors.surfaceMuted),
                          ),
                        ),
                        Positioned(
                          top: AppSizes.p8,
                          left: AppSizes.p8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusPill,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.starGold,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${service.rating}',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: AppSizes.p8,
                          right: AppSizes.p8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusPill,
                              ),
                            ),
                            child: Text(
                              service.duration,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.p10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSizes.p10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Starting at',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      fontSize: 9,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatCurrency(
                                      service.startingPrice,
                                    ),
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/service-details',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.p14,
                                    vertical: AppSizes.p6,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusPill,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Book',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 10. THE JSMU SERVICE GUARANTEE CARD
  Widget _buildGuaranteeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: const Color(0xFF7A1E0B),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded, color: Colors.white, size: 18),
              const SizedBox(width: AppSizes.p8),
              Text(
                AppStrings.serviceGuaranteeTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          const Divider(height: 1, color: Colors.white24),
          const SizedBox(height: AppSizes.p14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGuaranteeFeatureItem(
                icon: Icons.engineering_outlined,
                title: '100% Verified\nPlumbers',
              ),
              Container(width: 1, height: 36, color: Colors.white24),
              _buildGuaranteeFeatureItem(
                icon: Icons.receipt_long_outlined,
                title: 'Standard & Best\nRate Card',
              ),
              Container(width: 1, height: 36, color: Colors.white24),
              _buildGuaranteeFeatureItem(
                icon: Icons.cleaning_services_outlined,
                title: 'No Mess\nGuarantee',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeFeatureItem({
    required IconData icon,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF7A1E0B), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 11. CUSTOMER TESTIMONIAL / SOCIAL PROOF CARD
  Widget _buildCustomerReviewCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3EC),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: const Color(0xFFEFE4DA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC44828),
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                    child: Text(
                      '4K REVIEWS',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p8),
                  Text(
                    'Trusted by 50,000+ Homes',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.starGold,
                    size: 16,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '4.9 / 5',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
                  fit: BoxFit.cover,
                  placeholder: (c, u) =>
                      Container(color: AppColors.surfaceCard),
                  errorWidget: (c, u, e) => const Icon(Icons.person),
                ),
              ),
              const SizedBox(width: AppSizes.p10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Priya Sharma',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Yesterday',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '"The cleaner arrived on time, was extremely polite, and left my kitchen sparkling. Truly 1-stop service!"',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 12. CP FITTINGS INSTALLATION & REPAIR PROMOTIONAL BANNER
  Widget _buildCpFittingsBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4EE),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: const Color(0xFFF0E5DC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CP Fittings\nInstallation & Repair',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    height: 1.2,
                    color: const Color(0xFF332018),
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.52,
                  child: Text(
                    'Premium fittings for lasting performance. Style meets functionality.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.p12),
                Row(
                  children: [
                    _buildPillFeature('Faucets'),
                    const SizedBox(width: 4),
                    _buildPillFeature('Showers'),
                    const SizedBox(width: 4),
                    _buildPillFeature('Health Faucets'),
                    const SizedBox(width: 4),
                    _buildPillFeature('Accessories'),
                  ],
                ),
                const SizedBox(height: AppSizes.p14),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/service-details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BUY/SERVICES',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: SizedBox(
              width: 140,
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=400&q=80',
                fit: BoxFit.cover,
                placeholder: (c, u) => const SizedBox(),
                errorWidget: (c, u, e) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillFeature(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(color: const Color(0xFFEADBCE)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: const Color(0xFF8D5340),
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // 13. POPULAR SERVICES CATALOG (With + ADD Buttons)
  Widget _buildPopularServicesCatalog(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.popularServicesTitle,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.p12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.popularProducts.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.p10),
          itemBuilder: (context, index) {
            final prod = MockData.popularProducts[index];
            return _buildPopularProductCard(context, prod);
          },
        ),
      ],
    );
  }

  Widget _buildPopularProductCard(
    BuildContext context,
    Map<String, dynamic> prod,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image with Badge
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  color: AppColors.surfaceCard,
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: prod['imageUrl'] as String,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => const SizedBox(),
                  errorWidget: (c, u, e) =>
                      const Icon(Icons.inventory_2_outlined),
                ),
              ),
              Positioned(
                top: 3,
                left: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                  ),
                  child: Text(
                    prod['badge'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.p12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prod['categoryTag'] as String,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  prod['title'] as String,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      Formatters.formatCurrency(prod['price'] as int),
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (prod['originalPrice'] != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        Formatters.formatCurrency(prod['originalPrice'] as int),
                        style: AppTextStyles.bodySmall.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    if (prod['unit'] != null) ...[
                      const SizedBox(width: 2),
                      Text(
                        prod['unit'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.verified_outlined,
                      size: 11,
                      color: AppColors.onlineGreen,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      prod['warrantyNote'] as String,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onlineGreen,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // + ADD Button (Peach background, rust text)
          ElevatedButton(
            onPressed: () {
              AppSnackbar.showSuccess(
                context,
                'Added ${prod['title']} to cart',
              );
              Navigator.pushNamed(context, '/service-details');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFBE4DC),
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            ),
            child: Text(
              '+ ADD',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 14. BOTTOM NAVIGATION BAR (Exact match to reference image)
  Widget _buildBottomNavigationBar(
    BuildContext context,
    HomeProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF0EBE6), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: provider.activeNavIndex == 0,
              onTap: () => provider.setActiveNavIndex(0),
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.construction_outlined,
              label: 'Services',
              isActive: provider.activeNavIndex == 1,
              onTap: () => provider.setActiveNavIndex(1),
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.calendar_today_outlined,
              label: 'Bookings',
              badgeCount: '1',
              isActive: provider.activeNavIndex == 2,
              onTap: () => provider.setActiveNavIndex(2),
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.shopping_bag_outlined,
              label: 'Cart',
              isActive: provider.activeNavIndex == 3,
              onTap: () => provider.setActiveNavIndex(3),
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.person_outline_rounded,
              label: 'Account',
              isActive: provider.activeNavIndex == 4,
              onTap: () => provider.setActiveNavIndex(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    String? badgeCount,
  }) {
    const activeColor = Color(0xFF822711);
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
            style: TextStyle(
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

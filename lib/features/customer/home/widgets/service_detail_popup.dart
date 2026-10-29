import 'package:flutter/material.dart';
import '../../../../app/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';

class ServiceDetailPopup extends StatefulWidget {
  final Map<String, dynamic> package;

  const ServiceDetailPopup({super.key, required this.package});

  @override
  State<ServiceDetailPopup> createState() => _ServiceDetailPopupState();
}

class _ServiceDetailPopupState extends State<ServiceDetailPopup> {
  // Selected sub-services (default includes the first sub-service)
  final Set<String> _selectedServices = {'sub-1'};
  final Set<String> _selectedSpares = {};
  int _faqExpandedIndex = 0;

  // Sub-services list
  final List<Map<String, dynamic>> _subServices = const [
    {
      'id': 'sub-1',
      'title': 'Brass Gate Valve Installation / Replacement',
      'rating': '4.9',
      'reviews': '5.1k',
      'duration': '35 mins',
      'price': 499,
      'bullets': [
        'Full mainline valve fitment & leak test',
        'Industrial grade PTFE thread sealing',
      ],
      'assetPath': 'assets/images/categories/cat_plumbing_hardware.jpg',
    },
    {
      'id': 'sub-2',
      'title': 'Water Pressure Regulator (PRV) Tuning & Fix',
      'rating': '4.8',
      'reviews': '2.9k',
      'duration': '45 mins',
      'price': 499,
      'bullets': [
        'Pressure gauge diagnostic calibration',
        'Dual brass union joint fitment',
      ],
      'assetPath': 'assets/images/categories/cat_plumbing_tools.jpg',
    },
    {
      'id': 'sub-3',
      'title': 'Non-Return / Check Valve Fitment',
      'rating': '4.9',
      'reviews': '1.8k',
      'duration': '30 mins',
      'price': 349,
      'bullets': [
        'Prevents pump backflow & water hammer',
        'Dual threaded brass coupling',
      ],
      'assetPath': 'assets/images/categories/cat_cp_fittings.jpg',
    },
    {
      'id': 'sub-4',
      'title': 'Overhead Water Tank Ball Valve & Float',
      'rating': '4.7',
      'reviews': '1.3k',
      'duration': '30 mins',
      'price': 299,
      'bullets': [
        'Heavy brass rod arm adjustment',
        'Complete overflow stop test',
      ],
      'assetPath': 'assets/images/categories/cat_bathroom_accessories.jpg',
    },
  ];

  // Genuine Spares
  final List<Map<String, dynamic>> _spares = const [
    {
      'id': 'sp-1',
      'title': '1–Inch Heavy Brass Gate Valve',
      'subtitle': '100% Solid Brass',
      'price': 649,
      'assetPath': 'assets/images/categories/cat_plumbing_hardware.jpg',
    },
    {
      'id': 'sp-2',
      'title': 'Dial Pressure Gauge 0–100 PSI',
      'subtitle': 'Calibrated steel rim',
      'price': 399,
      'assetPath': 'assets/images/categories/cat_plumbing_tools.jpg',
    },
    {
      'id': 'sp-3',
      'title': 'PTFE High Density Teflon Tape',
      'subtitle': '12m industrial roll',
      'price': 49,
      'assetPath': 'assets/images/categories/cat_pvc_fittings.jpg',
    },
  ];

  // Calculate total price
  int get _totalPrice {
    int sum = 0;
    for (final s in _subServices) {
      if (_selectedServices.contains(s['id'])) {
        sum += s['price'] as int;
      }
    }
    for (final sp in _spares) {
      if (_selectedSpares.contains(sp['id'])) {
        sum += sp['price'] as int;
      }
    }
    return sum == 0 ? 499 : sum;
  }

  int get _selectedCount => _selectedServices.length + _selectedSpares.length;

  @override
  Widget build(BuildContext context) {
    final title =
        widget.package['title'] as String? ??
        'Mainline Valve & Water Pressure Control';
    final assetPath =
        widget.package['assetPath'] as String? ??
        'assets/images/categories/cat_plumbing_hardware.jpg';

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Close Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3ECE6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF5A4F48),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // 1. Hero Product Card
                    _buildHeroCard(title, assetPath),

                    const SizedBox(height: 14),

                    // 2. The UC Guarantee Luxe Banner
                    _buildGuaranteeBanner(),

                    const SizedBox(height: 18),

                    // 3. Select Services Section
                    _buildSelectServicesSection(),

                    const SizedBox(height: 18),

                    // 4. Genuine Spares & Fittings Section
                    _buildSparesSection(),

                    const SizedBox(height: 18),

                    // 5. Inclusions & Exclusions Card
                    _buildInclusionsExclusionsCard(),

                    const SizedBox(height: 18),

                    // 6. How It Works Section
                    _buildHowItWorksSection(),

                    const SizedBox(height: 18),

                    // 7. Customer Reviews Section
                    _buildCustomerReviewsSection(),

                    const SizedBox(height: 18),

                    // 8. Frequently Asked Questions
                    _buildFaqSection(),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar: "1 service • ₹499" and "Proceed to Schedule →"
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  // 1. Hero Product Card
  Widget _buildHeroCard(String title, String assetPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EAE4), width: 1.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3D Image Showcase Container
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    assetPath,
                    height: 145,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.plumbing_rounded,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                // Top-left: UC Verified Pro
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2724),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Color(0xFFE5A93C),
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'UC Verified Pro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top-middle: 45-Min Arrival
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFFD97706),
                          size: 13,
                        ),
                        SizedBox(width: 3),
                        Text(
                          '45-Min Arrival',
                          style: TextStyle(
                            color: Color(0xFFB45309),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom-right over image: 30-Day Guarantee
                Positioned(
                  bottom: 8,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7F0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFB7E4D3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Color(0xFF0F764F),
                          size: 12,
                        ),
                        SizedBox(width: 3),
                        Text(
                          '30-Day Guarantee',
                          style: TextStyle(
                            color: Color(0xFF0F764F),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B18),
              height: 1.2,
            ),
          ),

          const SizedBox(height: 6),

          // Rating Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.white, size: 12),
                    SizedBox(width: 2),
                    Text(
                      '4.88',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '14.2K reviews',
                style: TextStyle(
                  color: Color(0xFF7C736C),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // UC Promise • Fixed Upfront
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF1EC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFF7D8CE)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 13,
                  color: Color(0xFF822711),
                ),
                SizedBox(width: 4),
                Text(
                  'UC Promise • Fixed Upfront',
                  style: TextStyle(
                    color: Color(0xFF822711),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Price Row
          Row(
            children: [
              const Text(
                '₹499',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B18),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '₹699',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 13,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '28% OFF',
                  style: TextStyle(
                    color: Color(0xFF168B56),
                    fontWeight: FontWeight.w800,
                    fontSize: 10.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Color(0xFF7C736C),
              ),
              const SizedBox(width: 3),
              const Text(
                '45 mins',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF7C736C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 3 Feature Badges Row
          Row(
            children: [
              _buildFeatureChip(Icons.shield_outlined, '30 Days\nWarranty'),
              const SizedBox(width: 6),
              _buildFeatureChip(Icons.timer_outlined, 'On-time\nArrival'),
              const SizedBox(width: 6),
              _buildFeatureChip(
                Icons.cleaning_services_outlined,
                'Mess-free\nClean',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF0EAE4)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF822711)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A423D),
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. The UC Guarantee Luxe Banner
  Widget _buildGuaranteeBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF731E0C),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF731E0C).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'The UC Guarantee',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              const Text(
                'Urban Company Luxe',
                style: TextStyle(
                  color: Color(0xFFD6A59A),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: const Color(0xFF8F3824).withValues(alpha: 0.8),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildGuaranteeCol(
                Icons.star_border_rounded,
                '4.8+ Plumbers',
                'Background verified',
              ),
              Container(
                width: 1,
                height: 46,
                color: const Color(0xFF8F3824).withValues(alpha: 0.8),
              ),
              _buildGuaranteeCol(
                Icons.price_check_rounded,
                'Standard Rates',
                'Zero hidden charge',
              ),
              Container(
                width: 1,
                height: 46,
                color: const Color(0xFF8F3824).withValues(alpha: 0.8),
              ),
              _buildGuaranteeCol(
                Icons.published_with_changes_rounded,
                'Free Rework',
                '30–day warranty',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeCol(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFD6A59A),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 3. Select Services Section (4 services available)
  Widget _buildSelectServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Services',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B18),
              ),
            ),
            Text(
              '${_subServices.length} services available',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8A8077),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._subServices.map((sub) {
          final id = sub['id'] as String;
          final isSelected = _selectedServices.contains(id);
          return _buildSubServiceCard(sub, isSelected);
        }),
      ],
    );
  }

  Widget _buildSubServiceCard(Map<String, dynamic> sub, bool isSelected) {
    final id = sub['id'] as String;
    final bullets = sub['bullets'] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? const Color(0xFF822711) : const Color(0xFFF0EAE4),
          width: isSelected ? 1.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF822711).withValues(alpha: 0.08),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: Color(0xFF1E1B18),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${sub['rating']} (${sub['reviews']}) • ⏱ ${sub['duration']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C736C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${sub['price']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B18),
                  ),
                ),
                const SizedBox(height: 6),
                ...bullets.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Color(0xFF822711),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6E6761),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'View details >',
                  style: TextStyle(
                    color: Color(0xFF822711),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Right Thumbnail & ADD Button
          Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF8F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEFE8E1)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  sub['assetPath'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.plumbing_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedServices.length > 1) {
                        _selectedServices.remove(id);
                      }
                    } else {
                      _selectedServices.add(id);
                      AppSnackbar.showSuccess(
                        context,
                        'Added ${sub['title']} to package',
                      );
                    }
                  });
                },
                child: Container(
                  width: 72,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF822711) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF822711)),
                  ),
                  child: Text(
                    isSelected ? 'ADDED ✓' : 'ADD',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF822711),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Genuine Spares & Fittings Section
  Widget _buildSparesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Genuine Spares & Fittings',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B18),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF6EAE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'UC Assured',
                style: TextStyle(
                  color: Color(0xFF7A2210),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          'Add 100% genuine parts to your booking',
          style: TextStyle(fontSize: 12, color: Color(0xFF7C736C)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _spares.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final sp = _spares[index];
              final id = sp['id'] as String;
              final isAdded = _selectedSpares.contains(id);

              return Container(
                width: 172,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFEDE5DE),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Image container
                    Container(
                      height: 96,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF7F3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF2ECE6)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            sp['assetPath'] as String,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Title
                    Text(
                      sp['title'] as String,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B18),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subtitle
                    Text(
                      sp['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C736C),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Divider
                    Container(height: 1, color: const Color(0xFFF3ECE6)),
                    const SizedBox(height: 8),
                    // Price & Squircle + Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${sp['price']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.5,
                            color: Color(0xFF1E1B18),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isAdded) {
                                _selectedSpares.remove(id);
                              } else {
                                _selectedSpares.add(id);
                              }
                            });
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isAdded
                                  ? const Color(0xFF822711)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF822711),
                                width: 1.3,
                              ),
                            ),
                            child: Icon(
                              isAdded ? Icons.check_rounded : Icons.add_rounded,
                              size: 18,
                              color: isAdded
                                  ? Colors.white
                                  : const Color(0xFF822711),
                            ),
                          ),
                        ),
                      ],
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

  // 5. Inclusions & Exclusions
  Widget _buildInclusionsExclusionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inclusions & Exclusions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B18),
            ),
          ),
          const SizedBox(height: 10),
          // WHAT'S INCLUDED
          const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF168B56),
                size: 15,
              ),
              SizedBox(width: 6),
              Text(
                "WHAT'S INCLUDED",
                style: TextStyle(
                  color: Color(0xFF168B56),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildBullet('Complete safety inspection of main line'),
          _buildBullet('Industrial grade Teflon seal tape fitment component'),
          _buildBullet('Post-installation pressure check & flow'),
          _buildBullet('Complete cleanup and drying of the work area'),

          const SizedBox(height: 10),

          // WHAT'S EXCLUDED
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFD32F2F),
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "WHAT'S EXCLUDED",
                      style: TextStyle(
                        color: Color(0xFFD32F2F),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildExcludedBullet(
                  'Major wall masonry breaking unless leak masking',
                ),
                _buildExcludedBullet(
                  'Cost of new brass valves or spare parts (add from spares above or supply your own)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Color(0xFF168B56), fontSize: 12),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: Color(0xFF5A524D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExcludedBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Color(0xFFD32F2F), fontSize: 11),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF6E5652)),
            ),
          ),
        ],
      ),
    );
  }

  // 6. How It Works
  Widget _buildHowItWorksSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How It Works',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B18),
            ),
          ),
          const SizedBox(height: 12),
          _buildWorkStep(
            '1',
            'Select service & book a convenient slot',
            'Pick your required plumbing packages and select an arrival time window that suits your schedule.',
          ),
          _buildWorkStep(
            '2',
            'Verified plumber arrives with professional toolkit',
            'Equipped with calibrated pressure gauges, pipe wrenches, and sanitary sealants.',
          ),
          _buildWorkStep(
            '3',
            'Installation & pressure testing, pay after satisfaction',
            '6-step safety check + cleaning, payment via UPI or Cash, covered under 30-day warranty.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkStep(
    String num,
    String title,
    String desc, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1B18),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  num,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(width: 1.5, height: 40, color: const Color(0xFFE5DDD5)),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color(0xFF1E1B18),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF7C736C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 7. Customer Reviews Section
  Widget _buildCustomerReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B18),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                  SizedBox(width: 2),
                  Text(
                    '4.8 / 5',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'Based on 14,211 verified bookings',
          style: TextStyle(fontSize: 11, color: Color(0xFF7C736C)),
        ),
        const SizedBox(height: 10),
        _buildReviewCard(
          'RV',
          'Rajesh Verma',
          'Verified Urban Company Customer • 3 days ago',
          '"The plumber reached within 15 mins. Replaced the valve and tested under heavy water flow. Clean and speedy work on 2nd floor. Completely mess-free."',
        ),
        const SizedBox(height: 8),
        _buildReviewCard(
          'AS',
          'Ananya Sen',
          'Verified Urban Company Customer • 1 week ago',
          '"Fixed our overhead water tank float in 20 mins. Very polite and efficient. Also gave a clear standard bill."',
        ),
      ],
    );
  }

  Widget _buildReviewCard(
    String initials,
    String name,
    String tag,
    String comment,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFF6ECE6),
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF822711),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xFF1E1B18),
                      ),
                    ),
                    Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF8A8077),
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                  Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                  Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                  Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                  Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5A524D),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // 8. Frequently Asked Questions
  Widget _buildFaqSection() {
    final faqs = [
      {
        'q': 'Will the plumber bring tools and sealant?',
        'a':
            'Yes, every verified plumber arrives fully equipped with standard diagnostic tools, pipe wrenches, pressure gauges, and high-density PTFE Teflon seal tape.',
      },
      {
        'q': 'What if the leak starts again after 7 days?',
        'a':
            'Every service is covered under a 30-day rework warranty. If any leak or issue persists, a technician will re-visit and fix it at zero extra charge.',
      },
      {
        'q': 'Can I provide my own brass valve?',
        'a':
            'Yes! You can either supply your own brand of brass valve or purchase 100% genuine parts directly from the spares section above.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B18),
            ),
          ),
          const SizedBox(height: 8),
          ...faqs.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isExpanded = _faqExpandedIndex == idx;

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _faqExpandedIndex = isExpanded ? -1 : idx;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['q']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                              color: Color(0xFF1E1B18),
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: const Color(0xFF7C736C),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      item['a']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6E6761),
                        height: 1.3,
                      ),
                    ),
                  ),
                if (idx < faqs.length - 1)
                  const Divider(color: Color(0xFFF0EAE4), height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Bottom Sticky Bar: "1 service • ₹499" and "Proceed to Schedule →"
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left Price & Bill details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_selectedCount service${_selectedCount > 1 ? 's' : ''} • ₹$_totalPrice',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B18),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'View bill details',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF822711),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Right: Proceed to Schedule button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close popup
                Navigator.pushNamed(context, AppRoutes.checkout);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF822711),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Proceed to Schedule',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

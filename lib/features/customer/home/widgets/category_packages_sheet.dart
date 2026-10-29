import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/mock_data.dart';
import '../../../../core/utils/formatters.dart';
import '../models/service_category.dart';
import 'service_detail_popup.dart';

/// CategoryPackagesPopup:
/// Step 1: Shows Sub-Categories Grid Dialog matching the reference image.
/// Step 2: On tapping any sub-category, opens a Bottom Sheet listing its tailored services.
/// Step 3: On selecting a service from that Bottom Sheet, launches ServiceDetailPopup.
class CategoryPackagesPopup extends StatefulWidget {
  final ServiceCategory? category;
  final String? categoryName;

  const CategoryPackagesPopup({super.key, this.category, this.categoryName});

  @override
  State<CategoryPackagesPopup> createState() => _CategoryPackagesPopupState();
}

// Backward-compatible alias
typedef CategoryPackagesSheet = CategoryPackagesPopup;

class _CategoryPackagesPopupState extends State<CategoryPackagesPopup> {
  // 11 Subcategories matching the exact reference image
  final List<Map<String, dynamic>> _subCategories = const [
    {
      'id': 'sub-bath-acc',
      'name': 'BATHROOM\nACCESSORIES',
      'fullName': 'BATHROOM ACCESSORIES',
      'asset': 'assets/images/subcategories/subcat_bath_acc.png',
      'services': [
        {
          'id': 'ba-1',
          'title': 'Towel Rod & Shelf Installation',
          'category': 'BATHROOM ACCESSORIES',
          'duration': '25 mins',
          'rating': 4.8,
          'reviewsCount': '920',
          'subtitle': 'Concealed screw wall mount fitment',
          'price': 199,
          'originalPrice': 299,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'ba-2',
          'title': 'Mirror Cabinet & Vanity Fitment',
          'category': 'BATHROOM ACCESSORIES',
          'duration': '40 mins',
          'rating': 4.9,
          'reviewsCount': '1.1k',
          'subtitle': 'Heavy-duty anchor bolt alignment',
          'price': 349,
          'originalPrice': 499,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'ba-3',
          'title': 'Soap Dispenser & Glass Holder',
          'category': 'BATHROOM ACCESSORIES',
          'duration': '20 mins',
          'rating': 4.7,
          'reviewsCount': '640',
          'subtitle': 'Tile-safe precision drilling setup',
          'price': 149,
          'originalPrice': 249,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'ba-4',
          'title': 'Shower Curtain Rod & Hook Fix',
          'category': 'BATHROOM ACCESSORIES',
          'duration': '20 mins',
          'rating': 4.8,
          'reviewsCount': '480',
          'subtitle': 'Tension & spring-loaded rod setup',
          'price': 179,
          'originalPrice': 249,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-complete-plumbing',
      'name': 'COMPLETE\nPLUMING...',
      'fullName': 'COMPLETE PLUMBING WORK',
      'asset': 'assets/images/subcategories/subcat_complete_plumbing.png',
      'services': [
        {
          'id': 'cpw-1',
          'title': 'Full Home Plumbing Health Check',
          'category': 'COMPLETE PLUMBING',
          'duration': '45 mins',
          'rating': 4.9,
          'reviewsCount': '2.1k',
          'subtitle': 'Full house audit & pressure test',
          'price': 299,
          'originalPrice': 449,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'cpw-2',
          'title': 'Bathroom Complete Re-Piping',
          'category': 'COMPLETE PLUMBING',
          'duration': '180 mins',
          'rating': 4.9,
          'reviewsCount': '850',
          'subtitle': 'Concealed CPVC hot & cold lines',
          'price': 1499,
          'originalPrice': 1999,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'cpw-3',
          'title': 'Main Overhead Inflow Line Fix',
          'category': 'COMPLETE PLUMBING',
          'duration': '60 mins',
          'rating': 4.8,
          'reviewsCount': '690',
          'subtitle': 'Brass gate valve & bypass union',
          'price': 499,
          'originalPrice': 699,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-cp-fitting',
      'name': 'CP FITTING',
      'fullName': 'CP FITTING',
      'asset': 'assets/images/subcategories/subcat_cp_fitting.png',
      'services': [
        {
          'id': 'cpf-1',
          'title': 'Mixer Tap & Leak Fix',
          'category': 'CP FITTING',
          'duration': '35 mins',
          'rating': 4.9,
          'reviewsCount': '1.8k',
          'subtitle': 'Cartridge change & washer seal',
          'price': 299,
          'originalPrice': 399,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'cpf-2',
          'title': 'Bath Shower Diverter Replacement',
          'category': 'CP FITTING',
          'duration': '45 mins',
          'rating': 4.8,
          'reviewsCount': '950',
          'subtitle': 'Concealed body alignment & seal',
          'price': 449,
          'originalPrice': 599,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'cpf-3',
          'title': 'Angle Valve & Braided Hose Fit',
          'category': 'CP FITTING',
          'duration': '20 mins',
          'rating': 4.9,
          'reviewsCount': '1.4k',
          'subtitle': 'High pressure burst-proof hose',
          'price': 199,
          'originalPrice': 299,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-drainage-traps',
      'name': 'Drainage &\nTraps',
      'fullName': 'DRAINAGE & TRAPS',
      'asset': 'assets/images/subcategories/subcat_drainage_traps.png',
      'services': [
        {
          'id': 'dt-1',
          'title': 'Linear Shower Drain Grating Fit',
          'category': 'DRAINAGE & TRAPS',
          'duration': '30 mins',
          'rating': 4.8,
          'reviewsCount': '780',
          'subtitle': 'Stainless steel odour seal setup',
          'price': 299,
          'originalPrice': 399,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'dt-2',
          'title': 'Anti-Cockroach Floor Trap & Seal',
          'category': 'DRAINAGE & TRAPS',
          'duration': '25 mins',
          'rating': 4.9,
          'reviewsCount': '1.3k',
          'subtitle': 'Magnetic auto-closing flap trap',
          'price': 249,
          'originalPrice': 349,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'dt-3',
          'title': 'Kitchen & Bath Drain Unblock',
          'category': 'DRAINAGE & TRAPS',
          'duration': '40 mins',
          'rating': 4.8,
          'reviewsCount': '1.6k',
          'subtitle': 'High-pressure mechanized snake flush',
          'price': 399,
          'originalPrice': 549,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-kitchen-fitting',
      'name': 'KITCHEN\nFIITING',
      'fullName': 'KITCHEN FITTING',
      'asset': 'assets/images/subcategories/subcat_kitchen_fitting.png',
      'services': [
        {
          'id': 'kf-1',
          'title': 'Granite / SS Sink Installation',
          'category': 'KITCHEN FITTING',
          'duration': '60 mins',
          'rating': 4.9,
          'reviewsCount': '890',
          'subtitle': 'Precision under-mount silicone seal',
          'price': 599,
          'originalPrice': 799,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'kf-2',
          'title': 'Kitchen Pull-Out Faucet Fitment',
          'category': 'KITCHEN FITTING',
          'duration': '35 mins',
          'rating': 4.9,
          'reviewsCount': '720',
          'subtitle': '360° swivel dual spray head tap',
          'price': 349,
          'originalPrice': 499,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'kf-3',
          'title': 'Under-Sink RO Filter Connection',
          'category': 'KITCHEN FITTING',
          'duration': '25 mins',
          'rating': 4.8,
          'reviewsCount': '950',
          'subtitle': 'Dual brass T-valve tap diverter',
          'price': 249,
          'originalPrice': 349,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-pipe-fitting',
      'name': 'PIPE AND\nFITTING',
      'fullName': 'PIPE AND FITTING',
      'asset': 'assets/images/subcategories/subcat_pipe_fitting.png',
      'services': [
        {
          'id': 'pf-1',
          'title': 'Pipe Seepage & Joint Repair',
          'category': 'PIPE AND FITTING',
          'duration': '50 mins',
          'rating': 4.7,
          'reviewsCount': '980',
          'subtitle': 'Solvent seal & section replacement',
          'price': 449,
          'originalPrice': 599,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'pf-2',
          'title': 'PVC Waste Pipe & Trap Fitment',
          'category': 'PIPE AND FITTING',
          'duration': '30 mins',
          'rating': 4.8,
          'reviewsCount': '670',
          'subtitle': 'Leak-proof anti-syphon coupling',
          'price': 299,
          'originalPrice': 399,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'pf-3',
          'title': 'Main Inflow Brass Gate Valve',
          'category': 'PIPE AND FITTING',
          'duration': '45 mins',
          'rating': 4.9,
          'reviewsCount': '820',
          'subtitle': 'Full mainline valve replacement',
          'price': 499,
          'originalPrice': 649,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-plumbing-tool',
      'name': 'PLUMBING\nTOOL',
      'fullName': 'PLUMBING TOOL',
      'asset': 'assets/images/subcategories/subcat_plumbing_tool.png',
      'services': [
        {
          'id': 'pt-1',
          'title': 'Plumbing Full House Inspection',
          'category': 'PLUMBING TOOL',
          'duration': '30 mins',
          'rating': 4.9,
          'reviewsCount': '1.5k',
          'subtitle': 'Pressure gauge & acoustic audit',
          'price': 199,
          'originalPrice': 299,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'pt-2',
          'title': 'Thermal Camera Concealed Leak Scan',
          'category': 'PLUMBING TOOL',
          'duration': '40 mins',
          'rating': 4.9,
          'reviewsCount': '920',
          'subtitle': 'Non-destructive thermal scanning',
          'price': 499,
          'originalPrice': 699,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-ptmt-cp',
      'name': 'PTMT CP\nFITTING',
      'fullName': 'PTMT CP FITTING',
      'asset': 'assets/images/subcategories/subcat_ptmt_cp.png',
      'services': [
        {
          'id': 'ptmt-1',
          'title': 'PTMT Engineering Polymer Tap Fit',
          'category': 'PTMT CP FITTING',
          'duration': '20 mins',
          'rating': 4.8,
          'reviewsCount': '840',
          'subtitle': 'Corrosion & hard-water proof tap',
          'price': 179,
          'originalPrice': 249,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'ptmt-2',
          'title': 'PTMT 2-in-1 Bib Cock & Jet Fit',
          'category': 'PTMT CP FITTING',
          'duration': '25 mins',
          'rating': 4.9,
          'reviewsCount': '1.2k',
          'subtitle': 'Dual control knob polymer fitting',
          'price': 249,
          'originalPrice': 349,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-sanitary-ware',
      'name': 'SANATORY\nWARE',
      'fullName': 'SANITARY WARE',
      'asset': 'assets/images/subcategories/subcat_sanitary_ware.png',
      'services': [
        {
          'id': 'sw-1',
          'title': 'Wall Hung Commode Installation',
          'category': 'SANITARY WARE',
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
          'id': 'sw-2',
          'title': 'Flush Tank & Syphon Overhaul',
          'category': 'SANITARY WARE',
          'duration': '35 mins',
          'rating': 4.7,
          'reviewsCount': '1.1k',
          'subtitle': 'Syphon seal & push button repair',
          'price': 349,
          'originalPrice': 449,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'sw-3',
          'title': 'Wash Basin & Waste Coupling Fit',
          'category': 'SANITARY WARE',
          'duration': '45 mins',
          'rating': 4.8,
          'reviewsCount': '750',
          'subtitle': 'Silicone seal & bottle trap setup',
          'price': 399,
          'originalPrice': 549,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-water-tank',
      'name': 'WATAR TANK\nAND...',
      'fullName': 'WATER TANK AND ACC',
      'asset': 'assets/images/subcategories/subcat_water_tank.png',
      'services': [
        {
          'id': 'wt-1',
          'title': 'Water Tank Ball Valve & Float',
          'category': 'WATER TANK',
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
          'id': 'wt-2',
          'title': 'Deep Water Tank Mechanical Clean',
          'category': 'WATER TANK',
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
          'id': 'wt-3',
          'title': 'Tank Overflow & Vent Cap Setup',
          'category': 'WATER TANK',
          'duration': '30 mins',
          'rating': 4.8,
          'reviewsCount': '520',
          'subtitle': 'Mosquito mesh vent & drain pipe',
          'price': 299,
          'originalPrice': 399,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
    {
      'id': 'sub-water-pumps',
      'name': 'Water Pumps &\nAccessories',
      'fullName': 'WATER PUMPS & ACCESSORIES',
      'asset': 'assets/images/subcategories/subcat_water_pumps.png',
      'services': [
        {
          'id': 'wp-1',
          'title': 'Automatic Pump Switch Setup',
          'category': 'WATER PUMPS',
          'duration': '45 mins',
          'rating': 4.8,
          'reviewsCount': '510',
          'subtitle': 'Dry-run sensor & panel installation',
          'price': 599,
          'originalPrice': 799,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'wp-2',
          'title': 'Monoblock Booster Pump Service',
          'category': 'WATER PUMPS',
          'duration': '40 mins',
          'rating': 4.9,
          'reviewsCount': '430',
          'subtitle': 'Impeller check & priming test',
          'price': 499,
          'originalPrice': 649,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?auto=format&fit=crop&w=500&q=80',
        },
        {
          'id': 'wp-3',
          'title': 'Non-Return Check Valve Fitment',
          'category': 'WATER PUMPS',
          'duration': '30 mins',
          'rating': 4.9,
          'reviewsCount': '610',
          'subtitle': 'Prevents pump backflow hammer',
          'price': 349,
          'originalPrice': 499,
          'rateType': 'Standard Rate',
          'imageUrl':
              'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=500&q=80',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String catTitle =
        widget.category?.name ?? widget.categoryName ?? 'Plumbing';
    final String catHeading = catTitle
        .replaceAll('\n', ' ')
        .toUpperCase()
        .trim();

    final double dialogHeight = (MediaQuery.of(context).size.height * 0.76)
        .clamp(520.0, 700.0);

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: dialogHeight,
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. HEADER SECTION (Matches exact uploaded screenshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Delivery Truck / Tool Badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF0EB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFF2DED5),
                        width: 1.2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/subcategories/badge_truck.png',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                        Icons.home_repair_service_rounded,
                        color: Color(0xFF9E381F),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EXPLORE SUB-CATEGORIES',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF9E381F),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          catHeading.isNotEmpty ? catHeading : 'PLUMBING',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1A17),
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${_subCategories.length} sub-categories available',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF706660),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Circular Close Button (X)
                  // GestureDetector(
                  //   onTap: () => Navigator.pop(context),
                  //   child: Container(
                  //     width: 34,
                  //     height: 34,
                  //     decoration: const BoxDecoration(
                  //       color: Color(0xFFF5F2EE),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: const Icon(
                  //       Icons.close_rounded,
                  //       size: 18,
                  //       color: Color(0xFF4A3E39),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF0EAE4)),

            // 2. 3-COLUMN SUB-CATEGORIES GRID (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                physics: const BouncingScrollPhysics(),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 36,
                    mainAxisSpacing: 6,
                    childAspectRatio: 0.84,
                  ),
                  itemBuilder: (context, index) {
                    final item = _subCategories[index];
                    return _buildSubCategoryCard(context, item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sub-Category Card item (matching home_screen.dart:L824 design)
  Widget _buildSubCategoryCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final assetPath = item['asset'] as String;
    final name = item['name'] as String;

    return GestureDetector(
      onTap: () => _openSubCategoryServicesSheet(context, item),
      child: Column(
        children: [
          // Outer warm light-cream container with subtle border
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFCF2EB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1E6DC), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                // Inner pure white squircle with gentle shadow
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Center(
                        child: Icon(
                          Icons.handyman_rounded,
                          color: Color(0xFF9E381F),
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Category Title (two lines, centered, bold charcoal)
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
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

  // Step 2, 3 & 4: Sub-Categories Dialog -> Bottom Sheet -> ServicesFittingPackagesPopup -> ServiceDetailPopup
  void _openSubCategoryServicesSheet(
    BuildContext context,
    Map<String, dynamic> subCat,
  ) {
    final rootNav = Navigator.of(context, rootNavigator: true);
    final navContext = rootNav.context;

    // Close the subcategories dialog first
    rootNav.pop();

    // Open bottom sheet cleanly using root navigator context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: navContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetCtx) => _SubCategoryServicesBottomSheet(
          subCategory: subCat,
          onSelectService: (service) {
            // Close the bottom sheet first
            Navigator.of(sheetCtx).pop();

            // Open the "Services & Fitting Packages" popup (matching user screenshot)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: navContext,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.65),
                builder: (fittingCtx) => ServicesFittingPackagesPopup(
                  categoryName:
                      subCat['fullName'] as String? ??
                      subCat['name'] as String?,
                  serviceItem: service,
                  onSelectPackage: (pkg) {
                    // Close the fitting packages popup
                    Navigator.of(fittingCtx).pop();

                    // Open ServiceDetailPopup immediately on parent navigator!
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: navContext,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.65),
                        builder: (ctx) => ServiceDetailPopup(
                          package: {
                            'title': pkg['title'],
                            'subtitle': pkg['subtitle'],
                            'price': pkg['price'],
                            'pricePrefix': pkg['pricePrefix'],
                            'priceUnit': pkg['priceUnit'],
                            'assetPath': pkg['assetPath'],
                            'category': pkg['category'] ?? service['category'],
                            'originalPrice':
                                service['originalPrice'] ??
                                ((pkg['price'] as int) + 150),
                            'rating': service['rating'] ?? 4.9,
                            'reviewsCount': service['reviewsCount'] ?? '1.2k',
                            'duration': service['duration'] ?? '35 mins',
                            'imageUrl': service['imageUrl'] ?? pkg['assetPath'],
                            ...pkg,
                          },
                        ),
                      );
                    });
                  },
                ),
              );
            });
          },
        ),
      );
    });
  }
}

/// Bottom Sheet listing all services under the selected sub-category (Half-Screen)
class _SubCategoryServicesBottomSheet extends StatelessWidget {
  final Map<String, dynamic> subCategory;
  final ValueChanged<Map<String, dynamic>> onSelectService;

  const _SubCategoryServicesBottomSheet({
    required this.subCategory,
    required this.onSelectService,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services =
        (subCategory['services'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final String fullName =
        subCategory['fullName'] as String? ?? subCategory['name'] as String;
    final String assetPath = subCategory['asset'] as String;

    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    final double halfScreenHeight = (MediaQuery.of(context).size.height * 0.52)
        .clamp(380.0, 520.0);

    return Container(
      height: halfScreenHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD5CC),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF6F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEFE8E1)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.handyman_rounded,
                      color: primaryRust,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fullName.replaceAll('\n', ' ').trim(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${services.length} Services Available • Verified Technicians',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F2EE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Color(0xFF4A3E39),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF0EBE6)),

          // Scrollable Services List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceListItem(context, service);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceListItem(
    BuildContext context,
    Map<String, dynamic> service,
  ) {
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFE8E1), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onSelectService(service),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Service Image Box with Badges
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F2EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: service['imageUrl'] as String,
                          fit: BoxFit.cover,
                          placeholder: (c, u) =>
                              Container(color: const Color(0xFFF7F2EC)),
                          errorWidget: (c, u, e) => const Icon(
                            Icons.build_rounded,
                            color: primaryRust,
                          ),
                        ),
                      ),
                      // Duration badge
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDAD3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            service['duration'] as String,
                            style: const TextStyle(
                              color: Color(0xFF721500),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      // Rating badge
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 10,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${service['rating']}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
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
                const SizedBox(width: 12),

                // Service Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (service['category'] as String).toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF9E381F),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        service['subtitle'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Price & Rate
                      Row(
                        children: [
                          Text(
                            Formatters.formatCurrency(service['price'] as int),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Formatters.formatCurrency(
                              service['originalPrice'] as int,
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 10.5,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            service['rateType'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0F7B42),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Select Service Button
                GestureDetector(
                  onTap: () => onSelectService(service),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: primaryRust,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Select',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ServicesFittingPackagesPopup:
/// Shows the "Services & Fitting Packages" popup (matching reference image)
/// when a service is tapped from the sub-category services bottom sheet.
class ServicesFittingPackagesPopup extends StatefulWidget {
  final String? categoryName;
  final Map<String, dynamic>? serviceItem;
  final ValueChanged<Map<String, dynamic>> onSelectPackage;

  const ServicesFittingPackagesPopup({
    super.key,
    this.categoryName,
    this.serviceItem,
    required this.onSelectPackage,
  });

  @override
  State<ServicesFittingPackagesPopup> createState() =>
      _ServicesFittingPackagesPopupState();
}

class _ServicesFittingPackagesPopupState
    extends State<ServicesFittingPackagesPopup> {
  final Set<String> _addedIds = {};

  @override
  Widget build(BuildContext context) {
    final String query =
        widget.serviceItem?['category'] as String? ??
        widget.serviceItem?['title'] as String? ??
        widget.categoryName ??
        'sanitary';
    final List<Map<String, dynamic>> packages = MockData.getCategoryPackages(
      query,
    );

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section (Matches exact uploaded screenshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Services & Fitting Packages',
                          style: TextStyle(
                            fontSize: 18.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1A17),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Tap to configure or add installation directly',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF706660),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // "4 OPTIONS" Pill Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.packageOptionBadgeBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${packages.length} OPTIONS',
                      style: const TextStyle(
                        color: AppColors.packageOptionBadgeText,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable List of Package Cards
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: packages.map((pkg) {
                    final id = pkg['id'] as String;
                    final isAdded = _addedIds.contains(id);
                    return _buildFittingPackageCard(context, pkg, isAdded);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFittingPackageCard(
    BuildContext context,
    Map<String, dynamic> item,
    bool isAdded,
  ) {
    final isPopular = (item['isPopular'] as bool?) ?? false;
    final assetPath = item['assetPath'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2ECE6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => widget.onSelectPackage(item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Left Image Box with Stack (optional POPULAR badge)
                SizedBox(
                  width: 68,
                  height: 68,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Outer cream rounded container
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF4EF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFEFE5DC),
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          // Inner white squircle with drop shadow
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              assetPath,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Center(
                                child: Icon(
                                  Icons.plumbing_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Top-left POPULAR Badge (if applicable)
                      if (isPopular)
                        Positioned(
                          top: -5,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.popularBadgeBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'POPULAR',
                              style: TextStyle(
                                color: AppColors.popularBadgeText,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 2. Middle Content (Title, Subtitle, Price)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: Color(0xFF1E1A17),
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['subtitle'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.5,
                            color: Color(0xFF7C736C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 7),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${item['pricePrefix']}₹${item['price']}',
                                style: const TextStyle(
                                  color: Color(0xFF94260D),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                ),
                              ),
                              TextSpan(
                                text: ' ${item['priceUnit']}',
                                style: const TextStyle(
                                  color: Color(0xFF857C76),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Thin Vertical Divider
                Container(width: 1, height: 46, color: const Color(0xFFF2ECE6)),

                // 4. Right Action Column (+ Add button & View Detail >)
                SizedBox(
                  width: 88,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "+ Add" Pill Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _addedIds.add(item['id'] as String);
                          });
                          widget.onSelectPackage(item);
                        },
                        child: Container(
                          height: 32,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isAdded
                                ? const Color(0xFFE8F5E9)
                                : AppColors.addPillBg,
                            borderRadius: BorderRadius.circular(16),
                            border: isAdded
                                ? Border.all(
                                    color: const Color(0xFFA5D6A7),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Text(
                            isAdded ? '✓ Added' : '+ Add',
                            style: TextStyle(
                              color: isAdded
                                  ? const Color(0xFF2E7D32)
                                  : AppColors.addPillText,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      // "View Detail >" Action
                      GestureDetector(
                        onTap: () => widget.onSelectPackage(item),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'View Detail',
                              style: TextStyle(
                                color: Color(0xFF822711),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCEFEA),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 11,
                                  color: Color(0xFF822711),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

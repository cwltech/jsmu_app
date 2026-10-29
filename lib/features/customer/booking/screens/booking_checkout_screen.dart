import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/booking_provider.dart';

class BookingCheckoutScreen extends StatefulWidget {
  const BookingCheckoutScreen({super.key});

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
  // State for interactive selections
  int _selectedDateIndex = 1; // Default to Thu, 24 (Tomorrow)
  String _selectedSlot = '01:00 PM'; // Default to 01:00 PM (Afternoon)
  bool _prefPressureGauge = true;
  bool _prefShoeCovers = true;
  final TextEditingController _instructionsController = TextEditingController();

  final List<Map<String, dynamic>> _dateOptions = const [
    {
      'weekday': 'Wed',
      'date': '23',
      'badge': 'RUSH',
      'note': '2 Slots Left',
      'badgeColor': Color(0xFFFDF0EB),
      'badgeTextColor': Color(0xFFC0392B),
    },
    {
      'weekday': 'Thu',
      'date': '24',
      'badge': 'TOMORROW',
      'note': 'Available',
      'badgeColor': Color(0xFF9E381F),
      'badgeTextColor': Colors.white,
    },
    {
      'weekday': 'Fri',
      'date': '25',
      'badge': null,
      'note': 'Standard',
      'badgeColor': null,
      'badgeTextColor': null,
    },
    {
      'weekday': 'Sat',
      'date': '26',
      'badge': 'WEEKEND',
      'note': 'Standard',
      'badgeColor': Color(0xFFFFF6E6),
      'badgeTextColor': Color(0xFFB45309),
    },
  ];

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  String get _currentSelectedDateString {
    final d = _dateOptions[_selectedDateIndex];
    return '${d['weekday']}, ${d['date']} Oct';
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F5),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1E1B18),
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Checkout',
          style: TextStyle(
            color: Color(0xFF1E1B18),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          // Headset Support Icon Button
          IconButton(
            icon: const Icon(
              Icons.headset_mic_outlined,
              color: Color(0xFF7A2210),
              size: 22,
            ),
            onPressed: () => AppSnackbar.showInfo(
              context,
              'Customer support active. We are here to help.',
            ),
          ),
          // User Avatar in Rust Circle
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF7A2210),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 1. 3-Step Breadcrumbs Progress Bar
                  _buildStepperHeader(),

                  const SizedBox(height: 14),

                  // 2. Service Location Card
                  _buildServiceLocationCard(),

                  const SizedBox(height: 18),

                  // 3. Select Date Section
                  _buildSelectDateSection(),

                  const SizedBox(height: 18),

                  // 4. Select Arrival Window
                  _buildArrivalWindowSection(),

                  const SizedBox(height: 14),

                  // Diagnostic Tools Notice Banner
                  _buildDiagnosticNoticeBanner(),

                  const SizedBox(height: 16),

                  // 5. Service & Safety Preferences Card
                  _buildPreferencesCard(),

                  const SizedBox(height: 16),

                  // 6. Urban Company Assurance Card
                  _buildAssuranceCard(),

                  const SizedBox(height: 16),

                  // 7. Booked Services (2) Summary Card
                  _buildBookedServicesCard(),

                  const SizedBox(height: 16),

                  // 8. Selected Slot Reminder Card
                  _buildSelectedSlotCard(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 9. Sticky Bottom Checkout Bar
          _buildStickyBottomBar(context, booking),
        ],
      ),
    );
  }

  // 1. 3-Step Stepper / Breadcrumbs Bar
  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Step 1: Cart (Completed)
          _buildStepItem(
            isCompleted: true,
            isActive: false,
            label: 'Cart',
            icon: Icons.check,
          ),
          // Connecting Line 1 (Rust)
          Expanded(
            child: Container(
              height: 2,
              color: const Color(0xFF7A2210),
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
          ),
          // Step 2: Date & Slot (Active)
          _buildStepItem(
            isCompleted: false,
            isActive: true,
            label: 'Date & Slot',
            number: '2',
          ),
          // Connecting Line 2 (Muted)
          Expanded(
            child: Container(
              height: 2,
              color: const Color(0xFFE8DFD7),
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
          ),
          // Step 3: Payment (Pending)
          _buildStepItem(
            isCompleted: false,
            isActive: false,
            label: 'Payment',
            number: '3',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required bool isCompleted,
    required bool isActive,
    required String label,
    IconData? icon,
    String? number,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isCompleted || isActive)
                ? const Color(0xFF7A2210)
                : const Color(0xFFE8DFD7),
            border: isActive
                ? Border.all(color: const Color(0xFFF4D4CA), width: 3.5)
                : null,
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: Colors.white, size: 15)
                : Text(
                    number ?? '',
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF7C736C),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? const Color(0xFF7A2210) : const Color(0xFF7C736C),
          ),
        ),
      ],
    );
  }

  // 2. Service Location Card
  Widget _buildServiceLocationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Pin & Change Button
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFC0392B),
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Service Location',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B18),
                ),
              ),
              const Spacer(),
              // Change Pill
              GestureDetector(
                onTap: () => AppSnackbar.showInfo(
                  context,
                  'You can select or add a new address.',
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF0EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 11,
                        color: Color(0xFF7A2210),
                      ),
                      SizedBox(width: 3),
                      Text(
                        'Change',
                        style: TextStyle(
                          color: Color(0xFF7A2210),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // "Home Primary" Row
          Row(
            children: [
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B18),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFEA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Primary',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6E6761),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Address details
          const Text(
            'Flat 402, Tower B, Palm Springs, Sector 54, Gurgaon - 122011',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF6E6761),
              height: 1.3,
            ),
          ),

          const SizedBox(height: 8),

          // Phone & Verified Pill
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: Color(0xFF7A2210),
              ),
              const SizedBox(width: 4),
              const Text(
                '+91 98765 43210',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF1E1B18),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF0EB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    color: Color(0xFF822711),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Select Date Section
  Widget _buildSelectDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Date',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B18),
              ),
            ),
            Text(
              'October 2024',
              style: TextStyle(
                color: Color(0xFF7A2210),
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 4 Date Cards
        Row(
          children: List.generate(_dateOptions.length, (idx) {
            final item = _dateOptions[idx];
            final isSelected = _selectedDateIndex == idx;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDateIndex = idx;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: idx < _dateOptions.length - 1 ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF822711) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF822711)
                          : const Color(0xFFF0EAE4),
                    ),
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
                  child: Column(
                    children: [
                      // Badge (if exists)
                      if (item['badge'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF9E381F)
                                : item['badgeColor'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['badge'] as String,
                            style: TextStyle(
                              fontSize: 7.5,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : item['badgeTextColor'] as Color,
                              letterSpacing: 0.2,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 14),

                      const SizedBox(height: 4),

                      // Weekday
                      Text(
                        item['weekday'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFFFFD7C9)
                              : const Color(0xFF7C736C),
                        ),
                      ),

                      // Date Number
                      Text(
                        item['date'] as String,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1E1B18),
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Note
                      Text(
                        item['note'] as String,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFFFFD7C9)
                              : (item['note'] == '2 Slots Left'
                                    ? const Color(0xFFC0392B)
                                    : const Color(0xFF8C8279)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 4. Select Arrival Window
  Widget _buildArrivalWindowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Arrival Window',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B18),
              ),
            ),
            Text(
              '30-min window',
              style: TextStyle(color: Color(0xFF7C736C), fontSize: 11),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Morning Card
        _buildWindowGroupCard(
          icon: Icons.wb_twilight_rounded,
          title: 'Morning',
          timeRange: '08:00 AM – 12:00 PM',
          slots: [
            {'time': '08:30 AM', 'badge': 'Fastest'},
            {'time': '10:00 AM', 'subtitle': 'Standard'},
            {'time': '11:30 AM', 'subtitle': 'Standard'},
          ],
        ),

        const SizedBox(height: 10),

        // Afternoon Card
        _buildWindowGroupCard(
          icon: Icons.wb_sunny_outlined,
          title: 'Afternoon',
          timeRange: '12:00 PM – 04:00 PM',
          slots: [
            {'time': '01:00 PM', 'subtitle': 'Standard'},
            {'time': '02:30 PM', 'subtitle': 'Standard'},
            {'time': '03:30 PM', 'subtitle': 'Standard'},
          ],
        ),

        const SizedBox(height: 10),

        // Evening Card
        _buildWindowGroupCard(
          icon: Icons.nightlight_outlined,
          title: 'Evening',
          timeRange: '04:00 PM – 08:00 PM',
          slots: [
            {'time': '05:00 PM', 'subtitle': 'Standard'},
            {'time': '06:30 PM', 'badge': 'Popular'},
            {'time': '07:30 PM', 'subtitle': 'Standard'},
          ],
        ),
      ],
    );
  }

  Widget _buildWindowGroupCard({
    required IconData icon,
    required String title,
    required String timeRange,
    required List<Map<String, String>> slots,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF7A2210)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Color(0xFF1E1B18),
                ),
              ),
              const Spacer(),
              Text(
                timeRange,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF7C736C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 3 Slot Pills Row
          Row(
            children: slots.map((s) {
              final time = s['time']!;
              final isSelected = _selectedSlot == time;
              final badge = s['badge'];

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSlot = time;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF822711)
                          : const Color(0xFFFAF4EE),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF822711))
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E1B18),
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 11,
                                color: Color(0xFF5CD894),
                              ),
                            ],
                          ],
                        ),
                        if (badge != null)
                          Text(
                            badge,
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? const Color(0xFFFFD7C9)
                                  : (badge == 'Fastest'
                                        ? const Color(0xFFC0392B)
                                        : const Color(0xFF7A2210)),
                            ),
                          )
                        else
                          Text(
                            isSelected ? 'Selected' : 'Standard',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: isSelected
                                  ? const Color(0xFFFFD7C9)
                                  : const Color(0xFF8C8279),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Diagnostic Notice Banner
  Widget _buildDiagnosticNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.bolt_rounded, color: Color(0xFF822711), size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'A verified plumbing specialist will arrive within this 30–min arrival window equipped with standard diagnostic tools.',
              style: TextStyle(
                color: Color(0xFF7A2210),
                fontSize: 11,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Service & Safety Preferences Card
  Widget _buildPreferencesCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service & Safety Preferences',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B18),
            ),
          ),

          const SizedBox(height: 12),

          // Option 1: Pressure Gauge
          _buildPreferenceOption(
            icon: Icons.speed_rounded,
            title: 'Carry heavy–duty pressure gauge',
            subtitle: 'Free add-on for valve tune-up',
            isChecked: _prefPressureGauge,
            onChanged: (val) {
              setState(() {
                _prefPressureGauge = val ?? false;
              });
            },
          ),

          const SizedBox(height: 10),

          // Option 2: Shoe covers
          _buildPreferenceOption(
            icon: Icons.clean_hands_outlined,
            title: 'Shoe covers & sanitized toolkit',
            subtitle: 'Standard hygiene compliance',
            isChecked: _prefShoeCovers,
            onChanged: (val) {
              setState(() {
                _prefShoeCovers = val ?? false;
              });
            },
          ),

          const SizedBox(height: 12),

          // Specific instructions note
          const Row(
            children: [
              Icon(Icons.edit_note_rounded, size: 15, color: Color(0xFF7A2210)),
              SizedBox(width: 4),
              Text(
                'Specific instructions for technician',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A423D),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // TextField
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F4EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _instructionsController,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF1E1B18)),
              decoration: const InputDecoration(
                hintText: 'e.g. Ring bell twice, gate passcode 4821',
                hintStyle: TextStyle(color: Color(0xFF9E948C), fontSize: 11.5),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFDF0EB),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF822711), size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1B18),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF7C736C),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!isChecked),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isChecked ? const Color(0xFFF4D8D2) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isChecked
                    ? const Color(0xFFC07060)
                    : const Color(0xFFD6CBC3),
                width: 1.2,
              ),
            ),
            child: isChecked
                ? const Icon(Icons.check, size: 14, color: Color(0xFF822711))
                : null,
          ),
        ),
      ],
    );
  }

  // 6. Urban Company Assurance Card
  Widget _buildAssuranceCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFF8DDD4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 14,
              color: Color(0xFF822711),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Urban Company Assurance',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B18),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Free cancellation or rescheduling up to 2 hours before the appointment. 100% money back guarantee on technician no-shows.',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF6E6761),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 7. Booked Services (2) Summary Card
  Widget _buildBookedServicesCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booked Services (2)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B18),
                ),
              ),
              Text(
                'Plumbing Package',
                style: TextStyle(
                  color: Color(0xFF822711),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Line 1
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '1 × Heavy Duty Brass Gate Valve Replacement',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF4A423D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '₹749',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1B18),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Line 2
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '1 × Pressure Relief Valve (PRV) Calibration',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF4A423D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '₹298',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1B18),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Taxes & Service Fee
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taxes & Service Fee',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF7C736C)),
              ),
              Text(
                'Included',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF822711),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF0EAE4), height: 1),
          const SizedBox(height: 10),

          // Total Payable
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B18),
                ),
              ),
              Text(
                '₹1,047',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF822711),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 8. Selected Slot Reminder Card
  Widget _buildSelectedSlotCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECTED SLOT',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9E948C),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$_currentSelectedDateString • $_selectedSlot',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7A2210),
                ),
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 10, color: Color(0xFF9E948C)),
              ),
              SizedBox(height: 2),
              Text(
                '₹1,047',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 9. Sticky Bottom Checkout Bar
  Widget _buildStickyBottomBar(BuildContext context, BookingProvider booking) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Payable: ',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6E6761)),
                    ),
                    const Text(
                      '₹1,047',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B18),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showBillDetailsModal(context),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 14,
                        color: Color(0xFF822711),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF822711),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Proceed to Pay Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  booking.confirmBooking();
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamedAndRemoveUntil('/live-tracking', (route) => false);
                  AppSnackbar.showSuccess(
                    context,
                    'Booking confirmed for $_currentSelectedDateString at $_selectedSlot!',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF822711),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Proceed to Pay',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bill Details Modal
  void _showBillDetailsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bill Summary',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B18),
              ),
            ),
            const SizedBox(height: 14),
            _buildBillRow('Brass Gate Valve Replacement', '₹749'),
            _buildBillRow('PRV Tuning & Fix', '₹298'),
            _buildBillRow('Taxes & Convenience Fee', 'Included'),
            const Divider(height: 20),
            _buildBillRow('Total Payable', '₹1,047', isBold: true),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              color: isBold ? const Color(0xFF1E1B18) : const Color(0xFF6E6761),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
              color: isBold ? const Color(0xFF822711) : const Color(0xFF1E1B18),
            ),
          ),
        ],
      ),
    );
  }
}

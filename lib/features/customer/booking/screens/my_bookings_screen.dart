import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Ongoing, 2: Scheduled, 3: Completed

  @override
  Widget build(BuildContext context) {
    const Color bgWarm = Color(0xFFFBF8F4);
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Scaffold(
      backgroundColor: bgWarm,
      appBar: AppBar(
        backgroundColor: bgWarm,
        elevation: 0,
        automaticallyImplyLeading: false, // Main screen, no back arrow
        title: Text(
          'My Bookings',
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
          // Notifications with unread badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: textDark,
                  size: 24,
                ),
                onPressed: () {
                  AppSnackbar.showInfo(
                    context,
                    'Technician Ramesh is 12 mins away from your location.',
                  );
                },
              ),
              Positioned(
                top: 13,
                right: 13,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: primaryRust,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // // 1. HEADER ROW: Title + Total Badge
            // Row(
            //   children: [
            //     Text(
            //       'My Bookings',
            //       style: GoogleFonts.plusJakartaSans(
            //         fontSize: 24,
            //         fontWeight: FontWeight.w800,
            //         color: textDark,
            //         letterSpacing: -0.3,
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 8,
            //         vertical: 3,
            //       ),
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF0EBE5),
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Text(
            //         '3 Total',
            //         style: GoogleFonts.plusJakartaSans(
            //           fontSize: 11,
            //           fontWeight: FontWeight.w800,
            //           color: textMuted,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 4),
            // Text(
            //   'Track ongoing repair visits and upcoming technician slots',
            //   style: GoogleFonts.plusJakartaSans(
            //     fontSize: 12.5,
            //     color: textMuted,
            //     height: 1.35,
            //   ),
            // ),

            // const SizedBox(height: 16),

            // 2. FILTER TABS (All, Ongoing, Scheduled, Completed)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterTab(
                    index: 0,
                    label: 'All',
                    count: '3',
                    isActive: _selectedFilter == 0,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterTab(
                    index: 1,
                    label: 'Ongoing',
                    hasDot: true,
                    count: '1',
                    isActive: _selectedFilter == 1,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterTab(
                    index: 2,
                    label: 'Scheduled',
                    count: '1',
                    isActive: _selectedFilter == 2,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterTab(
                    index: 3,
                    label: 'Completed',
                    count: '1',
                    isActive: _selectedFilter == 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. CARD 1: ONGOING (Interactive Live Map & Handshake OTP)
            if (_selectedFilter == 0 || _selectedFilter == 1) ...[
              _buildOngoingCard(context),
              const SizedBox(height: 16),
            ],

            // 4. CARD 2: SCHEDULED
            if (_selectedFilter == 0 || _selectedFilter == 2) ...[
              _buildScheduledCard(context),
              const SizedBox(height: 16),
            ],

            // 5. CARD 3: COMPLETED
            if (_selectedFilter == 0 || _selectedFilter == 3) ...[
              _buildCompletedCard(context),
              const SizedBox(height: 16),
            ],

            // 6. PRIORITY SUPPORT FOOTER CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2EC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBE4DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Color(0xFF7A3828),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Priority Support Available',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        Text(
                          'Instant resolution with technician concierge',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'Concierge Support: 1800-JSMU-CARE (Toll Free)',
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2DAD1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Contact',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Filter Tab Builder
  Widget _buildFilterTab({
    required int index,
    required String label,
    required String count,
    required bool isActive,
    bool hasDot = false,
  }) {
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryRust : const Color(0xFFF2ECE6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasDot) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : primaryRust,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                color: isActive ? Colors.white : textDark,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.24)
                    : const Color(0xFFE5DDD6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: isActive ? Colors.white : textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Ongoing Booking Card
  Widget _buildOngoingCard(BuildContext context) {
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status + ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: primaryRust,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'IN TRANSIT • 12 MINS AWAY',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: primaryRust,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2ECE6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#JSMU-89241',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: textMuted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title & Subtitle
          Text(
            'Brass Gate Valve Installation &\nPlumbing Check',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: textDark,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Bathroom 2 & Main Overhead Inflow line',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
          ),

          const SizedBox(height: 14),

          // Technician Info Tile (Ramesh Sharma)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF6F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBE0D6),
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/tech_ramesh.png',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.person,
                          color: primaryRust,
                          size: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: primaryRust,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Ramesh Sharma',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDD2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ISO CERTIFIED',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: primaryRust,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFE88A1A),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '4.9',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(420+ jobs)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Call Button
                GestureDetector(
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'Calling Ramesh Sharma (+91 98711 00234)...',
                  ),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EBE5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: textDark,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Chat Button
                GestureDetector(
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'Opening direct chat with Ramesh Sharma...',
                  ),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EBE5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: textDark,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Arrival Timeline (Step 3 of 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ARRIVAL TIMELINE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: textMuted,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                'Step 3 of 4',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: primaryRust,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildTimelineBar(filled: true, color: primaryRust),
              const SizedBox(width: 4),
              _buildTimelineBar(filled: true, color: primaryRust),
              const SizedBox(width: 4),
              _buildTimelineBar(filled: true, color: const Color(0xFFD88D79)),
              const SizedBox(width: 4),
              _buildTimelineBar(filled: false),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booked',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: textDark,
                ),
              ),
              Text(
                'Dispatched',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: textDark,
                ),
              ),
              Text(
                'On Way',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: primaryRust,
                ),
              ),
              Text(
                'Service',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Interactive Mini Map
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/live-tracking'),
            child: Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEFE8E1)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/live_tracking_map_preview.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: const Color(0xFFF7F2EC),
                  child: const Center(
                    child: Icon(
                      Icons.map_rounded,
                      color: primaryRust,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Security Handshake OTP Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF4EE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: primaryRust,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Handshake OTP',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      Text(
                        'Share when technician arrives',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '4892',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: primaryRust,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Main Button: Track Live on Map
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/live-tracking'),
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryRust,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryRust.withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.navigation_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Track Live on Map',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Secondary Row: Reschedule Slot & Cancel Visit
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'Select a new convenient time slot for Ramesh Sharma',
                  ),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2ECE6),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Reschedule Slot',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'Are you sure you want to cancel visit #JSMU-89241?',
                  ),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2ECE6),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel Visit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
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

  // 2. Scheduled Booking Card
  Widget _buildScheduledCard(BuildContext context) {
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: SCHEDULED badge + ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDDD2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: primaryRust,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'SCHEDULED',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: primaryRust,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '#JSMU-89104',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            'Kitchen Tap Re-Sealing & Pipe\nInspection',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textDark,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),

          // Date & Time
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: Color(0xFF7A2210),
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                'Thu, 24 Oct • 10:00 AM – 11:30 AM',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7A2210),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Master Plumber Assignment Notice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4EE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBE3D8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: primaryRust,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master Plumber Assignment',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      Text(
                        'Technician profile will be allocated 2 hours prior to the slot',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Footer: Total Prepaid + Reschedule + View Details
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Prepaid',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: textMuted,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₹349',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'via UPI',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => AppSnackbar.showInfo(
                  context,
                  'Reschedule request submitted for Kitchen Tap Re-Sealing',
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2ECE6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Reschedule',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => AppSnackbar.showInfo(
                  context,
                  'Order details: ₹349 paid on 20 Oct. Warranty covered.',
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: primaryRust,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  // 3. Completed Booking Card
  Widget _buildCompletedCard(BuildContext context) {
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: COMPLETED badge + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2E7D32),
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'COMPLETED',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E7D32),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '18 Oct 2024',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title & Thumbnail
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Water Tank Ball Valve & Float\nReplacement',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Rooftop 1000L Overhead Tank Unit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹499 • Paid & Invoiced',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEBE0D6),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/water_tank_thumb.png',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.water_drop_outlined,
                    color: primaryRust,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 30-Day Guarantee Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF7A3828),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '30-Day Guarantee Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      Text(
                        '18 days warranty remaining',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'Warranty claim submitted. A technician will contact you shortly.',
                  ),
                  child: Text(
                    'Claim',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: primaryRust,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Buttons: Invoice + Book Again
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => AppSnackbar.showSuccess(
                    context,
                    'Invoice downloaded: GST-JSMU-2024-1018.pdf',
                  ),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2ECE6),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.download_rounded,
                          color: textDark,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Invoice',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/service-details'),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: primaryRust,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.repeat_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Book Again',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

  // Progress Bar Helper
  Widget _buildTimelineBar({required bool filled, Color? color}) {
    return Expanded(
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: filled
              ? (color ?? const Color(0xFF862D17))
              : const Color(0xFFE5DDD6),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  // Persistent Bottom Navigation Bar
  Widget _buildBottomNavigationBar(BuildContext context) {
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
                icon: Icons.home_repair_service_outlined,
                label: 'Services',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/service-details'),
              ),
              _buildNavItem(
                icon: Icons.calendar_today_rounded,
                label: 'Bookings',
                badgeCount: '1',
                isActive: true,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Cart',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/booking-checkout'),
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

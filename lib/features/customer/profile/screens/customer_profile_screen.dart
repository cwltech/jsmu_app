import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';
import 'package:jsmu/features/auth/providers/auth_provider.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final userName = user?.name.isNotEmpty == true
        ? user!.name
        : 'Vikram Malhotra';
    final userPhone = user?.phone.isNotEmpty == true
        ? user!.phone
        : '+91 98711 49829';
    final userEmail = user?.email?.isNotEmpty == true
        ? user!.email!
        : 'vikram.m@gmail.com';

    const Color bgWarm = Color(0xFFFBF8F4);
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Scaffold(
      backgroundColor: bgWarm,
      appBar: AppBar(
        backgroundColor: bgWarm,
        elevation: 0,
        // leading: Navigator.canPop(context)
        //     ? IconButton(
        //         icon: const Icon(Icons.arrow_back_rounded, color: textDark),
        //         onPressed: () => Navigator.pop(context),
        //       )
        //     : null,
        title: Text(
          'Account',
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
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
                    'No new notifications right now',
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

          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 1. MAIN PROFILE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top Row: Avatar with Edit icon + Name, Phone, Email
                  Row(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF4ECE4),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/profile_user.png',
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.person,
                                color: primaryRust,
                                size: 36,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: primaryRust,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),

                      // User Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    userName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified,
                                  color: primaryRust,
                                  size: 17,
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              userPhone,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userEmail,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: const Color(0xFF8C8681),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // JSMU Plus Member Banner
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9EFE7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0DFD3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            color: primaryRust,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JSMU Plus Member',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2C241E),
                              ),
                            ),
                            Text(
                              'Active • Renews Dec 2025',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: textMuted,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDDD2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Tier Gold',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: primaryRust,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats Row (14 Bookings, ₹2,450 Saved, 4.9 Rating)
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatBox(
                        value: '14',
                        label: 'BOOKINGS',
                        isAccent: true,
                      ),
                      const SizedBox(width: 10),
                      _buildStatBox(
                        value: '₹2,450',
                        label: 'SAVED',
                        isAccent: true,
                      ),
                      const SizedBox(width: 10),
                      _buildStatBox(
                        value: '4.9 ★',
                        label: 'RATING GIVEN',
                        isAccent: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 2. QUICK 4-CARDS ROW (Bookings, Wallet, Saved, Help)
            Row(
              children: [
                _buildQuickCard(
                  title: 'Bookings',
                  icon: Icons.calendar_month_outlined,
                  badge: '1',
                  onTap: () => Navigator.pushNamed(context, '/my-bookings'),
                ),
                const SizedBox(width: 10),
                _buildQuickCard(
                  title: 'Wallet',
                  subtitle: '₹450',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'JSMU Wallet Balance: ₹450 (Usable on next booking)',
                  ),
                ),
                const SizedBox(width: 10),
                _buildQuickCard(
                  title: 'Saved',
                  subtitle: '3 Homes',
                  icon: Icons.location_on_outlined,
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'Saved Addresses: Home (Gurugram Sec 48), Office, Parents',
                  ),
                ),
                const SizedBox(width: 10),
                _buildQuickCard(
                  title: 'Help',
                  subtitle: '24x7 Care',
                  icon: Icons.support_agent_rounded,
                  isSupport: true,
                  onTap: () => AppSnackbar.showInfo(
                    context,
                    'JSMU 24x7 Customer Priority Care: 1800-JSMU-CARE',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 3. JSMU CLUB & HOME SHIELD BANNER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5DA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.military_tech_outlined,
                        color: primaryRust,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'JSMU Club & Home Shield',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1A17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Zero inspection charges, 10% off genuine spare parts, and priority 30-min technician dispatch.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: textMuted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => AppSnackbar.showSuccess(
                      context,
                      'Home Shield Membership is active on your account!',
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primaryRust,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Benefits',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. ORDERS & ACTIVITY SECTION
            Text(
              'ORDERS & ACTIVITY',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: textMuted,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.history_rounded,
                    title: 'Booking History & Work Orders',
                    subtitle: 'Plumbing, Electrical, AC Services',
                    badge: '1 Ongoing',
                    onTap: () => Navigator.pushNamed(context, '/my-bookings'),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.sync_rounded,
                    title: 'Annual Maintenance Plans (AMC)',
                    subtitle: 'Quarterly filter check & drain service',
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'Active AMC Plan: Whole-House Plumbing & RO Care',
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Invoices & GST Receipts',
                    subtitle: 'Tax compliant invoices with parts breakdown',
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      '3 Tax invoices available for download',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5. PREFERENCES & PAYMENT SECTION
            Text(
              'PREFERENCES & PAYMENT',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: textMuted,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.home_outlined,
                    title: 'Manage Saved Addresses',
                    subtitle: 'Gurugram, Sector 48, DLF Phase 4...',
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'Default Address: Gurugram, Sector 48',
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.credit_card_rounded,
                    title: 'Payment Methods & UPI',
                    subtitle: 'Google Pay, Paytm, Saved Cards',
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'UPI Linked: vikram@okhdfcbank (Verified)',
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Preferences',
                    subtitle: 'WhatsApp updates, SMS alerts, Promos',
                    onTap: () => AppSnackbar.showInfo(
                      context,
                      'Instant booking alerts via WhatsApp & SMS are ON',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 6. PRO PARTNER & SIGN OUT
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.handyman_outlined,
                    iconColor: primaryRust,
                    title: 'Switch to Partner / Pro Portal',
                    subtitle: 'Manage partner jobs, leads & daily earnings',
                    onTap: () {
                      auth.setSelectedRole('partner');
                      Navigator.pushNamed(context, '/partner-dashboard');
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.logout_rounded,
                    iconColor: const Color(0xFFDC2626),
                    title: 'Sign Out',
                    titleColor: const Color(0xFFDC2626),
                    subtitle: 'Log out of your customer account',
                    onTap: () {
                      try {
                        auth.signOut();
                      } catch (_) {}
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                      AppSnackbar.showInfo(context, 'Signed out successfully');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String value,
    required String label,
    required bool isAccent,
  }) {
    const Color primaryRust = Color(0xFF862D17);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4EE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isAccent ? primaryRust : const Color(0xFF2C241E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF6B645E),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard({
    required String title,
    String? subtitle,
    required IconData icon,
    String? badge,
    bool isSupport = false,
    required VoidCallback onTap,
  }) {
    const Color primaryRust = Color(0xFF862D17);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSupport
                          ? const Color(0xFFECE7E1)
                          : const Color(0xFFFFE3D8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSupport ? const Color(0xFF1C1917) : primaryRust,
                      size: 20,
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: const BoxDecoration(
                          color: primaryRust,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge,
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
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1917),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: subtitle.startsWith('₹')
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: subtitle.startsWith('₹')
                        ? primaryRust
                        : const Color(0xFF6B645E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    const Color primaryRust = Color(0xFF862D17);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F2EC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? primaryRust, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: titleColor ?? const Color(0xFF1C1917),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          color: const Color(0xFF6B645E),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDDD2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: primaryRust,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: Color(0xFFA8A19B),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 62,
      endIndent: 14,
      color: Color(0xFFF0EBE5),
    );
  }
}

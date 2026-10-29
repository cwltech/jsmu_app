import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgWarm = Color(0xFFFBF8F4);
    const Color primaryRust = Color(0xFF862D17);
    const Color textDark = Color(0xFF1C1917);
    const Color textMuted = Color(0xFF6B645E);

    return Scaffold(
      backgroundColor: bgWarm,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 14),

              // 1. TOP HERO IMAGE CARD (Family on sofa with 4.9 Verified Badge)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: AspectRatio(
                      aspectRatio: 380 / 370,
                      child: Image.asset(
                        'assets/images/intro_family.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF0EBE5),
                          child: const Center(
                            child: Icon(
                              Icons.family_restroom_rounded,
                              size: 64,
                              color: primaryRust,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. PILL TAG: EFFORTLESS HOME CARE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6ECE3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: primaryRust,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'EFFORTLESS HOME CARE',
                      style: GoogleFonts.plusJakartaSans(
                        color: primaryRust,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. HEADLINE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'More time for what\nmatters, at home.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                    height: 1.22,
                    letterSpacing: -0.4,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 4. SUBTITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Experience effortless living with certified\ndomestic experts at your doorstep in under 15\nminutes.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: textMuted,
                    height: 1.45,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 5. CAROUSEL INDICATOR DOTS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 5,
                    decoration: BoxDecoration(
                      color: primaryRust,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5DDD6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 6. TRUST BADGES ROW (Horizontally Scrollable Chips)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTrustChip(
                      icon: Icons.badge_outlined,
                      label: 'Verified Background Check',
                    ),
                    const SizedBox(width: 10),
                    _buildTrustChip(
                      icon: Icons.receipt_long_outlined,
                      label: 'Transparent Fixed Pricing',
                    ),
                    const SizedBox(width: 10),
                    _buildTrustChip(
                      icon: Icons.timer_outlined,
                      label: '45-Min Express Arrival',
                    ),
                    const SizedBox(width: 10),
                    _buildTrustChip(
                      icon: Icons.verified_user_outlined,
                      label: '30-Day Post Warranty',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 7. PRIMARY CTA BUTTON: Book Home Services ->
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/sign-in'),
                  child: Container(
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryRust,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: primaryRust.withValues(alpha: 0.30),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book Home Services',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 8. FOOTER: I already have an account • Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I already have an account • ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: textMuted,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sign-in'),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: primaryRust,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEFE4DA), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0DFD3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF862D17), size: 15),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1917),
            ),
          ),
        ],
      ),
    );
  }
}

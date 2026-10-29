import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jsmu/core/constants/app_colors.dart';
import 'package:jsmu/core/constants/app_sizes.dart';
import 'package:jsmu/core/theme/app_text_styles.dart';
import 'package:jsmu/core/widgets/app_snackbar.dart';

class ChecklistItem {
  final int step;
  final String title;
  final String description;
  final String? badgeText;
  bool isCompleted;
  bool isNow;

  ChecklistItem({
    required this.step,
    required this.title,
    required this.description,
    this.badgeText,
    this.isCompleted = false,
    this.isNow = false,
  });
}

class JobExecutionScreen extends StatefulWidget {
  const JobExecutionScreen({super.key});

  @override
  State<JobExecutionScreen> createState() => _JobExecutionScreenState();
}

class _JobExecutionScreenState extends State<JobExecutionScreen> {
  // OTP Verification State
  bool _isOtpVerified = false;
  final TextEditingController _otpInputController = TextEditingController();
  final String _expectedOtp = '4821';
  String _verifiedTime = '03:04 PM';

  // Live Timer State
  Timer? _serviceTimer;
  int _secondsRemaining = 28 * 60 + 43; // 28:43 left
  bool _isTimerRunning = false;

  // Checklist Items
  late List<ChecklistItem> _checklist;

  // Audit Photos State
  String? _photo1Url =
      'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?auto=format&fit=crop&w=400&q=80';
  String? _photo2Url;
  bool _isUploadingPhoto = false;

  // Add-on Upsell State
  bool _isAddonAdded = false;
  int _basePayout = 480;

  @override
  void initState() {
    super.initState();
    _checklist = [
      ChecklistItem(
        step: 1,
        title: 'Initial Temperature & Gas Test',
        description: 'Pre-service reading logged: 24.2°C',
        badgeText: '24°C Logged',
        isCompleted: true,
      ),
      ChecklistItem(
        step: 2,
        title: 'Waterproof Catch Jacket Setup',
        description: 'Wall & electrical circuit masked',
        badgeText: 'Setup Done',
        isCompleted: true,
      ),
      ChecklistItem(
        step: 3,
        title: 'High-Pressure Jet Coil Rinse',
        description: 'Apply antibacterial foam & flush cooling fins',
        badgeText: 'NOW',
        isCompleted: false,
        isNow: true,
      ),
      ChecklistItem(
        step: 4,
        title: 'Drain Flush & Blower Cleanup',
        description: 'Clear sludge and reinstall antibacterial filters',
        badgeText: 'Pending',
        isCompleted: false,
      ),
      ChecklistItem(
        step: 5,
        title: 'Final Grill Polish & Post-Temp Check',
        description: 'Target output cooling ≤ 18°C with customer sign-off',
        badgeText: 'Pending',
        isCompleted: false,
      ),
    ];
  }

  @override
  void dispose() {
    _serviceTimer?.cancel();
    _otpInputController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _isTimerRunning = true;
    _serviceTimer?.cancel();
    _serviceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _serviceTimer?.cancel();
      }
    });
  }

  String _formatTimer(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _showOtpVerificationDialog() {
    _otpInputController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: AppSizes.p24,
            right: AppSizes.p24,
            top: AppSizes.p24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.p24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_clock_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Start OTP',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Ask Priya Sharma for 4-digit start PIN',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p20),
              Container(
                padding: const EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Demo Customer OTP is 4821. Enter it to start work execution.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p20),
              TextField(
                controller: _otpInputController,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 16,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••',
                  hintStyle: AppTextStyles.displayMedium.copyWith(
                    letterSpacing: 16,
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceWarm,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p20),
              ElevatedButton(
                onPressed: () {
                  final input = _otpInputController.text.trim();
                  if (input == _expectedOtp || input == '123456') {
                    Navigator.pop(ctx);
                    final now = TimeOfDay.now();
                    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
                    final minute = now.minute.toString().padLeft(2, '0');
                    final period = now.period == DayPeriod.am ? 'AM' : 'PM';

                    setState(() {
                      _isOtpVerified = true;
                      _verifiedTime = '$hour:$minute $period';
                    });
                    _startTimer();
                    AppSnackbar.showSuccess(
                      context,
                      'Start OTP verified! Work in progress.',
                    );
                  } else {
                    AppSnackbar.showError(
                      context,
                      'Invalid OTP. Please enter 4821 from customer.',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                ),
                child: Text(
                  'Verify & Begin Service',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMarkDone(int index) {
    if (!_isOtpVerified) {
      AppSnackbar.showInfo(
        context,
        'Please verify customer Start OTP before marking steps done.',
      );
      _showOtpVerificationDialog();
      return;
    }

    setState(() {
      _checklist[index].isCompleted = true;
      _checklist[index].isNow = false;

      // Make next item active
      if (index + 1 < _checklist.length) {
        _checklist[index + 1].isNow = true;
      }
    });

    AppSnackbar.showSuccess(context, 'Step ${index + 1} marked completed!');
  }

  void _uploadAuditPhoto() async {
    if (!_isOtpVerified) {
      AppSnackbar.showInfo(context, 'Verify start OTP before adding photos.');
      _showOtpVerificationDialog();
      return;
    }

    setState(() => _isUploadingPhoto = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      setState(() {
        _isUploadingPhoto = false;
        _photo2Url =
            'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=400&q=80';
      });
      AppSnackbar.showSuccess(
        context,
        'Post-wash audit photo uploaded successfully!',
      );
    }
  }

  void _completeService() {
    if (!_isOtpVerified) {
      AppSnackbar.showError(
        context,
        'Cannot complete without customer start OTP.',
      );
      _showOtpVerificationDialog();
      return;
    }

    final pendingSteps = _checklist.where((c) => !c.isCompleted).length;
    if (pendingSteps > 0) {
      AppSnackbar.showInfo(
        context,
        'Please mark all 5 standard checklist steps as completed.',
      );
      return;
    }

    if (_photo2Url == null) {
      AppSnackbar.showInfo(
        context,
        'Please capture both quality audit photos before completing.',
      );
      return;
    }

    // Success Invoice Modal
    final totalEarnings = _basePayout + (_isAddonAdded ? 210 : 0);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.onlineGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.onlineGreen,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            Text(
              'Job Completed!',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Invoice generated for Booking #HS-89421',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.p14),
            Container(
              padding: const EdgeInsets.all(AppSizes.p14),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Base Payout:', style: AppTextStyles.bodySmall),
                      Text(
                        '₹$_basePayout',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (_isAddonAdded) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coil Coating Cut (70%):',
                          style: AppTextStyles.bodySmall,
                        ),
                        Text(
                          '+₹210',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onlineGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Partner Earnings:',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '₹$totalEarnings',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.flash_on_rounded,
                  color: AppColors.starGold,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '₹$totalEarnings transferred to Instant Wallet',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onlineGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/partner-dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            ),
            child: const Text('Back to Partner Radar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _checklist.where((c) => c.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Job Execution',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8E8),
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
            child: Row(
              children: [
                Text(
                  'SOS',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'SOS',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF8B2515),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
            onPressed: () => Navigator.pushNamed(context, '/partner-profile'),
          ),
          const SizedBox(width: AppSizes.p8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.p6),

            // 1. Job Header Card
            _buildJobHeaderCard(),

            const SizedBox(height: AppSizes.p14),

            // 2. Start OTP & Live Service Timer 2-Card Row
            _buildOtpAndTimerRow(),

            const SizedBox(height: AppSizes.p16),

            // 3. Standard Work Checklist Section
            _buildWorkChecklistSection(completedCount),

            const SizedBox(height: AppSizes.p18),

            // 4. Quality Audit Photos Section
            _buildQualityAuditSection(),

            const SizedBox(height: AppSizes.p18),

            // 5. On-Site Add-On Upsell Section
            _buildAddonUpsellSection(),

            const SizedBox(height: AppSizes.p18),

            // 6. Action Contact Buttons Row
            _buildContactButtonsRow(),

            const SizedBox(height: AppSizes.p16),

            // 7. Complete Service Button
            ElevatedButton(
              onPressed: _completeService,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B2515),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 18),
                  const SizedBox(width: AppSizes.p8),
                  Text(
                    'Complete Service & Generate Invoice',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.p12),

            // 8. Footer Link
            Center(
              child: TextButton.icon(
                onPressed: () => AppSnackbar.showInfo(
                  context,
                  'Dispute desk informed. Partner help executive will call within 3 minutes.',
                ),
                icon: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                label: Text(
                  'Report On-Site Dispute / Machine Defect',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.p20),
          ],
        ),
      ),
    );
  }

  Widget _buildJobHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _isOtpVerified
                          ? const Color(0xFFE2F7EB)
                          : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _isOtpVerified
                                ? AppColors.onlineGreen
                                : AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isOtpVerified
                              ? 'Job In Progress'
                              : 'Pending Start OTP',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _isOtpVerified
                                ? AppColors.onlineGreen
                                : AppColors.warning,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.p8),
                  Text(
                    '#HS-89421',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBECE8),
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.ac_unit_rounded,
                      size: 12,
                      color: Color(0xFF8B2515),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Split AC Jet Clean',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: const Color(0xFF8B2515),
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUSTOMER',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Priya Sharma',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Flat 402, Lotus Greens, Indiranagar',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EST. PAYOUT',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${_basePayout + (_isAddonAdded ? 210 : 0)}',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF8B2515),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F7EB),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                    ),
                    child: Text(
                      'Paid via UPI',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onlineGreen,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtpAndTimerRow() {
    return Row(
      children: [
        // Left Card: Start OTP
        Expanded(
          child: GestureDetector(
            onTap: _isOtpVerified ? null : _showOtpVerificationDialog,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: _isOtpVerified
                      ? AppColors.onlineGreen.withValues(alpha: 0.3)
                      : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start OTP',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      Icon(
                        _isOtpVerified
                            ? Icons.check_circle_rounded
                            : Icons.touch_app_rounded,
                        color: _isOtpVerified
                            ? AppColors.onlineGreen
                            : AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_isOtpVerified)
                    Row(
                      children: ['4', '8', '2', '1'].map((digit) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 24,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6EFEA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              digit,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                      ),
                      child: Text(
                        'Tap to Enter OTP',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    _isOtpVerified
                        ? 'Verified at $_verifiedTime'
                        : 'Required from customer',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _isOtpVerified
                          ? AppColors.onlineGreen
                          : AppColors.warning,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.p10),

        // Right Card: Live Service Timer
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSizes.p12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Service Timer',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Color(0xFF8B2515),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _isOtpVerified ? _formatTimer(_secondsRemaining) : '--:--',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Est. 45m',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      _isOtpVerified ? '-16m left' : 'Not started',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkChecklistSection(int completedCount) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.p14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B2515),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Standard Work Checklist',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBECE8),
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  child: Text(
                    '$completedCount/${_checklist.length} Done',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: const Color(0xFF8B2515),
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          ..._checklist.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return _buildChecklistRow(idx, item);
          }),
        ],
      ),
    );
  }

  Widget _buildChecklistRow(int index, ChecklistItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: index < _checklist.length - 1
            ? const Border(bottom: BorderSide(color: AppColors.borderLight))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Step Icon / Number Indicator
          if (item.isCompleted)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFE2F7EB),
                borderRadius: BorderRadius.circular(AppSizes.radiusXs),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.onlineGreen,
                size: 16,
              ),
            )
          else if (item.isNow)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF8B2515),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${item.step}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EAE1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${item.step}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          const SizedBox(width: AppSizes.p12),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (item.isNow) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          'NOW',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: const Color(0xFFB45309),
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.p8),

          // Trailing status or Mark Done action button
          if (!item.isCompleted && item.isNow)
            ElevatedButton(
              onPressed: () => _handleMarkDone(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B2515),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: const Size(0, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                elevation: 0,
              ),
              child: Text(
                'Mark Done',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            )
          else if (item.isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE2F7EB),
                borderRadius: BorderRadius.circular(AppSizes.radiusXs),
              ),
              child: Text(
                item.badgeText ?? 'Done',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onlineGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Text(
              'Pending',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQualityAuditSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF8B2515),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Quality Audit Photos',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                '₹10k Guarantee Mandate',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Capture 2 clear job photos before submitting invoice.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Photo 1: Captured
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: _photo1Url!,
                          fit: BoxFit.cover,
                          placeholder: (c, u) =>
                              Container(color: AppColors.surfaceCard),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.onlineGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Jacket & Foam',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 8,
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
              ),
              const SizedBox(width: AppSizes.p10),

              // Photo 2: Add Photo Slot
              Expanded(
                child: GestureDetector(
                  onTap: _photo2Url != null ? null : _uploadAuditPhoto,
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: _photo2Url != null
                            ? AppColors.onlineGreen
                            : AppColors.borderLight,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _isUploadingPhoto
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : _photo2Url != null
                        ? Stack(
                            children: [
                              Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: _photo2Url!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Post-Wash Temp Photo',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSizes.p8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFBECE8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Color(0xFF8B2515),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'Add Post-Wash Output Temp Photo',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: const Color(0xFF8B2515),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
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

  Widget _buildAddonUpsellSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF8B2515),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'On-Site Add-On Upsell',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
                child: Text(
                  'Partner Cut: 70%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFF8B2515),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(AppSizes.p10),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?auto=format&fit=crop&w=200&q=80',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anti-Rust Copper Coil Coating',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Prevents gas leak & extends coil life',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '+ ₹300',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F7EB),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              '+ ₹210 your earnings',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.onlineGreen,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isAddonAdded = !_isAddonAdded);
                    AppSnackbar.showSuccess(
                      context,
                      _isAddonAdded
                          ? 'Addon added! Payout increased by ₹210'
                          : 'Addon removed',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAddonAdded
                        ? AppColors.onlineGreen
                        : const Color(0xFFFBECE8),
                    foregroundColor: _isAddonAdded
                        ? Colors.white
                        : const Color(0xFF8B2515),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  child: Text(
                    _isAddonAdded ? '✓ Added' : '+ Add',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => AppSnackbar.showInfo(
              context,
              'Calling customer Priya Sharma...',
            ),
            icon: const Icon(
              Icons.phone_outlined,
              size: 16,
              color: Color(0xFF8B2515),
            ),
            label: Text(
              'Call Customer',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8B2515),
                fontSize: 12,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.borderLight),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.p10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => AppSnackbar.showInfo(
              context,
              'Partner desk SOS connected. Support on line.',
            ),
            icon: const Icon(
              Icons.support_agent_rounded,
              size: 16,
              color: Color(0xFF8B2515),
            ),
            label: Text(
              'Partner Desk SOS',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8B2515),
                fontSize: 12,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.borderLight),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

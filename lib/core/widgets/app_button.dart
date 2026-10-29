import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outlined, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.textColor,
    this.height = AppSizes.buttonHeightLg,
    this.width,
    this.padding,
    this.borderRadius = AppSizes.radiusPill,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? border;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = backgroundColor ?? AppColors.primary;
        fg = textColor ?? AppColors.textOnPrimary;
        border = BorderSide.none;
        break;
      case AppButtonVariant.secondary:
        bg = backgroundColor ?? AppColors.surfaceCard;
        fg = textColor ?? AppColors.textPrimary;
        border = BorderSide.none;
        break;
      case AppButtonVariant.outlined:
        bg = backgroundColor ?? Colors.transparent;
        fg = textColor ?? AppColors.textPrimary;
        border = const BorderSide(color: AppColors.border, width: 1.2);
        break;
      case AppButtonVariant.ghost:
        bg = Colors.transparent;
        fg = textColor ?? AppColors.primary;
        border = BorderSide.none;
        break;
    }

    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: AppSizes.p8),
              ],
              Text(text, style: AppTextStyles.labelLarge.copyWith(color: fg)),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSizes.p8),
                trailingIcon!,
              ],
            ],
          );

    return SizedBox(
      width: isFullWidth ? (width ?? double.infinity) : width,
      height: height,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding:
              padding ?? const EdgeInsets.symmetric(horizontal: AppSizes.p20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: border ?? BorderSide.none,
          ),
          disabledBackgroundColor: bg.withValues(alpha: 0.6),
          disabledForegroundColor: fg.withValues(alpha: 0.6),
        ),
        child: child,
      ),
    );
  }
}

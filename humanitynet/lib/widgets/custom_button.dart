import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: color ?? AppConstants.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _buildChild(color ?? AppConstants.primary),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color ?? AppConstants.primary,
            color != null
                ? color!.withAlpha(204)
                : AppConstants.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: isLoading ? [] : AppTheme.primaryButtonShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(child: _buildChild(Colors.white)),
        ),
      ),
    );
  }

  Widget _buildChild(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: textColor,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(text, style: AppTheme.buttonText.copyWith(color: textColor)),
        ],
      );
    }

    return Text(
      text,
      style: AppTheme.buttonText.copyWith(color: textColor),
    );
  }
}
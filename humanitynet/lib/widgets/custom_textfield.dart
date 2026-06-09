import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:    widget.controller,
      validator:     widget.validator,
      keyboardType:  widget.keyboardType,
      obscureText:   widget.isPassword && _obscure,
      maxLines:      widget.isPassword ? 1 : widget.maxLines,
      maxLength:     widget.maxLength,
      onChanged:     widget.onChanged,
      readOnly:      widget.readOnly,
      onTap:         widget.onTap,
      style:         AppTheme.bodyMedium.copyWith(
        color: const Color(0xFF1A1A2E),
      ),
      decoration: AppTheme.inputDecoration(
        hint: widget.hint,
        label: widget.label,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, size: 20, color: const Color(0xFF94A3B8))
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : widget.suffixIcon,
      ),
    );
  }
}
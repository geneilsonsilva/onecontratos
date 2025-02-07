import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onecontratos/pages/Utils/colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final double borderRadius;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = "Selecione",
    this.fillColor = const Color(0xFFF1F4FF),
    this.borderColor = const Color(0xFFBDBDBD),
    this.focusedBorderColor = const Color(0xFF1E88E5),
    this.errorBorderColor = Colors.red,
    this.borderRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: fillColor.withOpacity(0.9),
        filled: true,
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFFb8c6d9),
        ),
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: const Color(0xFF626262),
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.doberInput, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

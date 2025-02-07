import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onecontratos/pages/Utils/colors.dart';

InputDecoration textFormField(String label) {
  return InputDecoration(
    hintText: label,
    fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
    filled: true,
    isDense: true,
    hintStyle: GoogleFonts.poppins(
      
      color: const Color(0xFFb8c6d9),
    ),
    labelStyle: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: const Color(0xFF626262),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
      borderRadius: BorderRadius.circular(5),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.doberInput, width: 1.0),
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.0),
      borderRadius: BorderRadius.circular(5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.0),
      borderRadius: BorderRadius.circular(5),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.0),
      borderRadius: BorderRadius.circular(5),
    ),
  );
}

// TextFormField(
//             readOnly: isDate,
//             onTap: isDate
//                 ? () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(2100),
//                     );
//                     if (pickedDate != null) {
//                       // Aqui você pode formatar e preencher o campo
//                     }
//                   }
//                 : null,
//             decoration: InputDecoration(
//               hintText: hint,
//               filled: true,
//               isDense: true,
//               labelStyle: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: const Color(0xFF626262),
//               ),
//               border: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: AppColors.primaryColor, width: 1),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: AppColors.primaryColor, width: 1.0),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: AppColors.primaryColor, width: 1.0),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: AppColors.primaryColor, width: 1.0),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: AppColors.primaryColor, width: 1.0),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//             ),
//           ),

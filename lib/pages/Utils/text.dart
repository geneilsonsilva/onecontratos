import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText(
  String label, {
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
}) {
  return Text(
    label,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
  );
}

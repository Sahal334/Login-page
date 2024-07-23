import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildTextWidget extends StatefulWidget {
  final String text;
  final double Fontsize;
  final Color Fontcolor;
  final FontWeight? fontWeight;

  const BuildTextWidget(
      {super.key,
      required this.text,
      required this.Fontsize,
      required this.Fontcolor,
      this.fontWeight});

  @override
  State<BuildTextWidget> createState() => _BuildTextWidgetState();
}

class _BuildTextWidgetState extends State<BuildTextWidget> {
  @override
  Widget build(BuildTextWidget) {
    return Text(
      widget.text,
      style: GoogleFonts.pacifico(
        fontSize: widget.Fontsize,
        fontWeight: widget.fontWeight,
        color: widget.Fontcolor,
      ),
    );
  }
}

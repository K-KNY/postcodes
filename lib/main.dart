import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postcodes/screens/search_screen.dart';

void main() {
  runApp(const PostcodesApp());
}

class PostcodesApp extends StatelessWidget {
  const PostcodesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.lexend().fontFamily),
      title: 'Codis Postals',
      home: SearchScreen(),
    );
  }
}

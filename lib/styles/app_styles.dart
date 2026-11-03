import 'package:flutter/material.dart';

class AppStyles {
  // Paleta de colores
  static final Color primary = Colors.indigo;
  static final Color onPrimary = Colors.white;
  static final Color background = Colors.white;
  static final Color cardBackground = Colors.white;
  static final Color textSecondary = Colors.black54;
  static final Color errorColor = Colors.redAccent;

  // Estilos de texto
  static final TextStyle mainTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle bodyText = TextStyle(fontSize: 16);
  static final TextStyle infoText = TextStyle(
    fontSize: 16,
    color: textSecondary,
    fontStyle: FontStyle.italic,
  );

  // Separadores estándar
  static final Widget smallSeparator = SizedBox(height: 8, width: 8);
  static final Widget mediumSeparator = SizedBox(height: 16, width: 16);
  static final Widget bigSeparator = SizedBox(height: 24, width: 24);
}

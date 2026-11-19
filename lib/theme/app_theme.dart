import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de marca EKEKO — azul + verde, con soporte claro/oscuro.
class AppColors {
  AppColors._();

  // Marca
  static const Color primary = Color(0xFF1667A6);     // azul
  static const Color primaryDark = Color(0xFF0E456F);
  static const Color accent = Color(0xFF21A56B);       // verde
  static const Color accentDark = Color(0xFF17804F);
  static const Color success = Color(0xFF21A56B);
  static const Color info = Color(0xFF1667A6);
  static const Color warning = Color(0xFFE0A52B);
  static const Color danger = Color(0xFFD9534F);

  // Claro
  static const Color bg = Color(0xFFF3F7FA);
  static const Color bgAlt = Color(0xFFE9F1F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD9E4EC);
  static const Color textDark = Color(0xFF13222E);
  static const Color textMuted = Color(0xFF5F7484);

  // Oscuro
  static const Color dBg = Color(0xFF0D1620);
  static const Color dBgAlt = Color(0xFF13202B);
  static const Color dSurface = Color(0xFF16232F);
  static const Color dBorder = Color(0xFF263845);
  static const Color dTextDark = Color(0xFFE9F0F5);
  static const Color dTextMuted = Color(0xFF8DA2B1);

  /// Paleta de acentos por negocio (azules/verdes/teales).
  static const List<Color> palette = [
    Color(0xFF1667A6), // azul
    Color(0xFF21A56B), // verde
    Color(0xFF0E7C86), // teal
    Color(0xFF2E7DB5), // azul claro
    Color(0xFF158A5E), // verde bosque
    Color(0xFF155E75), // azul petróleo
  ];

  static Color forSeed(int seed) => palette[seed % palette.length];

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, primary, primaryDark],
  );

  /// Gradiente de dos tonos a partir de un color de marca.
  static LinearGradient coverGradient(Color c) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(c, Colors.white, 0.08)!,
          c,
          Color.lerp(c, Colors.black, 0.32)!,
        ],
      );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final isDark = b == Brightness.dark;
    final bg = isDark ? AppColors.dBg : AppColors.bg;
    final surface = isDark ? AppColors.dSurface : AppColors.surface;
    final border = isDark ? AppColors.dBorder : AppColors.border;
    final text = isDark ? AppColors.dTextDark : AppColors.textDark;
    final muted = isDark ? AppColors.dTextMuted : AppColors.textMuted;

    final base = ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: b,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: surface,
      ),
      scaffoldBackgroundColor: bg,
    );

    // Tipografía profesional: Plus Jakarta Sans (geométrica, moderna).
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(bodyColor: text, displayColor: text);

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(color: text, fontSize: 20, fontWeight: FontWeight.w800),
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 3,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.5 : 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: isDark ? AppColors.dBgAlt : AppColors.bgAlt,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(color: text, fontSize: 12.5),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontSize: 12.5),
        side: BorderSide(color: border),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      }),
      extensions: [EkekoColors(muted: muted, border: border, bgAlt: isDark ? AppColors.dBgAlt : AppColors.bgAlt)],
    );
  }
}

/// Colores auxiliares accesibles vía `Theme.of(context).extension`.
@immutable
class EkekoColors extends ThemeExtension<EkekoColors> {
  final Color muted;
  final Color border;
  final Color bgAlt;
  const EkekoColors({required this.muted, required this.border, required this.bgAlt});

  static EkekoColors of(BuildContext context) =>
      Theme.of(context).extension<EkekoColors>() ??
      const EkekoColors(muted: AppColors.textMuted, border: AppColors.border, bgAlt: AppColors.bgAlt);

  @override
  EkekoColors copyWith({Color? muted, Color? border, Color? bgAlt}) =>
      EkekoColors(muted: muted ?? this.muted, border: border ?? this.border, bgAlt: bgAlt ?? this.bgAlt);

  @override
  EkekoColors lerp(ThemeExtension<EkekoColors>? other, double t) {
    if (other is! EkekoColors) return this;
    return EkekoColors(
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      bgAlt: Color.lerp(bgAlt, other.bgAlt, t)!,
    );
  }
}

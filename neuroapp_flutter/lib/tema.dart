import 'package:flutter/material.dart';

// Paleta pensada para TEA: cores calmas, contraste adequado, sem excessos visuais
class AppTema {
  // Cor principal: azul calmo
  static const Color primaria = Color(0xFF3B6FD4);
  static const Color primariaClara = Color(0xFFD6E4FF);

  // Cor do perfil cuidador: verde acolhedor
  static const Color cuidador = Color(0xFF2E7D6B);
  static const Color cuidadorClara = Color(0xFFD0EDE8);

  // Neutros
  static const Color fundo = Color(0xFFF5F7FA);
  static const Color superficie = Color(0xFFFFFFFF);
  static const Color textoPrimario = Color(0xFF1A1A2E);
  static const Color textoSecundario = Color(0xFF6B7280);
  static const Color borda = Color(0xFFE5E7EB);

  // Feedback
  static const Color sucesso = Color(0xFF22C55E);
  static const Color erro = Color(0xFFEF4444);
  static const Color atencao = Color(0xFFF59E0B);

  static ThemeData get tema => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaria,
          brightness: Brightness.light,
          surface: superficie,
        ),
        scaffoldBackgroundColor: fundo,
        fontFamily: 'Roboto',

        // AppBar limpa, sem sombra
        appBarTheme: const AppBarTheme(
          backgroundColor: superficie,
          foregroundColor: textoPrimario,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textoPrimario,
          ),
        ),

        // Botões principais grandes e fáceis de tocar (acessibilidade)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaria,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Campos de texto com borda suave
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: superficie,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borda),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borda),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaria, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: erro),
          ),
        ),

        // Cards
        cardTheme: CardTheme(
          color: superficie,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: borda),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/symptom_provider.dart';
import 'screens/symptom_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SymptomProvider()..loadSymptoms(),
      child: MaterialApp(
        title: 'Symptom Tracker',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.baiJamjuree().fontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo.shade500,
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.indigo.shade500,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo.shade500,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
          ),
          cardTheme:  CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.teal.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
            ),
            labelStyle: TextStyle(color: Colors.teal.shade700),
          ),
        ),
        home: const SymptomListScreen(),
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:burrito/features/map/widgets/map_view.dart';
import 'package:burrito/theme/burro_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burrito tracker',
      theme: BurritoMobileTheme.theme,
      home: const BurritoMap(),
    );
  }
}

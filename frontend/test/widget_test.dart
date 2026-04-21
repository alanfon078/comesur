import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart'; // Asegúrate de que 'frontend' sea el nombre en tu pubspec.yaml

void main() {
  testWidgets('Smoke test para ComeSurApp', (WidgetTester tester) async {
    // Construye nuestra aplicación
    await tester.pumpWidget(const ComeSurApp());

    // Como la app inicia en _AuthSplash, verificamos que los elementos del Splash existan
    expect(find.text('COMESUR'), findsOneWidget);
    expect(find.byIcon(Icons.fastfood_rounded), findsOneWidget);

    // Verificamos que no exista un texto de contador (del template viejo de Flutter)
    expect(find.text('0'), findsNothing);
  });
}
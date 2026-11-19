import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ekeko_app/main.dart';

void main() {
  testWidgets('EKEKO arranca en el splash y navega al login', (WidgetTester tester) async {
    await tester.pumpWidget(const EkekoApp());

    expect(find.text('EKEKO'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Deja que el temporizador del splash se complete y navegue al login.
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_persistencia/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> abrir(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
  }

  void conferir(WidgetTester tester, bool escuro, double tamanho) {
    expect(find.text('Lorem ipsum'), findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      escuro,
    );
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      escuro ? ThemeMode.dark : ThemeMode.light,
    );
    expect(tester.widget<Slider>(find.byType(Slider)).value, tamanho);
    final previa = tester.widget<Text>(
      find.text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
    );
    expect(previa.style!.fontSize, tamanho);
  }

  testWidgets('inicia claro e 18; controles mudam apenas a prévia', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await abrir(tester);
    conferir(tester, false, 18);
    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, 14);
    expect(slider.max, 28);
    expect(slider.divisions, 7);
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    for (double tamanho = 14; tamanho <= 28; tamanho += 2) {
      tester.widget<Slider>(find.byType(Slider)).onChanged!(tamanho);
      await tester.pumpAndSettle();
      conferir(tester, true, tamanho);
    }
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), isEmpty);
    await abrir(tester);
    conferir(tester, false, 18);
  });

  testWidgets('1: salva tema escuro e fonte 24 e recupera ao reabrir', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await abrir(tester);
    await tester.tap(find.byType(SwitchListTile));
    tester.widget<Slider>(find.byType(Slider)).onChanged!(24);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar preferências'));
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('leitura.temaEscuro'), true);
    expect(prefs.getDouble('leitura.tamanhoFonte'), 24.0);
    await abrir(tester);
    conferir(tester, true, 24);
  });

  testWidgets('2: fonte 28 sem salvar mantém fonte 24 ao reabrir', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'leitura.temaEscuro': true,
      'leitura.tamanhoFonte': 24.0,
    });
    await abrir(tester);
    tester.widget<Slider>(find.byType(Slider)).onChanged!(28);
    await tester.pumpAndSettle();
    conferir(tester, true, 28);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getDouble('leitura.tamanhoFonte'), 24.0);
    await abrir(tester);
    conferir(tester, true, 24);
  });

  testWidgets('3: restaura claro e 18 sem remover outras preferências', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'leitura.temaEscuro': true,
      'leitura.tamanhoFonte': 24.0,
      'outroExercicio.nome': 'Ana',
    });
    await abrir(tester);
    await tester.tap(find.text('Restaurar padrão'));
    await tester.pumpAndSettle();
    conferir(tester, false, 18);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('leitura.temaEscuro'), false);
    expect(prefs.containsKey('leitura.tamanhoFonte'), false);
    expect(prefs.getString('outroExercicio.nome'), 'Ana');
    await abrir(tester);
    conferir(tester, false, 18);
  });
}

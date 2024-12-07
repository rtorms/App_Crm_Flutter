import 'package:crm_flutter/screens/Cadastro_cliente_screen.dart';
import 'package:crm_flutter/screens/Lista_cliente_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Exibe a lista de clientes carregada da API',
      (WidgetTester tester) async {
    // Configurar o widget no teste
    await tester.pumpWidget(
      MaterialApp(
        home: ClienteListScreen(),
      ),
    );

    // Verificar inicialmente se o texto 'Nenhum cliente encontrado' está visível
    expect(find.text('Nenhum cliente encontrado'), findsOneWidget);

    // Simular o carregamento de clientes
    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1)); // Simula tempo da API
    });
    await tester.pumpAndSettle(); // Espera o carregamento completar

    // Verificar se clientes estão visíveis
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('Campos de cadastro de cliente estão presentes',
      (WidgetTester tester) async {
    // Configurar o widget no teste
    await tester.pumpWidget(
      MaterialApp(
        home: CadastroClienteScreen(),
      ),
    );

    // Verificar se os campos de entrada estão presentes
    expect(find.byType(TextField), findsNWidgets(9)); // Espera 9 campos
    expect(find.text('Razão Social'), findsOneWidget);
    expect(find.text('Nome Fantasia'), findsOneWidget);
    expect(find.text('CPF/CNPJ'), findsOneWidget);
    expect(find.text('Telefone'), findsOneWidget);
    expect(find.text('CEP'), findsOneWidget);
    expect(find.text('Endereço'), findsOneWidget);
    expect(find.text('Bairro'), findsOneWidget);
    expect(find.text('Complemento'), findsOneWidget);
    expect(find.text('Cidade'), findsOneWidget);
  });

  testWidgets('Preenche formulário e salva cliente',
      (WidgetTester tester) async {
    // Configurar o widget no teste
    await tester.pumpWidget(
      MaterialApp(
        home: CadastroClienteScreen(),
      ),
    );

    // Preencher os campos de texto
    await tester.enterText(find.byType(TextField).at(0), 'Razão Social Teste');
    await tester.enterText(find.byType(TextField).at(1), 'Nome Fantasia Teste');
    await tester.enterText(
        find.byType(TextField).at(2), '12345678000195'); // CNPJ
    await tester.enterText(
        find.byType(TextField).at(3), '11999999999'); // Telefone
    await tester.enterText(find.byType(TextField).at(4), '12345678'); // CEP
    await tester.enterText(find.byType(TextField).at(5), 'Rua Teste');
    await tester.enterText(find.byType(TextField).at(6), 'Bairro Teste');
    await tester.enterText(find.byType(TextField).at(7), 'Complemento Teste');
    await tester.enterText(find.byType(TextField).at(8), 'Cidade Teste');

    // Verificar se o texto preenchido está correto
    expect(find.text('Razão Social Teste'), findsOneWidget);
    expect(find.text('Nome Fantasia Teste'), findsOneWidget);

    // Simular clique no botão de salvar
    await tester.tap(find.byKey(Key('ebSavarCliente')));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: ClienteListScreen(),
      ),
    );

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1)); // Simula tempo da API
    });
    await tester.pumpAndSettle(); // Espera o carregamento completar

    // Verifica novamente se clientes estão visíveis
    expect(find.byType(ListTile), findsWidgets);
  });
}

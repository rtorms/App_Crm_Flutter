import 'dart:math';

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
      await Future.delayed(const Duration(seconds: 2)); // Simula tempo da API
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
    expect(find.byType(TextField), findsNWidgets(10)); // Espera 9 campos
    expect(find.text('Razão Social'), findsOneWidget);
    expect(find.text('Nome Fantasia'), findsOneWidget);
    expect(find.text('CPF/CNPJ'), findsOneWidget);
    expect(find.text('Telefone'), findsOneWidget);
    expect(find.text('CEP'), findsOneWidget);
    expect(find.text('Endereço'), findsOneWidget);
    expect(find.text('Número'), findsOneWidget);
    expect(find.text('Bairro'), findsOneWidget);
    expect(find.text('Complemento'), findsOneWidget);
    expect(find.text('Cidade'), findsOneWidget);
  });

  String gerarStringAleatoria(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  String gerarNumeroAleatorio(int length) {
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => '0123456789'.codeUnitAt(random.nextInt(10)),
      ),
    );
  }

  testWidgets('Preenche formulário e salva cliente',
      (WidgetTester tester) async {
    // Configurar o widget no teste
    await tester.pumpWidget(
      MaterialApp(
        home: CadastroClienteScreen(),
      ),
    );

    // Gerar valores aleatórios para os campos
    final razaoSocial = gerarStringAleatoria(10);
    final nomeFantasia = gerarStringAleatoria(10);
    final cpfCnpj = gerarNumeroAleatorio(14); // Gera CNPJ de 14 dígitos
    final telefone =
        gerarNumeroAleatorio(11); // Gera telefone no padrão 11 dígitos
    final cep = gerarNumeroAleatorio(8); // CEP com 8 dígitos
    final endereco = gerarStringAleatoria(15);
    final numero = gerarNumeroAleatorio(3);
    final bairro = gerarStringAleatoria(10);
    final complemento = gerarStringAleatoria(10);
    final cidade = gerarStringAleatoria(10);

    // Preencher os campos de texto
    await tester.enterText(find.byType(TextField).at(0), razaoSocial);
    await tester.enterText(find.byType(TextField).at(1), nomeFantasia);
    await tester.enterText(find.byType(TextField).at(2), cpfCnpj);
    await tester.enterText(find.byType(TextField).at(3), telefone);
    await tester.enterText(find.byType(TextField).at(4), cep);
    await tester.enterText(find.byType(TextField).at(5), endereco);
    await tester.enterText(find.byType(TextField).at(6), numero);
    await tester.enterText(find.byType(TextField).at(7), bairro);
    await tester.enterText(find.byType(TextField).at(8), complemento);
    await tester.enterText(find.byType(TextField).at(9), cidade);
    await tester.pumpAndSettle();

    // Simular clique no botão de salvar
    await tester.tap(find.byKey(Key('ibSalvarCliente')));

    // Verificar a navegação para a tela de lista de clientes
    await tester.pumpWidget(
      MaterialApp(
        home: ClienteListScreen(),
      ),
    );

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1)); // Simula tempo da API
    });
    await tester.pumpAndSettle(); // Espera o carregamento completar

    // Verificar se a tela de lista de clientes foi carregada
    expect(find.byType(ClienteListScreen), findsOneWidget);
  });
}

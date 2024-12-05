import 'package:crm_flutter/screens/Lista_cliente_screen.dart';
import 'package:crm_flutter/screens/Lista_oportunidade_srcreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CrmApp());
}

class CrmApp extends StatelessWidget {
  const CrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRM FLUTTER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        primaryColor: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CRM ROBERTO'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Adiciona o logo estático
            const LogoWidget(),
            const SizedBox(height: 50), // Espaçamento entre o logo e os botões
            ElevatedButton(
              onPressed: () {
                // Navega para cliente
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClienteListScreen()),
                );
              },
              child: const Text('Clientes'),
            ),
            const SizedBox(height: 20), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Navega para oportunidades
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OportunidadeListScreen()),
                );
              },
              child: const Text('Oportunidades'),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/logo_utfpr.png',
          width: 150, // Tamanho do logo
          height: 150,
        ),
        const SizedBox(height: 10),
        const Text(
          'Bem-vindo ao CRM Roberto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

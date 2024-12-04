import 'package:flutter/services.dart';

class AgendaService {
  static const _channel = MethodChannel('crm_flutter_agenda');

  static Future<void> adicionarEvento({
    required String titulo,
    required String descricao,
    required DateTime inicio,
    required DateTime fim,
  }) async {
    try {
      await _channel.invokeMethod('adicionarEvento', {
        'titulo': titulo,
        'descricao': descricao,
        'inicio': inicio.toIso8601String(),
        'fim': fim.toIso8601String(),
      });
    } catch (e) {
      print('Erro ao adicionar evento: $e');
    }
  }
}

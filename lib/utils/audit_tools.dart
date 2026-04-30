import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AuditTools{
  static final AuditTools _instance = AuditTools._internal();
  factory AuditTools() => _instance;
  AuditTools._internal();

  Future<File> _gerarArquivoLog() async{
    final diretorio = await getApplicationDocumentsDirectory();
    final path = diretorio.path;

    final nomeArquivo = 'error_log_${DateTime.now().toString().split(' ')[0]}.txt';
    return File('$path/$nomeArquivo');
  }

  Future<void> salvarLogErro(dynamic error, StackTrace? stackTrace, {String? arquivoCodigo, String? funcao})async{
    try {
      final file = await _gerarArquivoLog();
      final timestamp = DateTime.now().toIso8601String();

      final logEntry = '''
              DATA: $timestamp
              ERRO: $error
              STACK TRACE:
              ${stackTrace ?? "Nenhum stacktrace disponível"}
              ------------------------------------------------
              ARQUIVO: ${arquivoCodigo ?? "Arquivo não informado."}
              FUNÇÃO: ${funcao ?? "Função não informada."}
              ''';

      await file.writeAsString(logEntry, mode: FileMode.append);

      log('Arquivo de log salvo em: ${file.path}');

    } catch (e) {
      log('Erro encontrado na auditoria. $e');
    }
  }
}
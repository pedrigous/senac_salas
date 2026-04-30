import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:senac_salas/telas/auth/auth_wrapper.dart';
import 'package:senac_salas/themes/tema.dart';
import 'package:senac_salas/utils/audit_tools.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  final globalScaffoldKey = GlobalKey<ScaffoldMessengerState> ();

  final audit = AuditTools();

  FlutterError.onError = (FlutterErrorDetails detalhes){
    FlutterError.presentError(detalhes);
    audit.salvarLogErro(detalhes.exception, detalhes.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack){
    audit.salvarLogErro(error, stack);
    return true;
  };

  runApp(MaterialApp(
    scaffoldMessengerKey: globalScaffoldKey,
    debugShowCheckedModeBanner: false,
    home: AuthWrapper(),
    theme: tema,
    locale: const Locale('pt', 'BR'),
    )
  );
}
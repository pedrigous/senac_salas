import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senac_salas/database/daos/cursos_dao.dart';
import 'package:senac_salas/database/daos/reservas_dao.dart';
import 'package:senac_salas/database/daos/salas_dao.dart';
import 'package:senac_salas/database/daos/usuarios_dao.dart';
import 'package:senac_salas/database/tables/tabelas.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Salas, Cursos, Reservas, Usuarios], daos: [UsuariosDao, SalasDao, CursosDao, ReservasDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal(): super(_openConnection());

  static final AppDatabase instance = AppDatabase._internal();

  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 1; //versão do esquema do banco de dados

  static QueryExecutor _openConnection(){
    return driftDatabase(
      name: 'senac_salas', 
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory),
      );
  }
}
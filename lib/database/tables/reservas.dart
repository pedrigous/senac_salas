import 'package:drift/drift.dart';
import 'package:senac_salas/database/tables/cursos.dart';
import 'package:senac_salas/database/tables/salas.dart';

class Reservas extends Table{
  IntColumn get idReserva => integer().autoIncrement()();
  IntColumn get idCurso => integer().references(Cursos, #id)();
  IntColumn get idSala => integer().references(Salas, #id)();
}
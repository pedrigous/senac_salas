import 'package:drift/drift.dart';

class Cursos extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeCurso => text()();
  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime()();
  TextColumn get turno => text()();
  TextColumn get professor => text()();
  TextColumn get codigoSIG => text().nullable()();
}
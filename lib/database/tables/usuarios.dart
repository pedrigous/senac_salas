import 'package:drift/drift.dart';

class Usuarios extends Table{
  IntColumn get idUsuario => integer().autoIncrement()();
  TextColumn get matricula => text().unique().nullable()();
  TextColumn get nome => text()();
  TextColumn get funcao => text()();
  TextColumn get senha => text()();
  TextColumn get email => text().unique().nullable()();
  TextColumn get celular => text().unique().nullable()();
  TextColumn get dicaSenha => text().nullable()();
  BoolColumn get logado => boolean().withDefault(const Constant(false))();

}
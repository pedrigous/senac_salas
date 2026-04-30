import 'package:drift/drift.dart';

class Salas extends Table{
  IntColumn get id => integer().autoIncrement()(); //id INTEGER AUTOINCREMENT
  TextColumn get nome => text()(); //nome TEXT
  TextColumn get numero => text()(); //numero TEXT
  IntColumn get capacidade => integer()(); //capacidade
  TextColumn get recursos => text()(); // recursos
  TextColumn get localizacao => text()(); // localizacao TEXT
  BoolColumn get disponivel => boolean().withDefault(const Constant(true))(); // disponivel INT (0 false, 1 true)
}
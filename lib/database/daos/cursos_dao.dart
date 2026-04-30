import 'package:drift/drift.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/tables/tabelas.dart' show Cursos;

part 'cursos_dao.g.dart';

@DriftAccessor(tables: [Cursos])
class CursosDao extends DatabaseAccessor<AppDatabase> with _$CursosDaoMixin{
  CursosDao(super.db);

Stream<List<Curso>> streamOfCursos() => select(cursos).watch();

Future<List<Curso>> get todosOsCursos => select(cursos).get();

  Future<List<Curso>> buscarCursosPeloNome({required String nome})async{
    return await (
      select(cursos)
      ..where((c) => c.nomeCurso.equals(nome))
    ).get();
  }

  Future<int> cadastrarNovoCurso(CursosCompanion curso)async{
    return await into(cursos).insert(curso);
  }

  Future<int> atualizarCurso({required int id, required CursosCompanion curso})async{
    return await (update(cursos)..where((c) => c.id.equals(id))).write(curso);
  }

  Future<int> removerCurso({required int id})async{
    return await (delete(cursos)..where((c) => c.id.equals(id))).go();
  }
}
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/tables/tabelas.dart' show Usuarios;

part 'usuarios_dao.g.dart';

@DriftAccessor(tables: [Usuarios])
class UsuariosDao extends DatabaseAccessor<AppDatabase>
    with _$UsuariosDaoMixin {
  UsuariosDao(super.db);

  Stream<Usuario?> streamUsuarioLogado(int id) {
    return (select(
      usuarios,
    )..where((u) => u.idUsuario.equals(id))).watchSingleOrNull();
  }

  Stream<Usuario?> get buscarUltimoUsuario =>
      (select(usuarios)
            ..where((u) => u.logado.equals(true))
            ..limit(1))
          .watchSingleOrNull();

  Future<Usuario?> get carregarUltimoUsuario =>
      (select(usuarios)
            ..where((u) => u.logado.equals(true))
            ..limit(1))
          .getSingleOrNull();

  Future<int> cadastrar(UsuariosCompanion usuario) {
    return into(usuarios).insert(usuario);
  }

  Future<Usuario?> login({required String login, required String senha}) async {
    log('Iniciando operação de login');

    return transaction(()async{
      log('Iniciando operação de transação');

      final query = select(usuarios)..where((u)=> u.email.equals(login) & u.senha.equals(senha));
      log('consulta: $query');

      Usuario? usuarioEncontrado = await query.getSingleOrNull();
      log('usuario encontrado: $usuarioEncontrado');

      if(usuarioEncontrado != null){
        final atualizarStatus = UsuariosCompanion(logado: Value(true));
        log('atualizarStatus: $atualizarStatus');

        await (update(usuarios)..where((u) => u.idUsuario.equals(usuarioEncontrado.idUsuario))).write(atualizarStatus);
        log('Atualizaçao concluida');

        return await (select(usuarios)..where((u)=> u.idUsuario.equals(usuarioEncontrado.idUsuario))).getSingle();
        }
        log('retorno nulo');
        return null;
      }
    );
  }
    

  Future<bool> atualizar(UsuariosCompanion usuario) {
    return update(usuarios).replace(usuario);
  }

  Future<bool> fazerLogout(Usuario usuario) async {
    final entidade = UsuariosCompanion(
      idUsuario: Value(usuario.idUsuario),
      nome: Value(usuario.nome),
      funcao: Value(usuario.funcao),
      senha: Value(usuario.senha),
      logado: Value(false),
      );

    bool result = await (update(usuarios)).replace(entidade);

    return result;
  }
}

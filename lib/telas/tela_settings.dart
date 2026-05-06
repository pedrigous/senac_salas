import 'dart:developer';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/daos/usuarios_dao.dart';
import 'package:senac_salas/telas/auth/auth_wrapper.dart';
import 'package:senac_salas/telas/tela_sobre.dart';

class TelaSettings extends StatefulWidget {
  const TelaSettings({super.key});

  @override
  State<TelaSettings> createState() => _TelaSettingsState();
}

class _TelaSettingsState extends State<TelaSettings> {
  final AppDatabase db = AppDatabase();
  late UsuariosDao usuarioDao = UsuariosDao(db);
  Usuario? user;

  void carregarUsuario() async {
    user = await usuarioDao.carregarUltimoUsuario;

    if (user == null) return;
  }

  void dialogoAlterarSenha(BuildContext context) async {
    user = await usuarioDao.carregarUltimoUsuario;

    if (user == null) return;

    showDialog(
      context: context,

      builder: (context) {
        final senhaCtrl = TextEditingController();
        final senhaRepetirCtrl = TextEditingController();

        ValueNotifier<bool> isValidoNotifier = ValueNotifier<bool>(false);
        ValueNotifier<bool> isVisivelNotifier = ValueNotifier<bool>(false);
        ValueNotifier<String?> erroNotifier = ValueNotifier<String?>(null);

        void validar() {
          final senha1 = senhaCtrl.text;
          final senhaR = senhaRepetirCtrl.text;

          if (senhaR.isEmpty) {
            erroNotifier.value = null;
            isValidoNotifier.value = false;
          } else if (senha1 != senhaR) {
            erroNotifier.value = "Senhas não se parecem";
            isValidoNotifier.value = false;
          } else {
            erroNotifier.value = null;
            isValidoNotifier.value = true;
          }
        }

        void exibir() => isVisivelNotifier.value = !isVisivelNotifier.value;

        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          backgroundColor: Colors.white,
          title: Text("Alterar senha"),
          content: ValueListenableBuilder(
            valueListenable: isVisivelNotifier,
            builder: (context, visivel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  TextField(
                    controller: senhaCtrl,
                    obscureText: !visivel,
                    decoration: InputDecoration(
                      labelText: "Nova senha",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: exibir,
                        icon: Icon(
                          (!visivel)
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                    ),
                    onChanged: (_) => validar(),
                  ),
                  ValueListenableBuilder(
                    valueListenable: erroNotifier,
                    builder: (context, erro, child) {
                      return TextField(
                        controller: senhaRepetirCtrl,
                        obscureText: !visivel,
                        decoration: InputDecoration(
                          labelText: "Confirmar senha",
                          prefixIcon: Icon(Icons.lock_outline),
                          errorText: erro,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.indigo,
                              width: 0.5,
                            ),
                          ),
                        ),
                        onChanged: (_) => validar(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ValueListenableBuilder(
              valueListenable: isValidoNotifier,
              builder: (context, isValido, child) {
                return Visibility(
                  visible: isValido,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () async {
                      if (user == null) {
                        return;
                      }

                      UsuariosCompanion usuario = UsuariosCompanion(
                        celular: drift.Value(user?.celular),
                        email: drift.Value(user?.email),
                        funcao: drift.Value(user!.funcao),
                        idUsuario: drift.Value(user!.idUsuario),
                        logado: drift.Value(user!.logado),
                        matricula: drift.Value(user?.matricula),
                        nome: drift.Value(user!.nome),
                        senha: drift.Value(senhaCtrl.text),
                      );

                      final result = await usuarioDao.atualizar(usuario);

                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Senha atualizada",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Falha na atualização da senha",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text("Confirmar"),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => carregarUsuario());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioFuture = usuarioDao.buscarUltimoUsuario;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Configurações")),
        body: StreamBuilder(
          stream: usuarioFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              log("Erro encontrado na tela Settings: ${snapshot.error}");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            Usuario? usuario = snapshot.data;

            if (usuario == null) {
              log("Usuário nulo");
              return Center(child: Text("Usuário Nulo"));
            }

            log("Usuário logado: ${usuario.nome}");

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaSobre()),
                      );
                    },
                    title: Text(
                      "Sobre",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Informações dos desenvolvedores."),
                    trailing: Icon(Icons.info_outline),
                  ),
                  ListTile(
                    onTap: () => dialogoAlterarSenha(context),
                    title: Text(
                      "Atualizar senha",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Altera as configurações de senha do usuário.",
                    ),
                    trailing: Icon(Icons.password, color: Colors.indigo),
                  ),
                  ListTile(
                    onTap: () async {
                      try {
                        final result = await usuarioDao.fazerLogout(usuario);
                        if (result) {
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthWrapper(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                        }
                        return;
                      } catch (e) {
                        log("Erro no logout: $e");
                      }
                    },
                    title: Text(
                      "Fazer logout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Encerra a sessão e sai da conta."),
                    trailing: Icon(Icons.logout, color: Colors.red),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

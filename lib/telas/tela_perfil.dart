import 'dart:developer';
import 'package:drift/drift.dart' as drift;
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/daos/usuarios_dao.dart';
import 'package:senac_salas/telas/tela_settings.dart';
import 'package:senac_salas/utils/validate_tools.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _formKey = GlobalKey<FormState>();
  AppDatabase db = AppDatabase();
  late UsuariosDao usuariosDao = UsuariosDao(db);
  ValidateTools validateTools = ValidateTools();

  bool editar = false;
  int? idUsuario;
  bool? logado;

  final nomeCtrl = TextEditingController();
  final matriculaCtrl = TextEditingController();
  final funcaoCtrl = TextEditingController();
  final celularCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  void ativarEdicao(bool value) => setState(() => editar = value);

  String? validarEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email inválido";
    }

    final bool emailValido = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);

    return emailValido ? null : "Insira um e-mail válido";
  }

  void atualizarDados() async {
    bool validado = validateTools.validarTextFields([
      nomeCtrl,
      matriculaCtrl,
      funcaoCtrl,
      celularCtrl,
      emailCtrl,
      senhaCtrl,
    ]);

    if (!validado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Dados inválidos. Preencha corretamente"),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    if (idUsuario == null) {
      log("id de usuário nulo");
      return;
    }

    if (logado == null) {
      log("status de login nulo");
      return;
    }

    UsuariosCompanion usuario = UsuariosCompanion(
      idUsuario: drift.Value(idUsuario!),
      nome: drift.Value(nomeCtrl.text),
      matricula: drift.Value(matriculaCtrl.text),
      funcao: drift.Value(funcaoCtrl.text),
      celular: drift.Value(celularCtrl.text),
      email: drift.Value(emailCtrl.text),
      senha: drift.Value(senhaCtrl.text),
      logado: drift.Value(logado!),
    );

    bool result = await usuariosDao.atualizar(usuario);

    if (!result) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Dados não atualizados!"),
            backgroundColor: Colors.amber,
          ),
        );
      }
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Dados atualizados."),
          backgroundColor: Colors.green,
        ),
      );
    }

    ativarEdicao(false);

    return;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usuariosDao = UsuariosDao(db);
      final usuario = await usuariosDao.carregarUltimoUsuario;

      if (usuario == null) {
        return;
      }
      logado = usuario.logado;
      idUsuario = usuario.idUsuario;
      nomeCtrl.text = usuario.nome;
      matriculaCtrl.text = usuario.matricula ?? "";
      funcaoCtrl.text = usuario.funcao;
      celularCtrl.text = usuario.celular ?? "";
      emailCtrl.text = usuario.email ?? "";
      senhaCtrl.text = usuario.senha;
    });
    super.initState();
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    matriculaCtrl.dispose();
    funcaoCtrl.dispose();
    celularCtrl.dispose();
    emailCtrl.dispose();
    senhaCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStream = usuariosDao.buscarUltimoUsuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () {
              ativarEdicao(!editar);
            },
            icon: Icon(editar ? Icons.close : Icons.edit),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => TelaSettings()));
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erro ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          Usuario? usuario = snapshot.data;

          if (usuario == null) {
            log('[Perfil] Usuário Nulo $usuario');
            return Center(child: Text("Usuário Nulo"));
          }

            log("[Perfil] Nome de usuário: ${usuario.nome}");

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  SizedBox(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 1.5,
                      color: Colors.white,
                      borderOnForeground: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.indigo, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.person),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    usuario.nome,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      overflow: TextOverflow.fade
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    usuario.funcao,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    usuario.matricula ?? "Sem número",
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    enabled: editar,
                    controller: nomeCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Adicione um nome corretamente";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hint: Text(usuario!.nome),
                      suffixIcon: Icon(Icons.abc),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    enabled: editar,
                    maxLength: 16,
                    controller: matriculaCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Adicione uma matrícula corretamente";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hint: Text('${usuario.matricula}'),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: Icon(Icons.numbers),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    enabled: editar,
                    controller: funcaoCtrl,
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Adicione uma função corretamente";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hint: Text(usuario.funcao),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: Icon(Icons.business_center),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    enabled: editar,
                    controller: celularCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Adicione um número de celular corretamente";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hint: Text(usuario.celular ?? 'Número de celular'),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: Icon(Icons.phone),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    enabled: editar,
                    controller: emailCtrl,
                    validator: validarEmail,
                    decoration: InputDecoration(
                      hint: Text(usuario.email ?? 'E-mail'),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: Icon(Icons.mail),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  if (editar)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            atualizarDados();
                          }
                        },
                        label: Text("Atualizar dados"),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

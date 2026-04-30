import 'package:flutter/material.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/daos/usuarios_dao.dart';
import 'package:senac_salas/telas/auth/autenticar.dart';
import 'package:senac_salas/telas/home.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    AppDatabase db = AppDatabase();
    UsuariosDao usuariosDao = UsuariosDao(db);

    Stream<Usuario?> futureUsuario = usuariosDao.buscarUltimoUsuario;

    return StreamBuilder(
      stream: futureUsuario,
      builder: (context, snapshot){
        if(snapshot.hasError){}
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(color: Colors.orange,),);
        }

        Usuario? user = snapshot.data;

        if(user != null){
          return Home();
        }
        return Autenticar();
      },
    );
  }
}
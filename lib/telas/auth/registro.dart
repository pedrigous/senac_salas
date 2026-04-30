import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/daos/usuarios_dao.dart';
import 'package:senac_salas/utils/validate_tools.dart';

class Registro extends StatefulWidget {

  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _matriculaCtrl = TextEditingController();
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _funcaoCtrl = TextEditingController();
  final TextEditingController _celularCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _senhaCtrl = TextEditingController();
  final TextEditingController _senhaConfirmarCtrl = TextEditingController();

  bool estaVisivel = false; //variável que identifica se o valor está visível ou não
  bool estaCadastrando = false;

  //função que altera o valor da variável estaVisivel(ela recebe a negação(!) dela mesma)
  void defineVisibilidade()=> setState(() => estaVisivel = !estaVisivel);

  void mudaStatusCadastro(bool value)=> setState(() => estaCadastrando = value);

  String _criptografarSenha(String senha){
    final bytes = utf8.encode(senha);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void fazerCadastro() async{
    AppDatabase db = AppDatabase();
    UsuariosDao usuariosDao = UsuariosDao(db);

    ValidateTools validate = ValidateTools();

    bool camposPreenchidos = validate.validarTextFields([
      _matriculaCtrl,
      _nomeCtrl,
      _funcaoCtrl,
      _emailCtrl,
      _celularCtrl,
      _senhaCtrl,
      _senhaConfirmarCtrl
    ]);

    log('${_senhaCtrl.text} | ${_matriculaCtrl.text} | ${_nomeCtrl.text} | ${_funcaoCtrl.text} | ${_emailCtrl.text} |${_celularCtrl.text} | ${_senhaConfirmarCtrl.text}');

    if (!camposPreenchidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Text(
            'Preencha todos os campos',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
      return;
    }

    String matricula = _matriculaCtrl.text.trim();
    String nome = _nomeCtrl.text.trim();
    String funcao = _funcaoCtrl.text.trim();
    String celular = _celularCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    String senha = _criptografarSenha(_senhaCtrl.text.trim());
    String senhaConfirmar = _criptografarSenha(_senhaConfirmarCtrl.text.trim());

    if(senha != senhaConfirmar){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Senhas não conferem', style: TextStyle(color: Colors.white)
          ),
        ),
      );
    }

    UsuariosCompanion usuario = UsuariosCompanion(
      matricula: d.Value(matricula),
      nome: d.Value(nome),
      funcao: d.Value(funcao),
      celular: d.Value(celular),
      email: d.Value(email),
      senha: d.Value(senha),
    );

    mudaStatusCadastro(true);

    try{
    int result = await usuariosDao.cadastrar(usuario);

    if(result > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Cadastrado com sucesso', style: TextStyle(color: Colors.white)
          ),
        ),
      );
    }
    mudaStatusCadastro(false);
    } catch (e) {
      log('Erro ao executar cadastro $e');

      mudaStatusCadastro(false);
    }
  }
  
  @override
  void dispose() {
    _matriculaCtrl.dispose();
    _nomeCtrl.dispose();
    _funcaoCtrl.dispose();
    _celularCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _senhaConfirmarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                'Criar Conta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.indigo,
                ),
              ),
              Text(
                'Gerenciador de Salas',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _matriculaCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.fingerprint, color: Colors.indigo),
                  labelText: 'Digite sua matrícula',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              TextField(
                controller: _nomeCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.person, color: Colors.indigo),
                  labelText: 'Digite seu nome',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              TextField(
                controller: _funcaoCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.work, color: Colors.indigo),
                  labelText: 'Digite sua função',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              TextField(
                controller: _emailCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.mail, color: Colors.indigo),
                  labelText: 'Digite seu e-mail',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              TextField(
                controller: _celularCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.mail, color: Colors.indigo),
                  labelText: 'Digite seu celular',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              TextField(
                controller: _senhaCtrl,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: estaVisivel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon:  Icon((estaVisivel) ? Icons.visibility : Icons.visibility_off,
                    color: Colors.indigo),
                    onPressed: defineVisibilidade,
                  ),
                  labelText: 'Digite sua senha',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              TextField(
                controller: _senhaConfirmarCtrl,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: estaVisivel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon:  Icon((estaVisivel) ? Icons.visibility : Icons.visibility_off,
                    color: Colors.indigo,),
                    onPressed: defineVisibilidade,
                  ),
                  labelText: 'Confirme sua senha',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  icon: (estaCadastrando) ?
                    SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white,),
                    )
                  : Icon(Icons.check, color: Colors.white,),
                    onPressed: fazerCadastro, 
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo)),
                    label: Text(
                      "Registro", 
                      style: TextStyle(color: Colors.white),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
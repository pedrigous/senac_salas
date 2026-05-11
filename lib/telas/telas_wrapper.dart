import 'package:flutter/material.dart';
import 'package:senac_salas/telas/cadastro_curso.dart';
import 'package:senac_salas/telas/cadastro_sala.dart';
import 'package:senac_salas/telas/tela_cursos.dart';
import 'package:senac_salas/telas/tela_reservas.dart';
import 'package:senac_salas/telas/tela_salas.dart';

class TelasWrapper extends StatefulWidget {
  const TelasWrapper({super.key});

  @override
  State<TelasWrapper> createState() => _TelasWrapperState();
}

class _TelasWrapperState extends State<TelasWrapper>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;

  List<Tab> tabs = [
    Tab(text: ('Salas')),
    Tab(text: ('Cursos')),
  ];

  List<Widget> pages = [TelaSalas(), TelaCursos()];

  void adicionarSala() => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CadastroSala()),
  );

  void adicionarCurso() => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CadastroCurso()),
  );

  @override
  void initState() {
    tabCtrl = TabController(length: pages.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                elevation: 0.0,
                title: Text("Senac Salas"),
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                actions: [
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: Icon(Icons.add),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'sala':
                          adicionarSala();
                          break;
                        case 'curso':
                          adicionarCurso();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'sala',
                          child: Text('Adicionar Sala'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'curso',
                          child: Text('Adicionar Curso'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: false,
                pinned: true,
                elevation: 0.0,
                title: TabBar(
                  tabs: tabs,
                  controller: tabCtrl,
                  isScrollable: true,
                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.indigo,
                  labelColor: Colors.indigo,
                  dividerColor: Colors.transparent,
                ),
              ),
            ];
          },
          body: TabBarView(controller: tabCtrl, children: pages),
        ),
      ),
    );
  }
}

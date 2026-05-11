import 'package:flutter/material.dart';
import 'package:senac_salas/custom/custom_card_curso.dart';
import 'package:senac_salas/custom/custom_label.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/database/daos/cursos_dao.dart';
import 'package:senac_salas/database/daos/reservas_dao.dart';
import 'package:senac_salas/database/daos/salas_dao.dart';
import 'package:senac_salas/telas/cadastro_reserva.dart';

class TelaCursos extends StatefulWidget {
  const TelaCursos({super.key});

  @override
  State<TelaCursos> createState() => _TelaCursosState();
}

class _TelaCursosState extends State<TelaCursos> {
  AppDatabase db = AppDatabase();
  late CursosDao cursosDao = CursosDao(db);
  late SalasDao salasDao = SalasDao(db);
  late ReservasDao reservasDao = ReservasDao(db);

  List<Sala> listOfSalasDisponiveis = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    super.initState();
  }

  void cadastrarReserva({required int idSala, required int idCurso}) async {
    ReservasCompanion reserva = ReservasCompanion.insert(
      idCurso: idCurso,
      idSala: idSala,
    );

    try {
      int result = await reservasDao.fazerReserva(reserva, idSala);

      if (result > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Reserva de sala efetuada com sucesso!"),
              backgroundColor: Colors.green,
              showCloseIcon: true,
            ),
          );
          return;
        }
        if (mounted) Navigator.pop(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Reserva de sala não efetuada."),
              backgroundColor: Colors.red,
              showCloseIcon: true,
            ),
          );
        }
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao efetuar reserva de sala!"),
            backgroundColor: Colors.redAccent,
            showCloseIcon: true,
          ),
        );
      }
    }
  }

  Future<void> removerCurso(Curso curso) async {
    int result = await cursosDao.removerCurso(id: curso.id);

    if (result > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Curso ${curso.nomeCurso} removido com sucesso.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Curso ${curso.nomeCurso} não removido!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> abrirDialogoRemover(Curso curso) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Remover?'),
          content: Text('Deseja remover o curso ${curso.nomeCurso}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async => removerCurso(curso),
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.red),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red, width: 0.5),
                  ),
                ),
              ),
              child: Text("Sim"),
            ),
          ],
        );
      },
    );
  }

  Future<void> abrirDialogoReserva(Curso curso) async {
    ValueNotifier<Sala?> salaNotifier = ValueNotifier(null);
    final listOfSalasDisponiveis = await salasDao.buscarSalasDisponiveis(disponibilidade: true);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Escolha a sala"),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.indigo, width: 0.5),
          ),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                CustomLabel(title: curso.nomeCurso, label: "Nome do curso"),
                CustomLabel(title: curso.professor, label: "Nome do professor"),
                CustomLabel(title: curso.turno, label: "Turno do curso"),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: (listOfSalasDisponiveis.isNotEmpty)
                      ? DropdownButtonHideUnderline(
                          child: ValueListenableBuilder(
                            valueListenable: salaNotifier,
                            builder: (context, value, child) {
                              return DropdownButton<Sala>(
                                value: value,
                                hint: Text("Selecione a sala"),
                                dropdownColor: Colors.white,
                                items: listOfSalasDisponiveis.map((Sala sala) {
                                  return DropdownMenuItem<Sala>(
                                    value: sala,
                                    child: Text(sala.nome),
                                  );
                                }).toList(),

                                onChanged: (sala) => salaNotifier.value = sala,
                              );
                            },
                          ),
                        )
                      : ListTile(
                          title: Text("Nenhuma sala disponível"),
                          subtitle: Text(
                            "Cadastre ou altere a disponibilidade uma sala",
                          ),
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            if(listOfSalasDisponiveis.isNotEmpty)
            ElevatedButton(
              onPressed: () async {
                if (salaNotifier.value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Selecione a sala",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.amber,
                    ),
                  );
                  return;
                }
                cadastrarReserva(
                  idSala: salaNotifier.value!.id,
                  idCurso: curso.id,
                );
              },
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.indigo, width: 0.5),
                  ),
                ),
              ),
              child: Text("Concluir reserva"),
            ),
          ],
        );
      },
    );
  }

  void abrirTelaReserva(BuildContext context, {required Curso curso}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CadastroReservas(curso: curso),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: cursosDao.streamOfCursos(),
          builder: (context, snapshot) {
            List<Curso> listOfCursos = snapshot.data ?? [];

            if (listOfCursos.isEmpty) {
              return Center(child: Text("Nenhum curso cadastrado no sistema"));
            }

            return ListView.builder(
              itemCount: listOfCursos.length,
              itemBuilder: (context, index) {
                final curso = listOfCursos[index];

                return CustomCardCurso(
                  curso: curso,
                  onReserve: () => abrirDialogoReserva(curso),
                  onDelete: () => abrirDialogoRemover(curso),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

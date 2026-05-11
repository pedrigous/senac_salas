// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:senac_salas/database/app_database.dart';
import 'package:senac_salas/utils/format_tools.dart';

class CustomCardCurso extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback onReserve;
  final Curso curso;

  const CustomCardCurso({
    super.key,
    required this.curso,
    required this.onDelete,
    required this.onReserve,
  });

  @override
  State<CustomCardCurso> createState() => _CustomCardCursoState();
}

class _CustomCardCursoState extends State<CustomCardCurso> {
  final FormatTools tools = FormatTools();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderOnForeground: true,
      elevation: 1.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.indigo, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  widget.curso.nomeCurso,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.fade,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              ],
            ),
            Text(widget.curso.professor),
            Text('Início: ${tools.converterDateTime(widget.curso.dataInicio)}'),
            Text('Conclusão: ${tools.converterDateTime(widget.curso.dataFim)}'),
            Text(widget.curso.turno),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: widget.onReserve,
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
                  child: Text("Reservar Sala"),
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

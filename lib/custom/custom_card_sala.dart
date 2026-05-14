// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:senac_salas/database/app_database.dart';

class CustomCardSala extends StatefulWidget {
  final Function(bool) onDisponivel;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final Sala sala;

  const CustomCardSala({
    super.key,
    required this.onDisponivel,
    required this.sala,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<CustomCardSala> createState() => _CustomCardSalaState();
}

class _CustomCardSalaState extends State<CustomCardSala> {
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
                  widget.sala.nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.fade,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton.filled(
                    color: (widget.sala.disponivel) ? Colors.green : Colors.red,
                    style: IconButton.styleFrom(
                      backgroundColor: (widget.sala.disponivel)
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    iconSize: 15,
                    onPressed: () =>
                        widget.onDisponivel(!widget.sala.disponivel),
                    icon: Icon(Icons.power_settings_new, color: Colors.white),
                  ),
                ),
              ],
            ),
            Text(widget.sala.numero),
            Text(widget.sala.localizacao),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("${widget.sala.capacidade} Alunos"),
                ElevatedButton(
                  onPressed: widget.onTap,
                  child: Text('Ver cursos'),
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

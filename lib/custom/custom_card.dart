// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapOpen;
  final VoidCallback? onTapShare;

  final String title;
  final String subtitle;
  final String? dataInicio;
  final String? dataFim;
  final String? turno;

  const CustomCard({
    super.key,
    this.onTapEdit,
    this.onTapDelete,
    this.onTapOpen,
    this.onTapShare,
    required this.title,
    required this.subtitle,
    this.dataInicio,
    this.dataFim,
    this.turno,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 17, vertical: 3),
      elevation: 1.5,
      borderOnForeground: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.indigo, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            if (dataInicio != null && dataFim != null)
              Text(
                '$dataInicio - $dataFim',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            if (turno != null)
              Text(
                '$turno',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (onTapOpen != null)
                  IconButton(
                    onPressed: onTapOpen,
                    icon: Icon(Icons.open_in_new, color: Colors.white,),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      hoverColor: Colors.amber.shade400,
                    ),
                  ),
                  if (onTapShare != null)
                  IconButton(
                    onPressed: onTapShare,
                    icon: Icon(Icons.share, color: Colors.white,),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      hoverColor: Colors.blue.shade400,
                    ),
                  ),
                if (onTapEdit != null)
                  IconButton(
                    onPressed: onTapEdit,
                    icon: Icon(Icons.edit, color: Colors.white,),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      hoverColor: Colors.blue.shade400,
                    ),
                  ),
                if (onTapDelete != null)
                  IconButton(
                    onPressed: onTapDelete,
                    icon: Icon(Icons.delete_outlined, color: Colors.white,),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      hoverColor: Colors.red.shade400,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

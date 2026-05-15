import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Sobre")),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              SizedBox(
                width: 200,
                child: Image.asset(
                  "assets/senac_logo.png",
                  alignment: AlignmentGeometry.center,
                  fit: BoxFit.cover,
                ),
              ),
              Divider(
                indent: 40,
                endIndent: 40,
                color: Colors.grey,),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'O aplicativo Senac Salas foi desenvolvido pela primeira turma do curso de Programador de Dispositivos Móveis do Senac Santarém, ministrado pelo instrutor Patrick Macedo.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'O aplicativo foi desenvolvido para facilitar a reserva de salas de aula da instituição, diminuindo o uso de papel. Durante o decorrer do curso, foram apresentadas ferramentas essenciais para a elaboração deste projeto.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
              Text(
                "Alunos",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/jonas.png'),
                          ),
                          Text("Jonas Felipe"),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/jose.webp'),
                          ),
                          Text("José Wanderley"),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/kaio.webp'),
                          ),
                          Text("Kaio Sousa"),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/logan.webp'),
                          ),
                          Text("Logan Camelo"),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/pedro.webp'),
                          ),
                          Text("Pedro Sousa"),
                        ],
                      ),
                    ],
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

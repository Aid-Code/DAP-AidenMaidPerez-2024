import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ArduinoUno extends StatelessWidget {
  static const name = 'ArduinoUno';
  String nombre;
  String precio;
  String imagen;

  ArduinoUno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Nombre segun el objeto",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
            itemCount: ,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(kits[index].nombre),
                subtitle: Text(kits[index].precio),
                leading: Image.network(kits[index].imagen),
                onTap: () {
                  if (kits[index].nombre == 'Arduino Uno') {
                    context.pushNamed(ArduinoUno.name);
                  }
                },
              ));
            }));
  }
}

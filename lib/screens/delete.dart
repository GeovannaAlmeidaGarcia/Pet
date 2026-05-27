import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaDelete extends StatefulWidget {
  const TelaDelete({super.key});

  @override
  State<TelaDelete> createState() => _TelaDeleteState();
}

class _TelaDeleteState extends State<TelaDelete> {
  List resultadoApi = [];

  @override
  void initState() {
    super.initState();
    fazerGet();
  }

  void fazerGet() async {
    final respostaServidor = await http.get(
      Uri.parse("https://api-prova-116j.onrender.com/tarefa"),
    );
    if (respostaServidor.statusCode == 200) {
      final dados = jsonDecode(respostaServidor.body);
      setState(() {
        resultadoApi = dados;
      });
    }
  }

 void fazerDelete(final id) async {
  final respostaServidor = await http.delete(
    Uri.parse("https://api-prova-116j.onrender.com/tarefa/$id"),
  );

  if (respostaServidor.statusCode == 200 ||
      respostaServidor.statusCode == 204) {
    fazerGet();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dado apagado com sucesso!!")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao deletar")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela para deletar tarefa")),
      body: ListView(
        children: [
          for(final item in resultadoApi)
          Card(
            child: ListTile(
              leading: Text(item["nome"]),
              trailing: TextButton(onPressed: ()=> fazerDelete(item["id"]), child: Icon(Icons.delete)),
            )
          ),
          Text("Chegou ao final da lista!")
        ],
      ),
    );
  }
}
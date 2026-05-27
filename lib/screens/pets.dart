import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaAnimais extends StatefulWidget {
  const TelaAnimais({super.key});

  @override
  State<TelaAnimais> createState() => _TelaAnimaisState();
}

class _TelaAnimaisState extends State<TelaAnimais> {
  List tarefas = [];

  @override
  void initState() {
    super.initState();
    buscarTarefas();
  }

  // 📡 SUA API
  Future<void> buscarTarefas() async {
    final response = await http.get(
      Uri.parse("https://api-prova-116j.onrender.com/tarefa"),
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      setState(() {
        tarefas = dados;
      });
    }
  }
  /* Se fosse em python esse if seria:
  if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      setState(() {
        tarefas = dados;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🐾 Rotina dos Pets"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: tarefas.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefas[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),

                      // 🐾 ÍCONE
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.pets,
                          color: Colors.deepPurple,
                        ),
                      ),

                      // 📄 NOME DA TAREFA
                      title: Text(
                        tarefa["nome"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      subtitle: const Text(
                        "Tarefa do seu pet 🐶",
                        style: TextStyle(color: Colors.grey),
                      ),

                      // 🔥 AÇÃO
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
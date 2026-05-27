import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaGet extends StatefulWidget {
  const TelaGet({super.key});

  @override
  State<TelaGet> createState() => _TelaGetState();
}

class _TelaGetState extends State<TelaGet> {

  List pets = [];
  List tarefas = [];

  @override
  void initState() {
    super.initState();
    carregarTudo();
  }

  Future<void> carregarTudo() async {
    await Future.wait([
      buscarPets(),
      buscarTarefas(),
    ]);
  }

  // 🐶 DOG API
  Future<void> buscarPets() async {
    final response = await http.get(
      Uri.parse("https://api.thedogapi.com/v1/images/search?limit=10"),
      headers: {
        "x-api-key": "live_IMDyLmRcLBM3UILLDuAA6OPwwntoOQFn1LZP9LIxzoZFAffQpOHYkWKqgmClVu7V"
      },
    );

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      setState(() {
        pets = dados;
      });
    }
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

  Future<void> atualizarFeed() async {
    await carregarTudo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🐾 Feed de Pets"),
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

        child: RefreshIndicator(
          onRefresh: atualizarFeed,

          child: ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {

              final pet = pets[index];
              final tarefa = tarefas.isNotEmpty
                  ? tarefas[index % tarefas.length]
                  : null;

              return Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🐶 IMAGEM
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        pet["url"],
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ❤️ AÇÕES
                          Row(
                            children: const [
                              Icon(Icons.favorite_border),
                              SizedBox(width: 10),
                              Icon(Icons.comment),
                              SizedBox(width: 10),
                              Icon(Icons.share),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // 📜 TAREFA
                          Text(
                            tarefa != null
                                ? "Tarefa: ${tarefa["nome"]}"
                                : "Sem tarefas",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // 🐾 TEXTO MOCK
                          const Text(
                            "Cuidando bem do seu pet todos os dias 🐶✨",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      // 🔄 BOTÃO FLUTUANTE
      floatingActionButton: FloatingActionButton(
        onPressed: atualizarFeed,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
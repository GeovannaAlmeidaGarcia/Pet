import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaPut extends StatefulWidget {
  const TelaPut({super.key});

  @override
  State<TelaPut> createState() => _TelaPutState();
}

class _TelaPutState extends State<TelaPut> {
  List<TextEditingController> controladores = [];
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

        // 🔥 evita duplicar controladores
        controladores = resultadoApi
            .map<TextEditingController>(
              (item) => TextEditingController(text: item["nome"]),
            )
            .toList();
      });
    }
    /* Se fosse em python esse if seria:
    response = requests.get("https://api-prova-116j.onrender.com/tarefa")

    if response.status_code == 200:
    dados = response.json()

    resultadoApi = dados

    # equivalente aos controladores
    controladores = [item["nome"] for item in resultadoApi]*/
  }

  void fazerPatch(final id, final index) async {
    final respostaServidor = await http.patch(
      Uri.parse("https://api-prova-116j.onrender.com/tarefa/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": controladores[index].text}),
    );

    if (respostaServidor.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tarefa atualizada com sucesso!")),
      );
    }

    fazerGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✏️ Editar Tarefas"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: resultadoApi.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: resultadoApi.length,
                itemBuilder: (context, index) {
                  final item = resultadoApi[index];

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
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 🐾 Nome atual
                          Row(
                            children: [
                              const Icon(Icons.pets, color: Colors.deepPurple),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item["nome"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ✏️ Campo de edição
                          TextField(
                            controller: controladores[index],
                            decoration: InputDecoration(
                              labelText: "Novo nome da tarefa",
                              prefixIcon: const Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 🔥 Botão atualizar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  fazerPatch(item["id"], index),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Atualizar"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
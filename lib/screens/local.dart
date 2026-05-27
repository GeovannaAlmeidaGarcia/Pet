import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaLocal extends StatefulWidget {
  const TelaLocal({super.key});

  @override
  State<TelaLocal> createState() => _TelaLocalState();
}

class _TelaLocalState extends State<TelaLocal> {
  List<String> itens = [];
  TextEditingController valorDigitado = TextEditingController();

  @override
  void initState() {
    super.initState();
    consultarDados();
  }

  void consultarDados() async {
    final banco = await SharedPreferences.getInstance();
    setState(() {
      itens = banco.getStringList("nomes") ?? [];
    });
  }

  void criarDado() async {
    if (valorDigitado.text.isEmpty) return;

    final banco = await SharedPreferences.getInstance();
    setState(() {
      itens.add(valorDigitado.text);
      valorDigitado.clear();
    });

    await banco.setStringList("nomes", itens);
  }

  void deletarDados(int index) async {
    final banco = await SharedPreferences.getInstance();
    setState(() {
      itens.removeAt(index);
    });

    await banco.setStringList("nomes", itens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados Locais"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔥 MESMO GRADIENTE DO APP
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔹 INPUT BONITO
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.deepPurple),
                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: valorDigitado,
                        decoration: const InputDecoration(
                          hintText: "Digite algo...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: criarDado,
                      icon: const Icon(Icons.add_circle, color: Colors.blue),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 LISTA
              Expanded(
                child: itens.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhum item salvo 😢",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: itens.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.pets,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                itens[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deletarDados(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
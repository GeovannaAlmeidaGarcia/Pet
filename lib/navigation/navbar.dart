import 'package:flutter/material.dart';
import 'package:prova/screens/delete.dart';
import 'package:prova/screens/get.dart';
import 'package:prova/screens/local.dart';
import 'package:prova/screens/post.dart';
import 'package:prova/screens/put.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int posicao_da_pagina = 0;

  final List<Widget> paginas = [
    const TelaGet(),
    const TelaPost(),
    const TelaDelete(),
    const TelaPut(),
    const TelaLocal()
  ];

  void mudar_posicao(int nova_posicao) {
    setState(() {
      posicao_da_pagina = nova_posicao;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paginas[posicao_da_pagina],

      // 🔥 NAVBAR ESTILIZADA
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB), // roxo
              Color(0xFF2575FC), // azul
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: posicao_da_pagina,
          onTap: mudar_posicao,
          type: BottomNavigationBarType.fixed,

          // 🔹 remove fundo padrão
          backgroundColor: Colors.transparent,
          elevation: 0,

          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),

          items: const [
            BottomNavigationBarItem(
              label: "Tarefas",
              icon: Icon(Icons.list_alt),
            ),
            BottomNavigationBarItem(
              label: "Criar",
              icon: Icon(Icons.add_circle),
            ),
            BottomNavigationBarItem(
              label: "Excluir",
              icon: Icon(Icons.delete),
            ),
            BottomNavigationBarItem(
              label: "Editar",
              icon: Icon(Icons.edit),
            ),
            BottomNavigationBarItem(
              label: "Local",
              icon: Icon(Icons.storage),
            ),
          ],
        ),
      ),
    );
  }
}
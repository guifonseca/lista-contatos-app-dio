import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listacontatosapp/model/contato_model.dart';
import 'package:listacontatosapp/pages/cadastro/cadastro_page.dart';
import 'package:listacontatosapp/repositories/contato_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ContatoRepository _contatoRepository;
  var _contatos = const <ContatoModel>[];

  @override
  void initState() {
    super.initState();
    initPage();
  }

  void initPage() async {
    _contatoRepository = await ContatoRepository.carregar();
    _contatos = _contatoRepository.listar();
    print(_contatos);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de contatos"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: _contatos.length,
        itemBuilder: (_, index) {
          final contatoModel = _contatos[index];
          return Card(
            child: ListTile(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroPage(
                            title: "Editar contato",
                            contatoModel: contatoModel),
                      )).then((value) => initPage());
                },
                leading: SizedBox(
                  width: 60,
                  height: 60,
                  child: Card(
                      color: Colors.grey.shade200,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5,
                      child: contatoModel.photoLocation == null
                          ? Icon(
                              Icons.people_alt,
                              size: 30,
                              color: Colors.grey.shade400,
                            )
                          : Image.file(
                              File(contatoModel.photoLocation!),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.people_alt,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                            )),
                ),
                title: Text(contatoModel.nome),
                subtitle: Text(contatoModel.telefone)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroPage(title: "Novo contato"),
            )).then((value) => initPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

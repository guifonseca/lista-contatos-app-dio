import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:listacontatosapp/model/contato_model.dart';
import 'package:listacontatosapp/repositories/contato_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CadastroPage extends StatefulWidget {
  final String title;
  final ContatoModel? contatoModel;

  const CadastroPage({super.key, this.contatoModel, required this.title});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  XFile? _photo;

  late ContatoRepository _contatoRepository;

  final nomeController = TextEditingController(text: "");
  final telefoneController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  final dtNascimentoController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    initPage();
  }

  void initPage() async {
    nomeController.text = widget.contatoModel?.nome ?? "";
    telefoneController.text = widget.contatoModel?.telefone ?? "";
    emailController.text = widget.contatoModel?.email ?? "";
    if (widget.contatoModel?.photoLocation != null) {
      _photo = XFile(widget.contatoModel!.photoLocation!);
    }
    if (widget.contatoModel?.dataNascimento != null) {
      dtNascimentoController.text =
          DateFormat("dd/MM/yyyy").format(widget.contatoModel!.dataNascimento!);
    }
    _contatoRepository = await ContatoRepository.carregar();
    setState(() {});
  }

  void cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      _photo = XFile(croppedFile.path);
      setState(() {});
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate;

    if (dtNascimentoController.text.isNotEmpty) {
      selectedDate =
          DateFormat("dd/MM/yyyy").parse(dtNascimentoController.text);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      dtNascimentoController.text = DateFormat("dd/MM/yyyy").format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.contatoModel != null)
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (bc) => AlertDialog(
                      titleTextStyle:
                          const TextStyle(fontSize: 18, color: Colors.black),
                      title: const Text("Alerta de exclusão"),
                      content: const Text("Confirma a exclusão do contato?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(bc),
                            child: const Text("Cancelar")),
                        TextButton(
                            onPressed: () async {
                              await _contatoRepository
                                  .excluir(widget.contatoModel!);
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                Navigator.pop(bc);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.green.shade400,
                                        content: const Text(
                                            "Contato excluído com sucesso.")));
                              });
                            },
                            child: const Text("Confirmar"))
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_camera_rounded),
                          title: const Text("Câmera"),
                          onTap: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                              () => Navigator.pop(context),
                            );
                            final ImagePicker picker = ImagePicker();
                            _photo = await picker.pickImage(
                                source: ImageSource.camera);
                            if (_photo != null) {
                              String path = (await path_provider
                                      .getApplicationDocumentsDirectory())
                                  .path;
                              await _photo!.saveTo("$path/${_photo!.name}");
                              cropImage(_photo!);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image_rounded),
                          title: const Text("Galeria"),
                          onTap: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                              () => Navigator.pop(context),
                            );
                            final ImagePicker picker = ImagePicker();
                            _photo = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (_photo != null) {
                              cropImage(_photo!);
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: SizedBox(
                height: 160,
                child: Card(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    child: _photo == null
                        ? Icon(
                            Icons.people_alt,
                            size: 60,
                            color: Colors.grey.shade400,
                          )
                        : Image.file(
                            File(_photo!.path),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.people_alt,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          )),
              )),
          const SizedBox(
            height: 25,
          ),
          const Text("Nome"),
          TextField(
            controller: nomeController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Telefone"),
          TextField(
            controller: telefoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter()
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("E-mail"),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Data de Nascimento"),
          GestureDetector(
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter()
              ],
              controller: dtNascimentoController,
              decoration: InputDecoration(
                suffixIcon: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: const Icon(
                      Icons.calendar_month,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              height: 50,
              child: FilledButton(
                  onPressed: () async {
                    final contatoModel = widget.contatoModel ??
                        ContatoModel.novo(UniqueKey().toString());

                    String msgError = "";
                    if (nomeController.text.isEmpty) {
                      msgError = "O nome deve ser preenchido";
                    } else if (telefoneController.text
                            .replaceAll(RegExp(r'[^0-9]'), "")
                            .length <
                        8) {
                      msgError = "O telefone deve ser preenchido";
                    } else if (!EmailValidator.validate(emailController.text)) {
                      msgError = "E-mail inválido";
                    }

                    if (msgError.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(msgError)));
                      return;
                    }

                    contatoModel.nome = nomeController.text;
                    contatoModel.telefone = telefoneController.text;
                    contatoModel.email = emailController.text;
                    contatoModel.photoLocation = _photo?.path;
                    if (dtNascimentoController.text.isNotEmpty) {
                      contatoModel.dataNascimento = DateFormat("dd/MM/yyyy")
                          .parse(dtNascimentoController.text);
                    }

                    if (widget.contatoModel == null) {
                      await _contatoRepository.salvar(contatoModel);
                    } else {
                      await _contatoRepository.atualizar(contatoModel);
                    }

                    await Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green.shade400,
                            content: const Text("Contato salvo com sucesso.")));
                      },
                    );
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )))
        ],
      ),
    );
  }
}

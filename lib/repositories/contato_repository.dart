import 'package:hive/hive.dart';
import 'package:listacontatosapp/model/contato_model.dart';

class ContatoRepository {
  static late Box _box;

  ContatoRepository._criar();

  static Future<ContatoRepository> carregar() async {
    if (Hive.isBoxOpen('contatoHiveModel')) {
      _box = Hive.box('contatoHiveModel');
    } else {
      _box = await Hive.openBox('contatoHiveModel');
    }
    return ContatoRepository._criar();
  }

  Future<void> salvar(ContatoModel contatoModel) async {
    await _box.add(contatoModel);
  }

  Future<void> atualizar(ContatoModel contatoModel) async {
    await contatoModel.save();
  }

  Future<void> excluir(ContatoModel contatoModel) async {
    await contatoModel.delete();
  }

  List<ContatoModel> listar() {
    return _box.values.cast<ContatoModel>().toList();
  }
}

import 'package:hive/hive.dart';

part 'contato_model.g.dart';

@HiveType(typeId: 0)
class ContatoModel extends HiveObject {
  @HiveField(0)
  late String _id;
  @HiveField(1)
  late String _nome;
  @HiveField(2)
  late String _telefone;
  @HiveField(3)
  late String _email;
  @HiveField(4)
  late DateTime? _dataNascimento;
  @HiveField(5)
  late String? _photoLocation;

  ContatoModel();

  ContatoModel.novo(String id) {
    _id = id;
    _dataNascimento = null;
    _photoLocation = null;
  }

  String get id => _id;
  set id(String value) => _id = value;

  String get nome => _nome;
  set nome(String value) => _nome = value;

  String get telefone => _telefone;
  set telefone(String value) => _telefone = value;

  String get email => _email;
  set email(String value) => _email = value;

  DateTime? get dataNascimento => _dataNascimento;
  set dataNascimento(DateTime? value) => _dataNascimento = value;

  String? get photoLocation => _photoLocation;
  set photoLocation(String? value) => _photoLocation = value;
}

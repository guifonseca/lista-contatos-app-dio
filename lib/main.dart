import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:listacontatosapp/model/contato_model.dart';
import 'package:listacontatosapp/pages/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);
  Hive.registerAdapter(ContatoModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de contatos',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale("pt")],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
            color: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
            iconTheme: IconThemeData(color: Colors.white)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(backgroundColor: Colors.blue)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

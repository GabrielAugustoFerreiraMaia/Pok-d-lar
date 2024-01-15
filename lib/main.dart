import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double dolarValue = 0.0;
  int pokemonNumber = 0;

  @override
  void initState() {
    super.initState();
    fetchDolarValue();
  }

  Future<void> fetchDolarValue() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dolarValue = data['rates']['BRL'];
          convertToPokemon();
        });
      } else {
        showErrorSnackBar('Erro ao obter a cotação do dólar');
      }
    } catch (e) {
      showErrorSnackBar('Erro inesperado');
    }
  }

  void convertToPokemon() {
    setState(() {
      pokemonNumber = (dolarValue * 100).round() % 1015;
    });
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotação do Dólar e Pokémon'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cotação do Dólar: \$${dolarValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png',
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Pokémon Correspondente: #$pokemonNumber',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

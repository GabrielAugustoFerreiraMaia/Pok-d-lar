import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    final response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        dolarValue = data['rates']['BRL'];
        convertToPokemon();
      });
    } else {
      throw Exception('Erro ao obter a cotação do dólar');
    }
  }

  void convertToPokemon() {
    setState(() {
      pokemonNumber = (dolarValue * 100).round() %
          1015; //1015 número aproximado de Pokémon hoje.
    });
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

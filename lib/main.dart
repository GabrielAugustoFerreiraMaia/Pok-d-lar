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
  String pokemonName = '';

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

  Future<void> convertToPokemon() async {
    setState(() {
      pokemonNumber = (dolarValue * 100).round() % 1015;
    });

    // Pega o nome do Pokémon correspondente ao número
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonNumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rawName = data['name'] as String;
      final formattedName = rawName[0].toUpperCase() + rawName.substring(1);
      setState(() {
        pokemonName = formattedName;
      });
    } else {
      showErrorSnackBar('Erro ao carregar o nome do Pokémon');
    }
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
        title: Text('PokeDólar'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://wallpapercave.com/wp/wp3170171.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Cotação do Dólar: \$${dolarValue.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                pokemonName.isNotEmpty
                    ? 'Pokémon: $pokemonName'
                    : 'Carregando...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Número: #$pokemonNumber',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

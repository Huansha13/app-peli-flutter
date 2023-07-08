import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app-pelicula',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovieCatalogPage(title: 'Catalogo Pelicula'),
    );
  }
}

class MovieCatalogPage extends StatefulWidget {
  const MovieCatalogPage({super.key, required this.title});
  final String title;

  @override
  State<MovieCatalogPage> createState() => _MovieCatalogPageState();
}

class _MovieCatalogPageState extends State<MovieCatalogPage> {
  List<dynamic> movies = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchMovies(String query) async {
    const apiKey = 'da5a97fd'; // Reemplaza con tu clave de API de OMDb
    final response = await http.get(Uri.parse('http://www.omdbapi.com/?s=$query&apikey=$apiKey'));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        movies = responseData['Search'];
      });
    } else {
      print('Failed to fetch movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar película',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    fetchMovies(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];
                return ListTile(
                  leading: Image.network(movie['Poster']),
                  title: Text(movie['Title']),
                  subtitle: Text(movie['Year']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

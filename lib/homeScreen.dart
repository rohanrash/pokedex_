import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  String type = '';
  String description = '';
  String imageUrl = '';
  int id = 0;
  var users;

  void fetchPoki(String pokemon) async {
    print('fetchPoki called');
    var url = 'https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/pokedex.php?pokemon=$pokemon';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      setState(() {
        name = json['name'] ?? '';
        type = json['info']['type'] ?? '';
        description = json['info']['description'] ?? '';
        id = json['info']['id'] ?? 0;
        imageUrl = json['images']['photo'] ?? '';
      });
      print('fetchPoki completed. ID: $id, Name: $name, Type: $type, Description: $description, Image URL: $imageUrl');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'POKEDOX',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  fetchPoki(value.trim());
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (id != 0) Text('ID: $id', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (name.isNotEmpty) Text('Name: $name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (type.isNotEmpty) Text('Type: $type', style: TextStyle(color: Colors.black)),
                      if (description.isNotEmpty) SizedBox(height: 20),
                      if (description.isNotEmpty) Text('Description: $description', style: TextStyle(color: Colors.black)),
                      if (imageUrl.isNotEmpty) Image.network(imageUrl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }}

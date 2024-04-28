import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tp_election/pages/candidates.dart';
import 'package:tp_election/pages/showelect.dart';

class AddElectPage extends StatefulWidget {
  final Function(Candidate) addCandidate;

  const AddElectPage({required this.addCandidate, Key? key}) : super(key: key);


  @override
  _AddElectPageState createState() => _AddElectPageState();
}

class _AddElectPageState extends State<AddElectPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _party = '';
  String _bio = '';
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print("Formulaire valide. Soumission en cours...");
      _formKey.currentState!.save();
      print("Données du formulaire sauvegardées :");
      print("_name: $_name");
      print("_surname: $_surname");
      print("_party: $_party");
      print("_bio: $_bio");


      final createdCandidate = Candidate(
        id: 1,
        name: _name,
        surname: _surname,
        party: _party,
        bio: _bio,
        imageUrl: _image!.path,
      );

      final requestBody = jsonEncode({
        "userId": 1,
        // Remplacez par l'ID de l'utilisateur approprié
        "id": 0,
        // L'ID sera attribué par le serveur
        "title": "$_name $_surname",
        // Utilisez les champs name et surname pour le titre
        "body": "$_party $_bio",
        // Utilisez les champs party et bio pour le corps
      });

      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

     /* if (response.statusCode >=200 && response.statusCode <= 299) {
        print("Données soumises avec succès !");
        final responseBody = response.body;
       // final createdCandidate = Candidate.fromJson(json.decode(responseBody));
        widget.addCandidate(createdCandidate);
        Navigator.pop(context);
        // Navigation vers la page ShowElectPage avec les données du formulaire
        Navigator.push(
          context,
          MaterialPageRoute(

            builder: (context) => ShowElectPage(
                candidates: [_name, _surname, _party, _bio, _image?.path ?? ''],
            ),
          ),
        );
      } else {
        print(
            "Erreur lors de la soumission des données au serveur. Code de statut: ${response
                .statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add candidate')),
        );
      }*/
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print("Données soumises avec succès !");
        widget.addCandidate(createdCandidate);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowElectPage(candidates: [createdCandidate]),
          ),
        );
      } else {
        print("Erreur lors de la soumission des données au serveur. Code de statut: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add candidate')),
        );
      }
    } else {
      print("Formulaire invalide. Impossible de soumettre les données.");
    }

  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Scaffold scaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Candidate'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
// Candidate image
                GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? const Icon(Icons.camera_alt) : null,
                  ),
                ),
// Name
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
// Surname
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Surname'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a surname';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _surname = value!;
                  },
                ),
// Party
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Party'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a party';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _party = value!;
                  },
                ),
// Bio
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Biography'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a biography';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _bio = value!;
                  },
                ),
// Add button
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tp_election/pages/candidates.dart';
import 'addelected.dart';

class ShowElectPage extends StatefulWidget {
  final List<Candidate> candidates;

  const ShowElectPage({required this.candidates, Key? key}) : super(key: key);

  @override
  _ShowElectPageState createState() => _ShowElectPageState();
}

class _ShowElectPageState extends State<ShowElectPage> {
  int _selectedIndex = 0;
  List<Candidate> _candidates = [];

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    print("les candidates sont recue dans le show elected");
    // Utilisez les données reçues depuis la page précédente
    final List<Candidate> previousCandidates = widget.candidates.map((candidateData) {
      print(candidateData);

     // final List<String> candidateData = data.split(',');
      print("id: $candidateData[0]");
      print("_name: $candidateData[1]");
      print("_surname: $candidateData[2]");
      print("_party: $candidateData[3]");
      print("_bio: $candidateData[4]");
      print("image: $candidateData[5]");
      return Candidate(
        id: 1,//int.parse(candidateData[0]),
        name: candidateData.name,
        surname: candidateData.surname,
        party: candidateData.party,
        bio: candidateData.bio,
        imageUrl: candidateData.imageUrl,
      );
    }).toList();

    setState(() {
      _candidates = previousCandidates;
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addCandidate(Candidate candidate) async {
    setState(() {
      _candidates.add(candidate);
    });
    //await _uploadCandidate(candidate);
    // Recharge les données après avoir ajouté un nouveau candidat
    await _fetchCandidates();
  }

  // Future<void> _uploadCandidate(Candidate candidate) async {
  //   final response = await http.post(
  //     Uri.parse('https://jsonplaceholder.typicode.com'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(candidate.toJson()),
  //   );
  //
  //   // if  (false)  {
  //   //   print(response.statusCode);
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(content: Text('Failed to add candidate')),
  //   //   );
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Samiat'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            // Horizontal navigation bar
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildNavigationButton('Presidential'),
                  _buildNavigationButton('Governship'),
                  _buildNavigationButton('LGDA'),
                ],
              ),
            ),
            // Candidates
            Expanded(
              child: ListView.builder(
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  return Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: candidate.imageUrl.isNotEmpty
                            ? NetworkImage(candidate.imageUrl)
                            : null,
                      ),
                      title: Text('${candidate.name} ${candidate.surname}'),
                      subtitle: Text(candidate.party),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddElectPage(
                addCandidate: (candidate) => _addCandidate(candidate),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Candidates: ${_candidates.length}'),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(title),
      ),
    );
  }
}

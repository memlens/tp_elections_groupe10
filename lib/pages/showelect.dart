import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tp_election/pages/candidates.dart';
import 'addelected.dart';

class ShowElectPage extends StatefulWidget {
  final List<String> candidates;

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
    // Utilisez les données reçues depuis la page précédente
    final List<Candidate> previousCandidates = widget.candidates.map((data) {
      final List<String> candidateData = data.split(',');
      return Candidate(
        id: int.parse(candidateData[0]),
        name: candidateData[1],
        surname: candidateData[2],
        party: candidateData[3],
        bio: candidateData[3],
        imageUrl: candidateData[4],
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
    await _uploadCandidate(candidate);
    // Recharge les données après avoir ajouté un nouveau candidat
    await _fetchCandidates();
  }

  Future<void> _uploadCandidate(Candidate candidate) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(candidate.toJson()),
    );

    if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add candidate')),
      );
    }
  }

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

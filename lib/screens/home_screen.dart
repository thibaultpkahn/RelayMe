import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/home_controller.dart';
import 'contact_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = HomeController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Share Contacts"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barre de recherche + bouton +
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[900],
                      hintText: "Recherche",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => controller.showPopupMenu(context,setState),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Liste des catégories avec contacts en horizontal
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('contacts').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Aucun contact trouvé", style: TextStyle(color: Colors.white)));
                  }

                  // Regrouper les contacts par catégorie
                  Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> categoriesMap = {};
                  for (var doc in snapshot.data!.docs) {
                    String category = doc['category'] ?? "Sans catégorie";
                    if (!categoriesMap.containsKey(category)) {
                      categoriesMap[category] = [];
                    }
                    categoriesMap[category]!.add(doc);
                  }

                  // Liste verticale des catégories
                  return ListView.builder(
                    itemCount: categoriesMap.keys.length,
                    itemBuilder: (context, index) {
                      String category = categoriesMap.keys.elementAt(index);
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = categoriesMap[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre de la catégorie
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            child: Text(
                              category,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),

                          // Liste horizontale des contacts de la catégorie
                          SizedBox(
                            height: 120, // Hauteur des cartes
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal, // Défilement horizontal
                              itemCount: contacts.length,
                              itemBuilder: (context, contactIndex) {
                                var contact = contacts[contactIndex];

                                return ContactCard(
                                  firstName: contact['firstName'],
                                  lastName: contact['lastName'],
                                  job: contact['job'],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactDetailScreen(contact: contact),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Carte de contact
class ContactCard extends StatelessWidget {
  final String firstName, lastName, job;
  final VoidCallback onTap;

  const ContactCard({
    required this.firstName,
    required this.lastName,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 160, // Largeur des cartes
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$firstName $lastName",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(job, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

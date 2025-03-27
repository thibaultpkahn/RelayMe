import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relay_me/models/contact_model.dart';
import 'package:relay_me/theme/colors.dart';
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar( 
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Contacts", 
            style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold, fontSize: 25)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center, // Centre du gradient
            radius: 1.0, // Étendue du gradient (ajuste selon l'effet désiré)
            colors: [
              Colors.black,
              Color(0xFF0D1B2A),
            ],
            stops: [0.0, 1.0], // Transition entre les couleurs
          ),
        ),
        child: SafeArea( // Ajout de SafeArea pour respecter la barre de statut
          child:Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Barre de recherche + bouton +
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: AppColors.blackText),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.primary,
                          hintText: "Recherche",
                          hintStyle: const TextStyle(color: AppColors.blackText, fontWeight: FontWeight.bold),
                          suffixIcon: const Icon(Icons.search, color: AppColors.blackText),
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
                      backgroundColor: AppColors.primary,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Liste des catégories avec contacts en horizontal
                                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> categorySnapshot) {
                      if (categorySnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!categorySnapshot.hasData || categorySnapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("Aucune catégorie trouvée", style: TextStyle(color: Colors.white)));
                      }

                      // Liste des catégories depuis Firestore
                      List<String> categoryList = categorySnapshot.data!.docs.map((doc) => doc['name'] as String).toList();

                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('contacts').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> contactSnapshot) {
                          if (contactSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          // Regrouper les contacts par catégorie
                          Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> contactsByCategory = {};
                          for (var doc in contactSnapshot.data!.docs) {
                            String category = doc['category'] ?? "Sans catégorie";
                            if (!contactsByCategory.containsKey(category)) {
                              contactsByCategory[category] = [];
                            }
                            contactsByCategory[category]!.add(doc);
                          }

                          return ListView.builder(
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              String category = categoryList[index];
                              List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = contactsByCategory[category] ?? [];

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

                                  // Liste horizontale des contacts de la catégorie (ou message si vide)
                                  SizedBox(
                                    height: 120,
                                    child: contacts.isNotEmpty
                                        ? ListView.builder(
                                            scrollDirection: Axis.horizontal,
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
                                          )
                                        : Center(
                                            child: Text("Aucun contact", style: TextStyle(color: Colors.grey[400])),
                                          ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
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
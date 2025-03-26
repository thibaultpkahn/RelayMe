import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relay_me/controllers/home_controller.dart';
import 'package:relay_me/screens/AuthorizationRequestScreen.dart';
import 'package:relay_me/theme/colors.dart';

class ContactDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Détail du contact",
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity, // Étend le gradient sur toute la hauteur
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Colors.black,
              Color(0xFF0D1B2A),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Cadre bleu autour du contact et des actions
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary, // Bordure bleue
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nom et catégorie sur la même ligne
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${contact["firstName"]} ${contact["lastName"]}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteText,
                              ),
                            ),
                            Chip(
                              label: Text(
                                contact["category"],
                                style: const TextStyle(color: AppColors.primary),
                              ),
                              backgroundColor: Color(0xFF021024),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Métier
                        Text(
                          contact["job"],
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.whiteText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Numéro de téléphone
                        Text(
                          "📞 ${contact["phone"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.whiteText,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Section Actions
                        const Text(
                          "Actions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            ActionButton(
                              label: "Demander l'autorisation",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AuthorizationRequestScreen(
                                      contactName:
                                          "${contact["firstName"]} ${contact["lastName"]}",
                                      job: contact["job"],
                                      category: contact["category"],
                                      initialMessage: contact["requestMessage"],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            ActionButton(
                              label: "Prévenir sur le partage",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AuthorizationRequestScreen(
                                      contactName:
                                          "${contact["firstName"]} ${contact["lastName"]}",
                                      job: contact["job"],
                                      category: contact["category"],
                                      initialMessage: contact["sendMessage"],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            ActionButton(
                              label: "Partager ce contact",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AuthorizationRequestScreen(
                                      contactName:
                                          "${contact["firstName"]} ${contact["lastName"]}",
                                      job: contact["job"],
                                      category: contact["category"],
                                      initialMessage: contact["notifyMessage"],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bouton d'édition
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.primary,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.edit, color: AppColors.blackText),
                      onPressed: () {
                        // Action d'édition (à implémenter plus tard)
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ActionButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.blackText,
          ),
        ),
      ),
    );
  }
}
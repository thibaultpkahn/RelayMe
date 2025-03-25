import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail du contact"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${contact["firstName"]} ${contact["lastName"]}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(contact["job"], style: const TextStyle(fontSize: 18, color: Colors.grey)),
            Text("📞 ${contact["phone"]}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            Chip(
              label: Text(contact["category"], style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue,
            ),
            const SizedBox(height: 20),

            const Text("Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ActionButton(label: "Demander son autorisation", message: contact["requestMessage"]),
            ActionButton(label: "Le prévenir sur partage", message: contact["notifyMessage"]),
            ActionButton(label: "Partager ce contact", message: contact["sendMessage"]),

            const Spacer(),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Action d’édition (à implémenter plus tard)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final String message;

  const ActionButton({super.key, required this.label, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          onPressed: () {
            // Afficher un message en appuyant sur le bouton
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Message envoyé : $message")),
            );
          },
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

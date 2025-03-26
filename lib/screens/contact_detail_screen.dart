import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relay_me/controllers/home_controller.dart';
import 'package:relay_me/screens/AuthorizationRequestScreen.dart';

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


            Column(
  children: [
    ActionButton(
      label: "Demander l'autorisation",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthorizationRequestScreen(
              contactName: contact["firstName"] + " " + contact["lastName"],
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
            builder: (context) => AuthorizationRequestScreen(
              contactName: contact["firstName"] + " " + contact["lastName"],
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
            builder: (context) => AuthorizationRequestScreen(
              contactName: contact["firstName"] + " " + contact["lastName"],
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
  final VoidCallback onPressed;

  const ActionButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

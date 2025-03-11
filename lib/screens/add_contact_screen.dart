import 'package:flutter/material.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController requestMessageController = TextEditingController();
  final TextEditingController notifyMessageController = TextEditingController();
  final TextEditingController sendMessageController = TextEditingController();

  String? selectedCategory;
  List<String> categories = ["Tech", "Mécaniciens"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajout de contact")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "Prénom"),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: jobController,
                decoration: const InputDecoration(labelText: "Métier"),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Catégorie"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Numéro de téléphone"),
              ),
              TextField(
                controller: requestMessageController,
                decoration: const InputDecoration(labelText: "Message de demande d'autorisation"),
              ),
              TextField(
                controller: notifyMessageController,
                decoration: const InputDecoration(labelText: "Message pour prévenir le contact"),
              ),
              TextField(
                controller: sendMessageController,
                decoration: const InputDecoration(labelText: "Message d'envoi de contact"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Créer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

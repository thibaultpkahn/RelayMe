import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/home_controller.dart';
import 'package:relay_me/global.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveContact() async 
  {
    if (firstNameController.text!="" && lastNameController.text != "" && jobController.text != "" && phoneController.text != "" && selectedCategory!= null && requestMessageController.text!= "" && notifyMessageController.text!= "" && sendMessageController.text!= ""){
      try {
      await _firestore.collection('contacts').add({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'job': jobController.text,
        'phone': phoneController.text,
        'category': selectedCategory,
        'requestMessage': requestMessageController.text,
        'notifyMessage': notifyMessageController.text,
        'sendMessage': sendMessageController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Afficher un message de succès
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact sauvegardé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      // Réinitialiser le formulaire
      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  else{
    // Afficher un message d'echec
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuiller compléter tous les champs !'),
          backgroundColor: Colors.red,
        ),
      );
  }
    
  }

  void _resetForm() {
    firstNameController.clear();
    lastNameController.clear();
    jobController.clear();
    phoneController.clear();
    requestMessageController.clear();
    notifyMessageController.clear();
    sendMessageController.clear();
    setState(() => selectedCategory = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajout de contact"),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _resetForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "Prénom",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: jobController,
                decoration: const InputDecoration(
                  labelText: "Métier",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.keys.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                decoration: const InputDecoration(
                  labelText: "Catégorie",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null ? 'Champs requis' : null,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Numéro de téléphone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: requestMessageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Message de demande d'autorisation",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: notifyMessageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Message pour prévenir le contact",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: sendMessageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Message d'envoi de contact",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Sauvegarder",
                    style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                ),
                onPressed: _saveContact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:relay_me/theme/colors.dart';

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

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.grayText)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.whiteText),
          minLines: isMultiline ? 3 : 1,
          maxLines: isMultiline ? 5 : 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _saveContact() async {
    if (!_validateFields()) {
      _showSnackBar('Veuillez remplir tous les champs obligatoires', Colors.red);
      return;
    }

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

      _showSnackBar('Contact créé avec succès !', Colors.green);
      _resetForm();
    } catch (e) {
      _showSnackBar('Erreur: $e', Colors.red);
    }
  }

  bool _validateFields() {
    return sendMessageController.text.trim().isNotEmpty &&
        notifyMessageController.text.trim().isNotEmpty &&
        requestMessageController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        selectedCategory != null && selectedCategory != "" ;
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

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Ajout de contact",
          style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: AppColors.whiteText),
            onPressed: _resetForm,
          ),
        ],
      ),
      body: Container(
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
                  buildTextField(label: "Prénom", controller: firstNameController),
                  buildTextField(label: "Nom", controller: lastNameController),
                  buildTextField(label: "Métier", controller: jobController),

                  const Text("Catégorie",
                      style: TextStyle(color: AppColors.grayText)),
                  const SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        var categories = snapshot.data!.docs.map((doc) => doc['name'] as String).toList();

                      return DropdownButtonFormField<String>(
                        value: selectedCategory,
                        dropdownColor: AppColors.secondary,
                        style: const TextStyle(color: AppColors.whiteText),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category, style: const TextStyle(color: AppColors.whiteText)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                      label: "Numéro de téléphone", controller: phoneController),
                  buildTextField(
                      label: "Message de demande d'autorisation",
                      controller: requestMessageController,
                      isMultiline: true),
                  buildTextField(
                      label: "Message pour prévenir le contact",
                      controller: notifyMessageController,
                      isMultiline: true),
                  buildTextField(
                      label: "Message d'envoi de contact",
                      controller: sendMessageController,
                      isMultiline: true),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Créer",
                        style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
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
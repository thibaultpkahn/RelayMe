import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:relay_me/global.dart';
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

  /// Widget réutilisable pour éviter la répétition des TextField
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.whiteText)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Ajout de contact", style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              buildTextField(label: "Prénom", controller: firstNameController),
              buildTextField(label: "Nom", controller: lastNameController),
              buildTextField(label: "Métier", controller: jobController),
              
              // Dropdown pour la catégorie
              const Text("Catégorie", style: TextStyle(color: AppColors.whiteText)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: AppColors.secondary,
                style: const TextStyle(color: AppColors.whiteText),
                items: categories.keys.map((category) {
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

              buildTextField(label: "Numéro de téléphone", controller: phoneController),
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

              // Bouton de création
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (sendMessageController.text.trim().isNotEmpty &&
                        notifyMessageController.text.trim().isNotEmpty &&
                        requestMessageController.text.trim().isNotEmpty &&
                        phoneController.text.trim().isNotEmpty &&
                        lastNameController.text.trim().isNotEmpty &&
                        selectedCategory != null) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Créer", style: TextStyle(color: AppColors.blackText, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

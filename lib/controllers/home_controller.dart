import 'package:flutter/material.dart';
import 'package:relay_me/theme/colors.dart';
import '../screens/add_contact_screen.dart';
import '../models/category_model.dart';
import 'package:relay_me/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends ChangeNotifier {
  
  Future <void> addCategory(String name) async {
  if (name.isNotEmpty) {
    try {
      await FirebaseFirestore.instance.collection('categories').doc(name).set({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners(); // Met à jour l'interface utilisateur
    } catch (e) {
      print("Erreur lors de l'ajout de la catégorie : $e");
    }
  }
}


  void showAddCategoryPopup(BuildContext context, Function setState) {
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Ajout de catégorie", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(labelText: "Nom de la catégorie"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String categoryName = categoryController.text.trim();
              if (categoryName.isNotEmpty) {
                categories[categoryName] = [];
                Navigator.pop(context);
                setState(() {}); // Rafraîchir l'UI
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  void showPopupMenu(BuildContext context, Function setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: AppColors.primary, // Couleur de la bordure
              width: 0.5, // Épaisseur de la bordure
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPopupCategorie(context, "Ajout d’une catégorie", setState),
              const SizedBox(height: 10),
              buildContactPage(context, "Ajout d’un contact"),
            ],
          ),
        );
      },
    );
  }

  Widget buildContactPage(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddContactScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.blackText)),
    );
  }

  Widget buildPopupCategorie(BuildContext context, String text, Function setState) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        showAddCategoryPopup(context, setState);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.blackText)),
    );
  }
}

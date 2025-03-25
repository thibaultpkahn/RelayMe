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
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Coins arrondis
          side: const BorderSide(
            color: Colors.blue, // Contour bleu
            width: 0.5, // Épaisseur du contour
          ),
        ),
        title: const Text("Ajout de catégorie", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: categoryController,
          style: const TextStyle(color: AppColors.whiteText),
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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200, // Ajuste la largeur selon tes besoins
                child: ElevatedButton(
                  onPressed: () {
                    String categoryName = categoryController.text.trim();
                    if (categoryName.isNotEmpty) {
                      categories[categoryName] = [];
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(
                      color: AppColors.blackText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
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

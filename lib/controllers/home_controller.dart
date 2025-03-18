import 'package:flutter/material.dart';
import '../screens/add_contact_screen.dart';
import '../models/category_model.dart';
import 'package:relay_me/global.dart';

class HomeController extends ChangeNotifier {
   
   
  void addCategory(String name) { //ajoute le nom de la categorie a la liste
    if (name.isNotEmpty && !categories.any((c) => c == name)) {
      categories.add(name);
      notifyListeners();
    }
  }
  

  void showAddCategoryPopup(BuildContext context) { //Popup de l'ajout de catégorie
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
              categories.add(categoryName); // Ajoute la catégorie
              Navigator.pop(context);
              (context as Element).markNeedsBuild(); // Force le rebuild
            }
          },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }



  void showPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPopupCategorie(context, "Ajout d’une catégorie"),
              const SizedBox(height: 10),
              buildContactPage(context, "Ajout d’un contact"),
            ],
          ),
        );
      },
    );
  }

  Widget buildContactPage(BuildContext context,String text) { // nouvelle page creation de contact à agencer
  return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
            // NAVIGATION VERS L'AUTRE PAGE
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
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
}

  Widget buildPopupCategorie(BuildContext context, String text) {  // A Faire popup choix de la nouvelle categorie
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        showAddCategoryPopup(context);
      },
      
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
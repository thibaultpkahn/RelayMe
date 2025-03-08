import 'package:flutter/material.dart';

class HomeController {
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
              _buildPopupButton(context, "Ajout d’une catégorie"),
              const SizedBox(height: 10),
              _buildPopupButton(context, "Ajout d’un contact"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Ferme la popup après sélection
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

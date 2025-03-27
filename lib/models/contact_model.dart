import 'package:relay_me/theme/colors.dart';
import 'package:flutter/material.dart';


// Carte de contact
class ContactCard extends StatelessWidget {
  final String firstName, lastName, job;
  final VoidCallback onTap;

  const ContactCard({
    required this.firstName,
    required this.lastName,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$firstName $lastName",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(job, style: const TextStyle(fontSize: 14, color: AppColors.grayText)),
          ],
        ),
      ),
    );
  }
}
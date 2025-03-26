import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class AuthorizationRequestScreen extends StatefulWidget {
  final String contactName;
  final String job;
  final String category;
  final String initialMessage;

  const AuthorizationRequestScreen({
    super.key,
    required this.contactName,
    required this.job,
    required this.category,
    required this.initialMessage,
  });

  @override
  _AuthorizationRequestScreenState createState() => _AuthorizationRequestScreenState();
}

class _AuthorizationRequestScreenState extends State<AuthorizationRequestScreen> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.initialMessage);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _messageController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Message copié !")),
    );
  }

  void _sendSms() async {
    final Uri smsUri = Uri.parse("sms:?body=${Uri.encodeComponent(_messageController.text)}");
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      debugPrint("Impossible d'ouvrir l'application SMS");
    }
  }

  void _sendWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(_messageController.text)}");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      debugPrint("Impossible d'ouvrir WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1A),
      appBar: AppBar(
        title: const Text("Envoi d’autorisation"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
            crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                        children: [
                          const TextSpan(text: "À : ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.contactName),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Métier : ", style: TextStyle(color: Colors.white)),
                        Chip(label: Text(widget.job, style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Catégorie : ", style: TextStyle(color: Colors.white)),
                        Chip(label: Text(widget.category, style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Message", style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ActionButton(label: "Copier", onPressed: _copyToClipboard),
                  const SizedBox(height: 10),
                  ActionButton(label: "Envoyer via SMS", onPressed: _sendSms),
                  const SizedBox(height: 10),
                  ActionButton(label: "Envoyer via WhatsApp", onPressed: _sendWhatsApp),
                ],
              ),
            ],
          ),
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
      width: 250, // Taille réduite pour être bien centré
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

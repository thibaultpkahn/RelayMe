import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:relay_me/theme/colors.dart';

class AuthorizationRequestScreen extends StatefulWidget {
  final String contactName;
  final String job;
  final String category;
  final String initialMessage;
  final String phone;

  const AuthorizationRequestScreen({
    super.key,
    required this.contactName,
    required this.job,
    required this.category,
    required this.initialMessage,
    required this.phone
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Envoi d’autorisation",
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
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
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.contactName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteText,
                              ),
                            ),
                            Chip(
                              label: Text(
                                widget.category,
                                style: const TextStyle(color: AppColors.primary, fontSize: 14),
                              ),
                              backgroundColor: AppColors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Métier : ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grayText,
                              ),
                            ),
                            Chip(
                              label: Text(
                                widget.job,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              backgroundColor: AppColors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.transparent),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Téléphone : ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grayText,
                              ),
                            ),
                            Chip(
                              label: Text(
                                "📞 ${widget.phone}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              backgroundColor: AppColors.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.transparent),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Message",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 0.2,           
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            maxLines: 4,
                            style: const TextStyle(color: AppColors.whiteText),
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

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ActionButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.blackText,
          ),
        ),
      ),
    );
  }
}
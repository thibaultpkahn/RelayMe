import 'category_model.dart';
class Contact {
  final String firstName;
  final String lastName;
  final String job;
  final Category category;
  final String phoneNumber;
  final String requestMessage;
  final String notifyMessage;
  final String sendMessage;

  Contact({
    required this.firstName,
    required this.lastName,
    required this.job,
    required this.category,
    required this.phoneNumber,
    required this.requestMessage,
    required this.notifyMessage,
    required this.sendMessage,
  });

  // Convertir un contact en Map pour la firebase
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "job": job,
      "category": category.toMap(),
      "phoneNumber": phoneNumber,
      "requestMessage": requestMessage,
      "notifyMessage": notifyMessage,
      "sendMessage": sendMessage,
    };
  }

  // Créer un contact à partir d'une Map pour que la firebase puisse bien les récupérer
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      job: map["job"] ?? "",
      category: Category.fromMap(map["category"] ?? {}),
      phoneNumber: map["phoneNumber"] ?? "",
      requestMessage: map["requestMessage"] ?? "",
      notifyMessage: map["notifyMessage"] ?? "",
      sendMessage: map["sendMessage"] ?? "",
    );
  }
}
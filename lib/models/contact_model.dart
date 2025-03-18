class Contact {
  final String firstName;
  final String lastName;
  final String jobTitle;
  final String phoneNumber;
  String authorizationMessage;
  String notificationMessage;
  String contactMessage;

  Contact({
    required this.firstName,
    required this.lastName,
    required this.jobTitle,
    required this.phoneNumber,
    this.authorizationMessage = "",
    this.notificationMessage = "",
    this.contactMessage = "",
  });

  // Convertir un contact en Map (pour stockage Firebase ou autre DB)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'phoneNumber': phoneNumber,
      'authorizationMessage': authorizationMessage,
      'notificationMessage': notificationMessage,
      'contactMessage': contactMessage,
    };
  }

  // Créer un contact depuis un Map (ex: récupération Firebase)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      authorizationMessage: map['authorizationMessage'] ?? '',
      notificationMessage: map['notificationMessage'] ?? '',
      contactMessage: map['contactMessage'] ?? '',
    );
  }
}

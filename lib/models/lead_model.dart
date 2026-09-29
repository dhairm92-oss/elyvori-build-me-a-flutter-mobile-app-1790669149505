class LeadModel {
  final String id;
  final String companyName;
  final String country;
  final String category;
  final String contactEmail;
  final String phoneNumber;
  final bool hasWebsite;
  final bool hasApp;
  final String notes;
  final DateTime discoveredAt;
  bool isContacted;

  LeadModel({
    required this.id,
    required this.companyName,
    required this.country,
    required this.category,
    required this.contactEmail,
    required this.phoneNumber,
    required this.hasWebsite,
    required this.hasApp,
    required this.notes,
    required this.discoveredAt,
    this.isContacted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyName': companyName,
        'country': country,
        'category': category,
        'contactEmail': contactEmail,
        'phoneNumber': phoneNumber,
        'hasWebsite': hasWebsite,
        'hasApp': hasApp,
        'notes': notes,
        'discoveredAt': discoveredAt.toIso8601String(),
        'isContacted': isContacted,
      };

  factory LeadModel.fromJson(Map<String, dynamic> json) => LeadModel(
        id: json['id'],
        companyName: json['companyName'],
        country: json['country'],
        category: json['category'],
        contactEmail: json['contactEmail'],
        phoneNumber: json['phoneNumber'],
        hasWebsite: json['hasWebsite'],
        hasApp: json['hasApp'],
        notes: json['notes'],
        discoveredAt: DateTime.parse(json['discoveredAt']),
        isContacted: json['isContacted'] ?? false,
      );
}

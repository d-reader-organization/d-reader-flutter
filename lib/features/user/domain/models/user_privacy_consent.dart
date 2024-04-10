class UserPrivacyConsent {
  final int id;
  final bool isConsentGiven;
  final String consentType;

  UserPrivacyConsent({
    required this.id,
    required this.isConsentGiven,
    required this.consentType,
  });

  factory UserPrivacyConsent.fromJson(dynamic json) {
    return UserPrivacyConsent(
      id: json['id'],
      isConsentGiven: json['isConsentGiven'],
      consentType: json['consentType'],
    );
  }
}

enum ConsentType { marketing, dataAnalytics }

extension ConsentTypeValue on ConsentType {
  String get value => switch (this) {
        ConsentType.marketing => 'Marketing',
        ConsentType.dataAnalytics => 'DataAnalytics'
      };
}

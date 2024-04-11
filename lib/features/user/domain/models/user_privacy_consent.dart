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

enum ConsentType {
  marketing,
  dataAnalytics,
  unknown;

  String getString() {
    return switch (this) {
      ConsentType.marketing => 'Marketing',
      ConsentType.dataAnalytics => 'DataAnalytics',
      ConsentType.unknown => 'Unknown',
    };
  }
}

extension ConsentTypeFromString on String {
  ConsentType consentTypeFromString() {
    if (this == ConsentType.marketing.getString()) {
      return ConsentType.marketing;
    } else if (this == ConsentType.dataAnalytics.getString()) {
      return ConsentType.dataAnalytics;
    }
    return ConsentType.unknown;
  }
}

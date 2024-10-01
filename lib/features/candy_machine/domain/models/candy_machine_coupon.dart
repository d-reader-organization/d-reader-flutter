class CandyMachineCoupon {
  final int id;
  final String name;
  final String description;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final int? numberOfRedemptions;
  final String type;
  final CouponStats stats;
  final List<CouponCurrencySetting> prices;

  CandyMachineCoupon({
    required this.id,
    required this.name,
    required this.description,
    required this.startsAt,
    required this.expiresAt,
    required this.numberOfRedemptions,
    required this.type,
    required this.stats,
    required this.prices,
  });

  factory CandyMachineCoupon.fromJson(dynamic json) {
    return CandyMachineCoupon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startsAt:
          json['startsAt'] != null ? DateTime.tryParse(json['startsAt']) : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
      numberOfRedemptions: json['numberOfRedemptions'],
      type: json['type'],
      stats: CouponStats.fromJson(json['stats']),
      prices: List<CouponCurrencySetting>.from(
        json['prices'].map(
          (item) => CouponCurrencySetting.fromJson(
            item,
          ),
        ),
      ),
    );
  }
}

class CouponStats {
  final int itemsMinted;
  final bool isEligible;

  CouponStats({
    required this.itemsMinted,
    required this.isEligible,
  });

  factory CouponStats.fromJson(dynamic json) {
    return CouponStats(
      itemsMinted: json['itemsMinted'] ?? 0,
      isEligible: json['isEligible'],
    );
  }
}

class CouponCurrencySetting {
  final String label;
  final int mintPrice;
  final String splTokenAddress;
  final int usdcEquivalent;

  CouponCurrencySetting({
    required this.label,
    required this.mintPrice,
    required this.splTokenAddress,
    required this.usdcEquivalent,
  });

  factory CouponCurrencySetting.fromJson(dynamic json) {
    return CouponCurrencySetting(
      label: json['label'],
      mintPrice: json['mintPrice'],
      splTokenAddress: json['splTokenAddress'],
      usdcEquivalent: json['usdcEquivalent'],
    );
  }
}

enum CouponType {
  publicUser,
  registeredUser,
  whitelistedUser,
  whitelistedWallet;

  String getString() {
    return switch (this) {
      CouponType.publicUser => 'PublicUser',
      CouponType.registeredUser => 'RegisteredUser',
      CouponType.whitelistedUser => 'WhitelistedUser',
      CouponType.whitelistedWallet => 'WhitelistedWallet',
    };
  }
}

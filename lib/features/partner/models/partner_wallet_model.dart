class WalletActivityItem {
  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final bool isPositive;

  const WalletActivityItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.isPositive,
  });

  factory WalletActivityItem.fromJson(Map<String, dynamic> json) {
    return WalletActivityItem(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      amount: json['amount'] as String,
      status: json['status'] as String,
      isPositive: json['isPositive'] as bool? ?? true,
    );
  }
}

class PartnerWalletModel {
  final num availableBalance;
  final String linkedBank;
  final String questTitle;
  final int questDaysLeft;
  final String questTier;
  final int completedJobs;
  final int targetJobs;
  final int questPercent;
  final num questReward;
  final int streakDays;
  final num protectedAmount;

  // Revenue Split
  final num serviceBase;
  final num addOnCommission;
  final num zoneSurge;
  final num tips;
  final num platformFee;
  final num grossTotal;

  final List<WalletActivityItem> activities;

  const PartnerWalletModel({
    required this.availableBalance,
    required this.linkedBank,
    required this.questTitle,
    required this.questDaysLeft,
    required this.questTier,
    required this.completedJobs,
    required this.targetJobs,
    required this.questPercent,
    required this.questReward,
    required this.streakDays,
    required this.protectedAmount,
    required this.serviceBase,
    required this.addOnCommission,
    required this.zoneSurge,
    required this.tips,
    required this.platformFee,
    required this.grossTotal,
    required this.activities,
  });

  factory PartnerWalletModel.fromJson(Map<String, dynamic> json) {
    final quest = json['weeklyQuest'] as Map<String, dynamic>? ?? {};
    final split = json['revenueSplit'] as Map<String, dynamic>? ?? {};

    return PartnerWalletModel(
      availableBalance: json['availableBalance'] as num? ?? 4320,
      linkedBank: json['linkedBank'] as String? ?? 'HDFC Bank (•••• 8821)',
      questTitle: quest['title'] as String? ?? 'Super Pro Bonus',
      questDaysLeft: quest['daysLeft'] as int? ?? 3,
      questTier: quest['tier'] as String? ?? 'Tier 2 Active',
      completedJobs: quest['completedJobs'] as int? ?? 18,
      targetJobs: quest['targetJobs'] as int? ?? 25,
      questPercent: quest['percent'] as int? ?? 72,
      questReward: quest['reward'] as num? ?? 1500,
      streakDays: quest['streakDays'] as int? ?? 5,
      protectedAmount: quest['protectedAmount'] as num? ?? 250,
      serviceBase: split['serviceBase'] as num? ?? 2400,
      addOnCommission: split['addOnCommission'] as num? ?? 420,
      zoneSurge: split['zoneSurge'] as num? ?? 350,
      tips: split['tips'] as num? ?? 150,
      platformFee: split['platformFee'] as num? ?? 0,
      grossTotal: split['grossTotal'] as num? ?? 3320,
      activities: (json['recentActivity'] as List? ?? [])
          .map(
            (item) => WalletActivityItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

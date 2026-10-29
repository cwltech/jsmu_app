class PartnerScheduleItem {
  final String time;
  final String status;
  final String title;
  final String location;
  final String amount;
  final bool isCompleted;
  final bool isNext;

  const PartnerScheduleItem({
    required this.time,
    required this.status,
    required this.title,
    required this.location,
    required this.amount,
    this.isCompleted = false,
    this.isNext = false,
  });

  factory PartnerScheduleItem.fromJson(Map<String, dynamic> json) {
    return PartnerScheduleItem(
      time: json['time'] as String,
      status: json['status'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      amount: json['amount'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isNext: json['isNext'] as bool? ?? false,
    );
  }
}

class PartnerDashboardModel {
  final String partnerName;
  final String partnerId;
  final bool isOnline;
  final num walletBalance;
  final num todayNet;
  final double growthPercentage;
  final num todayEarnings;
  final num targetEarnings;
  final int jobsCompletedToday;
  final int totalJobsScheduled;
  final int pendingSlots;
  final double acceptanceRate;
  final String partnerTier;
  final double rating;
  final String reviewCount;
  final List<PartnerScheduleItem> schedule;

  const PartnerDashboardModel({
    required this.partnerName,
    required this.partnerId,
    required this.isOnline,
    required this.walletBalance,
    required this.todayNet,
    required this.growthPercentage,
    required this.todayEarnings,
    required this.targetEarnings,
    required this.jobsCompletedToday,
    required this.totalJobsScheduled,
    required this.pendingSlots,
    required this.acceptanceRate,
    required this.partnerTier,
    required this.rating,
    required this.reviewCount,
    required this.schedule,
  });

  factory PartnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return PartnerDashboardModel(
      partnerName: json['partnerName'] as String? ?? 'Rajesh Kumar',
      partnerId: json['partnerId'] as String? ?? '#HC-4029',
      isOnline: json['isOnline'] as bool? ?? true,
      walletBalance: json['walletBalance'] as num? ?? 3450,
      todayNet: json['todayNet'] as num? ?? 3320,
      growthPercentage: (json['growthPercentage'] as num?)?.toDouble() ?? 18.4,
      todayEarnings: json['todayEarnings'] as num? ?? 2850,
      targetEarnings: json['targetEarnings'] as num? ?? 4000,
      jobsCompletedToday: json['jobsCompletedToday'] as int? ?? 3,
      totalJobsScheduled: json['totalJobsScheduled'] as int? ?? 5,
      pendingSlots: json['pendingSlots'] as int? ?? 2,
      acceptanceRate: (json['acceptanceRate'] as num?)?.toDouble() ?? 98.4,
      partnerTier: json['partnerTier'] as String? ?? 'Tier 1 Gold Partner',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewCount: json['reviewCount'] as String? ?? '1,240+',
      schedule: (json['schedule'] as List? ?? [])
          .map(
            (item) =>
                PartnerScheduleItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

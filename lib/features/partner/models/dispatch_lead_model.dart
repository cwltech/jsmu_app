class DispatchLeadModel {
  final String jobId;
  final String priorityTag;
  final String title;
  final String serviceDetails;
  final String location;
  final double distanceKm;
  final String arriveBy;
  final String driveTime;
  final int countdownSeconds;
  final num totalPayout;
  final num basePayout;
  final num surgePayout;
  final int estimatedWorkMinutes;
  final String customerName;
  final String customerTag;
  final double customerRating;
  final bool isCustomerVerified;
  final String customerNote;
  final List<String> equipment;
  final String route;
  final String traffic;

  const DispatchLeadModel({
    required this.jobId,
    required this.priorityTag,
    required this.title,
    required this.serviceDetails,
    required this.location,
    required this.distanceKm,
    required this.arriveBy,
    required this.driveTime,
    required this.countdownSeconds,
    required this.totalPayout,
    required this.basePayout,
    required this.surgePayout,
    required this.estimatedWorkMinutes,
    required this.customerName,
    required this.customerTag,
    required this.customerRating,
    required this.isCustomerVerified,
    required this.customerNote,
    required this.equipment,
    required this.route,
    required this.traffic,
  });

  factory DispatchLeadModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>? ?? {};
    return DispatchLeadModel(
      jobId: json['jobId'] as String? ?? 'HS-94021',
      priorityTag: json['priorityTag'] as String? ?? 'Priority Job',
      title: json['title'] as String? ?? 'Deep Home Cleaning',
      serviceDetails:
          json['serviceDetails'] as String? ??
          'Kitchen & 2 Bathrooms • Intensive Degreasing',
      location: json['location'] as String? ?? 'Sector 54, Gurgaon',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 1.8,
      arriveBy: json['arriveBy'] as String? ?? '03:45 PM',
      driveTime: json['driveTime'] as String? ?? '~7 mins',
      countdownSeconds: json['countdownSeconds'] as int? ?? 37,
      totalPayout: json['totalPayout'] as num? ?? 640,
      basePayout: json['basePayout'] as num? ?? 480,
      surgePayout: json['surgePayout'] as num? ?? 160,
      estimatedWorkMinutes: json['estimatedWorkMinutes'] as int? ?? 55,
      customerName: customer['name'] as String? ?? 'Ananya Deshmukh',
      customerTag: customer['tag'] as String? ?? 'Platinum Resident',
      customerRating: (customer['rating'] as num?)?.toDouble() ?? 4.9,
      isCustomerVerified: customer['isVerified'] as bool? ?? true,
      customerNote: json['customerNote'] as String? ?? '',
      equipment:
          (json['equipment'] as List? ??
                  ['Eco Chemical Kit', 'High-Pressure Jet Gun'])
              .map((e) => e.toString())
              .toList(),
      route: json['route'] as String? ?? '1.8 km via Golf Course Extension',
      traffic: json['traffic'] as String? ?? 'Light Traffic',
    );
  }
}

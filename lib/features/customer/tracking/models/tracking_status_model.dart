class TrackingStatusModel {
  final String bookingId;
  final String status;
  final int etaMinutes;
  final String estimatedTime;
  final String stage;
  final String partnerName;
  final String partnerRole;
  final double partnerRating;
  final String partnerJobs;
  final double partnerDistanceKm;
  final String otp;
  final String serviceTitle;
  final num price;
  final String serviceDesc;
  final String timeSlot;
  final String address;
  final String paymentInfo;

  const TrackingStatusModel({
    required this.bookingId,
    required this.status,
    required this.etaMinutes,
    required this.estimatedTime,
    required this.stage,
    required this.partnerName,
    required this.partnerRole,
    required this.partnerRating,
    required this.partnerJobs,
    required this.partnerDistanceKm,
    required this.otp,
    required this.serviceTitle,
    required this.price,
    required this.serviceDesc,
    required this.timeSlot,
    required this.address,
    required this.paymentInfo,
  });

  factory TrackingStatusModel.fromJson(Map<String, dynamic> json) {
    final partner = json['partner'] as Map<String, dynamic>? ?? {};
    return TrackingStatusModel(
      bookingId: json['bookingId'] as String? ?? 'HS-89421',
      status: json['status'] as String? ?? 'On the way',
      etaMinutes: json['etaMinutes'] as int? ?? 14,
      estimatedTime: json['estimatedTime'] as String? ?? '03:12 PM',
      stage: json['stage'] as String? ?? 'en_route',
      partnerName: partner['name'] as String? ?? 'Rajesh Kumar',
      partnerRole: partner['role'] as String? ?? 'Master AC & HVAC Specialist',
      partnerRating: (partner['rating'] as num?)?.toDouble() ?? 4.9,
      partnerJobs: partner['jobsCount'] as String? ?? '1,240+',
      partnerDistanceKm: (partner['distanceKm'] as num?)?.toDouble() ?? 1.4,
      otp: json['otp'] as String? ?? '4821',
      serviceTitle: json['serviceTitle'] as String? ?? 'Power Jet AC Servicing',
      price: json['price'] as num? ?? 599,
      serviceDesc:
          json['description'] as String? ??
          'Includes deep filter wash & coil disinfection (1 unit)',
      timeSlot: json['timeSlot'] as String? ?? 'Today, 03:00 PM - 04:00 PM',
      address:
          json['address'] as String? ?? 'Flat 402, Lotus Greens, Indiranagar',
      paymentInfo:
          json['paymentMethod'] as String? ??
          'Paid Online via UPI • Trans. ID #TX-9021',
    );
  }
}

class BookingModel {
  final String id;
  final String serviceTitle;
  final String serviceSubtitle;
  final String date;
  final String timeSlot;
  final String address;
  final num itemTotal;
  final num convenienceFee;
  final num discount;
  final num totalPayable;
  final String promoCode;
  final String status;

  const BookingModel({
    required this.id,
    required this.serviceTitle,
    required this.serviceSubtitle,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.itemTotal,
    required this.convenienceFee,
    required this.discount,
    required this.totalPayable,
    required this.promoCode,
    this.status = 'confirmed',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? 'HS-89421',
      serviceTitle:
          json['serviceTitle'] as String? ?? 'Deep Home Cleaning (Standard)',
      serviceSubtitle:
          json['serviceSubtitle'] as String? ??
          'Includes 2 Rooms • Duration ~2.5 hrs',
      date: json['date'] as String? ?? 'Sat, 12 Oct',
      timeSlot: json['timeSlot'] as String? ?? '10:00 AM',
      address:
          json['address'] as String? ??
          'Flat 402, Tower B, Palm Springs, Sector 54, Gurgaon',
      itemTotal: json['itemTotal'] as num? ?? 599,
      convenienceFee: json['convenienceFee'] as num? ?? 29,
      discount: json['discount'] as num? ?? 120,
      totalPayable: json['totalPayable'] as num? ?? 508,
      promoCode: json['promoCode'] as String? ?? 'WELCOME20',
      status: json['status'] as String? ?? 'confirmed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceTitle': serviceTitle,
      'serviceSubtitle': serviceSubtitle,
      'date': date,
      'timeSlot': timeSlot,
      'address': address,
      'itemTotal': itemTotal,
      'convenienceFee': convenienceFee,
      'discount': discount,
      'totalPayable': totalPayable,
      'promoCode': promoCode,
      'status': status,
    };
  }
}

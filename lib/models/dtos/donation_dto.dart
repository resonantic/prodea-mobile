import 'package:intl/intl.dart';
import 'package:prodea/models/donation.dart';

extension DonationDTO on Donation {
  Donation copyWith({
    String? id,
    String? description,
    String? photoUrl,
    String? donorId,
    String? beneficiaryId,
    String? expiration,
    String? cancellation,
    bool? isDelivered,
    DateTime? createdAt,
  }) {
    return Donation(
      id: id ?? this.id,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      donorId: donorId ?? this.donorId,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      expiration: expiration ?? this.expiration,
      cancellation: cancellation ?? this.cancellation,
      isDelivered: isDelivered ?? this.isDelivered,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'photoUrl': photoUrl,
      'donorId': donorId,
      'beneficiaryId': beneficiaryId,
      'expiration': expiration,
      'cancellation': cancellation,
      'isDelivered': isDelivered,
      'createdAt': createdAt,
    };
  }

  static Donation fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['id'],
      description: map['description'],
      photoUrl: map['photoUrl'],
      donorId: map['donorId'],
      beneficiaryId: map['beneficiaryId'],
      expiration: map['expiration'],
      cancellation: map['cancellation'],
      isDelivered: map['isDelivered'],
      createdAt: map['createdAt'],
    );
  }

  bool get isExpired {
    final expiration =
        DateFormat('DD/MM/YYYY HH:mm').parse("${this.expiration} 23:59");
    final diff = expiration.difference(DateTime.now()).inMinutes;

    return diff < 0;
  }
}

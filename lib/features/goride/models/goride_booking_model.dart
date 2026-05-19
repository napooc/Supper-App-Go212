class GoRideBooking {
  final int persons;
  final String? duration;          // 'heure', 'jour', 'semaine', 'mois'
  final int durationQuantity;      // how many hours / days / weeks / months
  final DateTime? startDate;
  final String? startTime;
  final int numMotos;
  final String? deliveryType;
  final String? deliveryAddress;
  final String? paymentMethod;
  final bool confirmed;
  final String? reservationId;     // UUID du backend après confirmation

  const GoRideBooking({
    this.persons = 1,
    this.duration,
    this.durationQuantity = 1,
    this.startDate,
    this.startTime,
    this.numMotos = 1,
    this.deliveryType,
    this.deliveryAddress,
    this.paymentMethod,
    this.confirmed = false,
    this.reservationId,
  });

  GoRideBooking copyWith({
    int? persons,
    String? duration,
    int? durationQuantity,
    DateTime? startDate,
    String? startTime,
    int? numMotos,
    String? deliveryType,
    String? deliveryAddress,
    String? paymentMethod,
    bool? confirmed,
    String? reservationId,
  }) {
    return GoRideBooking(
      persons: persons ?? this.persons,
      duration: duration ?? this.duration,
      durationQuantity: durationQuantity ?? this.durationQuantity,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      numMotos: numMotos ?? this.numMotos,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      confirmed: confirmed ?? this.confirmed,
      reservationId: reservationId ?? this.reservationId,
    );
  }

  // Price per unit (DH)
  int get unitPrice {
    switch (duration) {
      case 'heure':   return 30;
      case 'jour':    return 150;
      case 'semaine': return 700;
      case 'mois':    return 2500;
      default:        return 0;
    }
  }

  // Accurate total = unit price × quantity
  int get rentalTotal => unitPrice * durationQuantity;

  // Human-readable quantity label with correct French singular/plural
  String get quantityLabel {
    if (duration == null) return '-';
    if (durationQuantity == 1) {
      const s = {'heure': 'Heure', 'jour': 'Jour', 'semaine': 'Semaine', 'mois': 'Mois'};
      return '1 ${s[duration] ?? duration}';
    }
    const p = {'heure': 'Heures', 'jour': 'Jours', 'semaine': 'Semaines', 'mois': 'Mois'};
    return '$durationQuantity ${p[duration] ?? duration}';
  }

  String get durationLabel {
    switch (duration) {
      case 'heure':   return 'À l\'heure';
      case 'jour':    return 'À la journée';
      case 'semaine': return 'À la semaine';
      case 'mois':    return 'Au mois';
      default:        return '-';
    }
  }

  String get pricePerUnit {
    switch (duration) {
      case 'heure':   return '30 DH/h';
      case 'jour':    return '150 DH/j';
      case 'semaine': return '700 DH/sem';
      case 'mois':    return '2 500 DH/mois';
      default:        return '-';
    }
  }

  String get formattedDate {
    if (startDate == null) return '-';
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${startDate!.day} ${months[startDate!.month - 1]} ${startDate!.year}';
  }

  String get deliveryLabel {
    switch (deliveryType) {
      case 'livraison':
        return 'Livraison à domicile';
      case 'agence':
        return 'Retrait en agence';
      default:
        return '-';
    }
  }

  int get totalMotos => persons > 1 ? numMotos : 1;

  int get deliveryFee => deliveryType == 'livraison' ? 20 : 0;

  String get deliveryFeeLabel =>
      deliveryType == 'livraison' ? '20 DH' : 'Gratuit';
}

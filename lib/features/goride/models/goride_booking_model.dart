class GoRideBooking {
  final int persons;
  final String? duration; // 'heure', 'jour', 'semaine', 'mois'
  final DateTime? startDate;
  final String? startTime;
  final int numMotos;
  final String? deliveryType; // 'livraison' or 'agence'
  final String? paymentMethod;
  final bool confirmed;

  const GoRideBooking({
    this.persons = 1,
    this.duration,
    this.startDate,
    this.startTime,
    this.numMotos = 1,
    this.deliveryType,
    this.paymentMethod,
    this.confirmed = false,
  });

  GoRideBooking copyWith({
    int? persons,
    String? duration,
    DateTime? startDate,
    String? startTime,
    int? numMotos,
    String? deliveryType,
    String? paymentMethod,
    bool? confirmed,
  }) {
    return GoRideBooking(
      persons: persons ?? this.persons,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      numMotos: numMotos ?? this.numMotos,
      deliveryType: deliveryType ?? this.deliveryType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  String get durationLabel {
    switch (duration) {
      case 'heure':
        return 'À l\'heure';
      case 'jour':
        return 'À la journée';
      case 'semaine':
        return 'À la semaine';
      case 'mois':
        return 'Au mois';
      default:
        return '-';
    }
  }

  String get pricePerUnit {
    switch (duration) {
      case 'heure':
        return '30 DH/h';
      case 'jour':
        return '150 DH/j';
      case 'semaine':
        return '800 DH/sem';
      case 'mois':
        return '2 500 DH/mois';
      default:
        return '-';
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

class SubscriptionModel {
  final int id;
  final int userId;
  final String status;
  final SubscriptionDetail detail;
  final String month;
  final String year;
  final String externalId; // This will be the UUID from API
  

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.detail,
    required this.month,
    required this.year,
    required this.externalId,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    // Extract month from the message (e.g., "Subscription for September")
    String message = json['message'] ?? '';
    String month = '';
    String year = DateTime.now().year.toString(); // Default to current year
    
    // Extract month from message
    if (message.contains('January')) month = 'January';
    else if (message.contains('February')) month = 'February';
    else if (message.contains('March')) month = 'March';
    else if (message.contains('April')) month = 'April';
    else if (message.contains('May')) month = 'May';
    else if (message.contains('June')) month = 'June';
    else if (message.contains('July')) month = 'July';
    else if (message.contains('August')) month = 'August';
    else if (message.contains('September')) month = 'September';
    else if (message.contains('October')) month = 'October';
    else if (message.contains('November')) month = 'November';
    else if (message.contains('December')) month = 'December';
    else month = 'Unknown';

    // Try to extract year from paid_at if available
    String paidAt = json['detail']?['paid_at'] ?? '';
    if (paidAt.isNotEmpty) {
      List<String> dateParts = paidAt.split(' ');
      if (dateParts.length >= 3) {
        year = dateParts[2];
      }
    }

    return SubscriptionModel(
      id: json['id'] ?? 0, // You might need to generate this or get from somewhere else
      userId: json['user_id'] ?? 0, // Same here
      status: json['status'] ?? '',
      detail: SubscriptionDetail.fromJson(json['detail'] ?? {}),
      month: month,
      year: year,
      externalId: json['uuid'] ?? '', // Use UUID from API response
    );
  }
}

extension SubscriptionModelExtension on SubscriptionModel {
  DateTime get date {
    try {
      // Try to parse from detail.paidAt first
      if (detail.paidAt.isNotEmpty && detail.paidAt != '-') {
        return DateTime.parse(detail.paidAt);
      }
      
      // Fallback: construct date from month/year
      int monthNum = _getMonthNumber(month);
      int yearNum = int.tryParse(year) ?? DateTime.now().year;
      return DateTime(yearNum, monthNum, 1);
    } catch (_) {
      return DateTime(2000); // default if parsing fails
    }
  }
  
  int _getMonthNumber(String month) {
    switch (month.toLowerCase()) {
      case 'january': return 1;
      case 'february': return 2;
      case 'march': return 3;
      case 'april': return 4;
      case 'may': return 5;
      case 'june': return 6;
      case 'july': return 7;
      case 'august': return 8;
      case 'september': return 9;
      case 'october': return 10;
      case 'november': return 11;
      case 'december': return 12;
      default: return 1;
    }
  }
}

class SubscriptionDetail {
  final String amount;
  final String paymentMethod;
  final String paidAt;
  final String invoiceUrl;

  SubscriptionDetail({
    required this.amount,
    required this.paymentMethod,
    required this.paidAt,
    required this.invoiceUrl,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetail(
      amount: json['amount'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paidAt: json['paid_at'] ?? '',
      invoiceUrl: json['invoice_url'] ?? '',
    );
  }
}
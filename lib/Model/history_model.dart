class SubscriptionHistory {
  final String id;
  final String status;
  final String invoiceUrl;
  final String createdAt;

  SubscriptionHistory({
    required this.id,
    required this.status,
    required this.invoiceUrl,
    required this.createdAt,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistory(
      id: json['id'].toString(),
      status: json['status'] ?? '',
      invoiceUrl: json['invoice_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

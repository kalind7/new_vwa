class PromoValidationResult {
  const PromoValidationResult({
    required this.message,
    required this.discountAmount,
    required this.finalAmount,
    required this.code,
  });

  final String message;
  final double discountAmount;
  final double finalAmount;
  final String code;
}

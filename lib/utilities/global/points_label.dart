/// A points count with the Arabic word in the right number form:
/// "نقطة واحدة", "نقطتان", "5 نقاط", "67 نقطة".
String pointsLabel(int count) {
  if (count == 1) return 'نقطة واحدة';
  if (count == 2) return 'نقطتان';
  final lastTwoDigits = count.abs() % 100;
  final isPlural = lastTwoDigits >= 3 && lastTwoDigits <= 10;
  return '$count ${isPlural ? 'نقاط' : 'نقطة'}';
}

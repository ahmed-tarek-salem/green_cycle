import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/utilities/global/points_label.dart';

void main() {
  group('pointsLabel', () {
    test('uses the singular and dual words without a number', () {
      expect(pointsLabel(1), 'نقطة واحدة');
      expect(pointsLabel(2), 'نقطتان');
    });

    test('uses the plural for 3 to 10', () {
      expect(pointsLabel(3), '3 نقاط');
      expect(pointsLabel(5), '5 نقاط');
      expect(pointsLabel(10), '10 نقاط');
    });

    test('goes back to the singular from 11 to 99', () {
      expect(pointsLabel(11), '11 نقطة');
      expect(pointsLabel(67), '67 نقطة');
      expect(pointsLabel(99), '99 نقطة');
    });

    test('follows the last two digits above 100', () {
      expect(pointsLabel(100), '100 نقطة');
      expect(pointsLabel(101), '101 نقطة');
      expect(pointsLabel(102), '102 نقطة');
      expect(pointsLabel(103), '103 نقاط');
      expect(pointsLabel(110), '110 نقاط');
      expect(pointsLabel(111), '111 نقطة');
      expect(pointsLabel(380), '380 نقطة');
    });

    test('keeps zero readable', () {
      expect(pointsLabel(0), '0 نقطة');
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_lele/main.dart';
import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/screen/splash.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyApp Widget Tests', () {
    testWidgets('MyApp has a SplashScreen as home',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('MyApp uses Poppins font', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.textTheme.bodyLarge?.fontFamily, 'Poppins');
    });

    testWidgets('MyApp has correct primary and secondary colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.colorScheme.primary, AppColors.curelean);
      expect(app.theme?.colorScheme.secondary, AppColors.bluetopaz);
    });
  });

  group('initializeLocationPermission Tests', () {
    test('initializeLocationPermission requests permission if denied',
        () async {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
      await initializeLocationPermission();
      expect(await Geolocator.checkPermission(), LocationPermission.denied);
    });
  });
}

class MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.denied;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.whileInUse;
  }
}

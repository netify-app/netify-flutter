import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:netify_example/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    final dio = Dio();
    await tester.pumpWidget(MyApp(dio: dio));

    expect(find.text('Netify Example'), findsOneWidget);
    expect(find.text('Test API Requests'), findsOneWidget);
  });
}

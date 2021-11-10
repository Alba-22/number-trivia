import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/network/network_info.dart';

class _MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkInfo networkInfo;
  late _MockInternetConnectionChecker connectionChecker;

  setUp(() {
    connectionChecker = _MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker);
  });

  group("isConnected", () {
    test(
      "Should foward the call to InternetConnectionChecker.hasConnection",
      () async {
        // Arrange
        final tHasConnectionFuture = Future.value(true);
        when(() => connectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

        // Act
        final result = networkInfo.isConnected;

        // Assert
        verify(() => connectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);

        /// Comparing the result with tHasConnectionFuture variable will make sure that the comparison is being made for the same object.
        /// If we just made `thenAnswer((_) async => true)` and `expect(result, true)` the value is the same, but in the production code
        /// it can be not the same referency.
        ///
        /// when(() => connectionChecker.hasConnection).thenAnswer((_) async => true);
        ///
        /// final result = await networkInfo.isConnected;
        ///
        /// verify(() => connectionChecker.hasConnection);
        /// expect(result, true);
      },
    );
  });
}

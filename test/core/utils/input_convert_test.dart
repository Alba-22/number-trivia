import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:number_trivia/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test(
      "Should return an integer when the string represent an unsigned integer",
      () async {
        // Arrange
        const str = "22";

        // Act
        final result = inputConverter.stringToUnsignedInteger(str);

        // Assert
        expect(result, equals(const Right(22)));
      },
    );

    test(
      "Should return a Failure when the string is not an integer",
      () async {
        // Arrange
        const str = "abc";

        // Act
        final result = inputConverter.stringToUnsignedInteger(str);

        // Assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );

    test(
      "Should return a Failure when the string is a negative integer",
      () async {
        // Arrange
        const str = "-22";

        // Act
        final result = inputConverter.stringToUnsignedInteger(str);

        // Assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
  });
}

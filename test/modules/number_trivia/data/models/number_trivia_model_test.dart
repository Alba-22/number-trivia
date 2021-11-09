import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/modules/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Cool number.");

  test(
    "Should be a subclass of NumberTriviaEntity",
    () async {
      // Assert
      expect(tNumberTriviaModel, isA<NumberTriviaEntity>());
    },
  );

  group("fromJson", () {
    test(
      "Should return a valid model when the JSON number is an integer",
      () {
        // Arrange
        final Map<String, dynamic> triviaMap = jsonDecode(fixture("trivia.json"));

        // Act
        final result = NumberTriviaModel.fromMap(triviaMap);

        // Assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "Should return a valid model when the JSON number is an double",
      () {
        // Arrange
        final Map<String, dynamic> triviaMap = jsonDecode(fixture("trivia_double.json"));

        // Act
        final result = NumberTriviaModel.fromMap(triviaMap);

        // Assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
  });

  group("toMap", () {
    test("Should return a Map containing proper data", () {
      // Act
      final result = tNumberTriviaModel.toMap();

      // Assert
      const expectedMap = {
        "text": "Cool number.",
        "number": 1,
      };
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals(expectedMap));
    });
  });
}

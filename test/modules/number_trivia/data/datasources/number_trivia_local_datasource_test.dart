import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDatasource datasource;
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDatasourceImpl(sharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromMap(jsonDecode(fixture("trivia_cached.json")));

    test(
      "Should return NumberTrivia from SharedPreferences when there's one in the cache",
      () async {
        // Arrange
        when(() => sharedPreferences.getString(any())).thenReturn(fixture("trivia_cached.json"));

        // Act
        final result = await datasource.getLastNumberTrivia();

        // Assert
        verify(() => sharedPreferences.getString(cachedNumberTriviaKey));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "Should throw CacheException when there's not a cached value",
      () async {
        // Arrange
        when(() => sharedPreferences.getString(any())).thenReturn(null);

        // Act
        final call = datasource.getLastNumberTrivia;

        // Assert
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Cool number.");
    test(
      "Should call SharedPreferences to cache the data",
      () async {
        // Arrange
        when(() => sharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

        // Act
        datasource.cacheNumberTrivia(tNumberTriviaModel);

        // Assert
        final expectedJsonString = jsonEncode(tNumberTriviaModel.toMap());
        verify(() => sharedPreferences.setString(cachedNumberTriviaKey, expectedJsonString));
      },
    );
  });
}

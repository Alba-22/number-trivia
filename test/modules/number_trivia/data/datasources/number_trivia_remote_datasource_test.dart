import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDatasource datasource;
  late MockHttpClient client;

  setUp(() {
    client = MockHttpClient();
    datasource = NumberTriviaRemoteDatasourceImpl(client);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse(""));
  });

  void setUpMockHttpClientSuccess() {
    when(() => client.get(any(), headers: any(named: "headers"))).thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpClientUnsuccess() {
    when(() => client.get(any(), headers: any(named: "headers"))).thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromMap(jsonDecode(fixture("trivia.json")));

    test(
      "Should perform a GET request on a URL "
      "with number being the endpoint and with application/json header",
      () async {
        // Arrange
        setUpMockHttpClientSuccess();

        // Act
        await datasource.getConcreteNumberTrivia(tNumber);

        // Assert
        verify(
          () => client.get(
            Uri.parse("http://numbersapi.com/$tNumber"),
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
      },
    );

    test(
      "Should return NumberTrivia when statusCode is 200(successful)",
      () async {
        // Arrange
        setUpMockHttpClientSuccess();

        // Act
        final result = await datasource.getConcreteNumberTrivia(tNumber);

        // Assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "Should throw a ServerException when statusCode is not 200(unsuccessful)",
      () async {
        // Arrange
        setUpMockHttpClientUnsuccess();

        // Act
        final call = datasource.getConcreteNumberTrivia;

        // Assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromMap(jsonDecode(fixture("trivia.json")));

    test(
      "Should perform a GET request on a URL "
      "with number being the endpoint and with application/json header",
      () async {
        // Arrange
        setUpMockHttpClientSuccess();

        // Act
        await datasource.getRandomNumberTrivia();

        // Assert
        verify(
          () => client.get(
            Uri.parse("http://numbersapi.com/random"),
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
      },
    );

    test(
      "Should return NumberTrivia when statusCode is 200(successful)",
      () async {
        // Arrange
        setUpMockHttpClientSuccess();

        // Act
        final result = await datasource.getRandomNumberTrivia();

        // Assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "Should throw a ServerException when statusCode is not 200(unsuccessful)",
      () async {
        // Arrange
        setUpMockHttpClientUnsuccess();

        // Act
        final call = datasource.getRandomNumberTrivia;

        // Assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}

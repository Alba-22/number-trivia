import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/modules/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/modules/number_trivia/domain/repositories/number_trivia_repository.dart';

class _MockRemoteDatasource extends Mock implements NumberTriviaRemoteDatasource {}

class _MockLocalDatasource extends Mock implements NumberTriviaLocalDatasource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepository repository;
  late NumberTriviaRemoteDatasource remoteDatasource;
  late NumberTriviaLocalDatasource localDatasource;
  late NetworkInfo networkInfo;

  setUp(() {
    remoteDatasource = _MockRemoteDatasource();
    localDatasource = _MockLocalDatasource();
    networkInfo = _MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      networkInfo: networkInfo,
    );
  });

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: "Cool number.");
    const NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    test(
      "Should check if device is online",
      () async {
        // Arrange
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => remoteDatasource.getConcreteNumberTrivia(any())).thenAnswer((_) async => tNumberTriviaModel);
        when(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});

        // Act
        await repository.getConcreteNumberTrivia(tNumber);

        // Assert
        verify(() => networkInfo.isConnected);
      },
    );

    group("Device is Online", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
      });

      test(
        "Should return remote data when the call to remote datasource is successful",
        () async {
          // Arrange
          when(() => remoteDatasource.getConcreteNumberTrivia(any())).thenAnswer((_) async => tNumberTriviaModel);

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(() => remoteDatasource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTriviaEntity)));
        },
      );

      test(
        "Should cache the data locally when the call to remote datasource is successful",
        () async {
          // Arrange
          when(() => remoteDatasource.getConcreteNumberTrivia(any())).thenAnswer((_) async => tNumberTriviaModel);

          // Act
          await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(() => remoteDatasource.getConcreteNumberTrivia(tNumber));
          verify(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        "Should return ServerFailure when the call to remote datasource is unsuccessful",
        () async {
          // Arrange
          when(() => remoteDatasource.getConcreteNumberTrivia(any())).thenThrow(ServerException());

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(() => remoteDatasource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(localDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group("Device is Offline", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
      });

      test(
        "Should return last locally cached data when the cache data is present",
        () async {
          // Arrange
          when(() => localDatasource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verifyZeroInteractions(remoteDatasource);
          verify(() => localDatasource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTriviaEntity)));
        },
      );

      test(
        "Should return CacheFailure when there is no cache data present",
        () async {
          // Arrange
          when(() => localDatasource.getLastNumberTrivia()).thenThrow(CacheException());

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verifyZeroInteractions(remoteDatasource);
          verify(() => localDatasource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
  group("getRandomNumberTrivia", () {
    const tNumberTriviaModel = NumberTriviaModel(number: 123, text: "Cool number.");
    const NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    test(
      "Should check if device is online",
      () async {
        // Arrange
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => remoteDatasource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        when(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});

        // Act
        await repository.getRandomNumberTrivia();

        // Assert
        verify(() => networkInfo.isConnected);
      },
    );

    group("Device is Online", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
      });

      test(
        "Should return remote data when the call to remote datasource is successful",
        () async {
          // Arrange
          when(() => remoteDatasource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(() => remoteDatasource.getRandomNumberTrivia());
          expect(result, equals(const Right(tNumberTriviaEntity)));
        },
      );

      test(
        "Should cache the data locally when the call to remote datasource is successful",
        () async {
          // Arrange
          when(() => remoteDatasource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          // Act
          await repository.getRandomNumberTrivia();

          // Assert
          verify(() => remoteDatasource.getRandomNumberTrivia());
          verify(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        "Should return ServerFailure when the call to remote datasource is unsuccessful",
        () async {
          // Arrange
          when(() => remoteDatasource.getRandomNumberTrivia()).thenThrow(ServerException());

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(() => remoteDatasource.getRandomNumberTrivia());
          verifyZeroInteractions(localDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group("Device is Offline", () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(() => localDatasource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => {});
      });

      test(
        "Should return last locally cached data when the cache data is present",
        () async {
          // Arrange
          when(() => localDatasource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(remoteDatasource);
          verify(() => localDatasource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTriviaEntity)));
        },
      );

      test(
        "Should return CacheFailure when there is no cache data present",
        () async {
          // Arrange
          when(() => localDatasource.getLastNumberTrivia()).thenThrow(CacheException());

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(remoteDatasource);
          verify(() => localDatasource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}

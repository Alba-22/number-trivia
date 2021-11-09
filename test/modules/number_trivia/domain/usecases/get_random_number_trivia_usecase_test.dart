import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/modules/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late Usecase usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTriviaUsecase(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTriviaEntity(text: "Cool number", number: 1);

  test(
    "Should get trivia from the repository",
    () async {
      // Arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => const Right(tNumberTrivia));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/modules/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTriviaUsecase usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTriviaUsecase(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTriviaEntity(text: "Cool number", number: tNumber);

  test(
    "Should get trivia for the number from the repository",
    () async {
      // Arrange
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any())).thenAnswer((_) async => const Right(tNumberTrivia));

      // Act
      final result = await usecase.execute(number: tNumber);

      // Assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}

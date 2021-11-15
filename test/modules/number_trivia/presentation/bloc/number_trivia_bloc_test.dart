import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/modules/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:number_trivia/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class _MockConcreteNumberTriviaUsecase extends Mock implements GetConcreteNumberTriviaUsecase {}

class _MockRandomNumberTriviaUsecase extends Mock implements GetRandomNumberTriviaUsecase {}

class _MockInputConverter extends Mock implements InputConverter {}

void main() {
  late _MockConcreteNumberTriviaUsecase concreteUsecase;
  late _MockRandomNumberTriviaUsecase randomUsecase;
  late _MockInputConverter inputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    concreteUsecase = _MockConcreteNumberTriviaUsecase();
    randomUsecase = _MockRandomNumberTriviaUsecase();
    inputConverter = _MockInputConverter();
    bloc = NumberTriviaBloc(concreteUsecase, randomUsecase, inputConverter);
  });

  setUpAll(() {
    registerFallbackValue(const Params(number: 1));
    registerFallbackValue(NoParams());
  });

  test("InitialState should be empty", () {
    // Assert
    expect(bloc.state, equals(NumberTriviaEmptyState()));
  });

  group("GetTriviaForConcreteNumber", () {
    const tNumberString = "1";
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTriviaEntity(text: "Cool number.", number: 1);

    void setUpInputConverterSuccess() {
      when(() => inputConverter.stringToUnsignedInteger(any())).thenReturn(const Right(tNumberParsed));
    }

    test(
      "Should call the input converter to validate and convert the string to an unsigned integer",
      () async {
        // Arrange
        setUpInputConverterSuccess();
        when(() => concreteUsecase.call(any())).thenAnswer((_) async => const Right(tNumberTrivia));

        // Act
        bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
        await untilCalled(() => inputConverter.stringToUnsignedInteger(any()));

        // Assert
        verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      "Should emit [NumberTriviaErrorState] when the input is invalid",
      () async {
        // Arrange
        when(() => inputConverter.stringToUnsignedInteger(any())).thenReturn(Left(InvalidInputFailure()));

        // Assert Later
        final expected = [
          const NumberTriviaErrorState(invalidInputFailureMessage),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      },
    );

    test(
      "Should get data from the concrete usecase",
      () async {
        // Arrange
        setUpInputConverterSuccess();
        when(() => concreteUsecase.call(any())).thenAnswer((_) async => const Right(tNumberTrivia));

        // Act
        bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
        await untilCalled(() => concreteUsecase.call(any()));

        // Assert
        verify(() => concreteUsecase.call(const Params(number: tNumberParsed)));
      },
    );

    test(
      "Should emit [NumberTriviaLoadingState, NumberTriviaLoadedState] when data is gotten successfully",
      () async {
        // Arrange
        setUpInputConverterSuccess();
        when(() => concreteUsecase.call(any())).thenAnswer((_) async => const Right(tNumberTrivia));

        // Assert Later
        final expected = [
          NumberTriviaLoadingState(),
          const NumberTriviaLoadedState(tNumberTrivia),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      },
    );

    test(
      "Should emit [NumberTriviaLoadingState, NumberTriviaErrorState] when getting data fails",
      () async {
        // Arrange
        setUpInputConverterSuccess();
        when(() => concreteUsecase.call(any())).thenAnswer((_) async => Left(ServerFailure()));

        // Assert Later
        final expected = [
          NumberTriviaLoadingState(),
          const NumberTriviaErrorState(serverFailureMessage),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      },
    );

    test(
      "Should emit [NumberTriviaLoadingState, NumberTriviaErrorState] "
      "whit a proper message for the error when getting data fails",
      () async {
        // Arrange
        setUpInputConverterSuccess();
        when(() => concreteUsecase.call(any())).thenAnswer((_) async => Left(CacheFailure()));

        // Assert Later
        final expected = [
          NumberTriviaLoadingState(),
          const NumberTriviaErrorState(cacheFailureMessage),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      },
    );
  });

  group("GetTriviaForRandomNumber", () {
    const tNumberTrivia = NumberTriviaEntity(text: "Cool number.", number: 1);

    test(
      "Should get data from the concrete usecase",
      () async {
        // Arrange
        when(() => randomUsecase.call(any())).thenAnswer((_) async => const Right(tNumberTrivia));

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());
        await untilCalled(() => randomUsecase.call(any()));

        // Assert
        verify(() => randomUsecase.call(NoParams()));
      },
    );

    test(
      "Should emit [NumberTriviaLoadingState, NumberTriviaLoadedState] when data is gotten successfully",
      () async {
        // Arrange
        when(() => randomUsecase.call(any())).thenAnswer((_) async => const Right(tNumberTrivia));

        // Assert Later
        final expected = [
          NumberTriviaLoadingState(),
          const NumberTriviaLoadedState(tNumberTrivia),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());
      },
    );

    test(
      "Should emit [NumberTriviaLoadingState, NumberTriviaErrorState] when getting data fails",
      () async {
        // Arrange
        when(() => randomUsecase.call(any())).thenAnswer((_) async => Left(ServerFailure()));

        // Assert Later
        final expected = [
          NumberTriviaLoadingState(),
          const NumberTriviaErrorState(serverFailureMessage),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());
      },
    );

    test(
      "Should emit [NumberTriviaLoadingState, NumberTriviaErrorState] "
      "whit a proper message for the error when getting data fails",
      () async {
        // Arrange
        when(() => randomUsecase.call(any())).thenAnswer((_) async => Left(CacheFailure()));

        // Assert Later
        final expected = [
          NumberTriviaLoadingState(),
          const NumberTriviaErrorState(cacheFailureMessage),
        ];
        expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );

        // Act
        bloc.add(GetTriviaForRandomNumberEvent());
      },
    );
  });
}

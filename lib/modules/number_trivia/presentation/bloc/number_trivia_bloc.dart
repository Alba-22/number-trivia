import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

import '../../domain/entities/number_trivia_entity.dart';
import '../../domain/usecases/get_concrete_number_trivia_usecase.dart';
import '../../domain/usecases/get_random_number_trivia_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = "Server Failure";
const String cacheFailureMessage = "Cache Failure";
const String invalidInputFailureMessage = "Invalid Input - The number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUsecase concreteNumberTriviaUsecase;
  final GetRandomNumberTriviaUsecase randomNumberTriviaUsecase;
  final InputConverter inputConverter;

  NumberTriviaBloc(
    this.concreteNumberTriviaUsecase,
    this.randomNumberTriviaUsecase,
    this.inputConverter,
  ) : super(NumberTriviaEmptyState()) {
    on<GetTriviaForConcreteNumberEvent>((event, emit) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold(
        (failure) {
          emit(const NumberTriviaErrorState(invalidInputFailureMessage));
        },
        (integer) async {
          emit(NumberTriviaLoadingState());
          final usecaseResult = await concreteNumberTriviaUsecase.call(Params(number: integer));
          usecaseResult.fold(
            (failure) => emit(NumberTriviaErrorState(_mapFailureToMessage(failure))),
            (trivia) => emit(NumberTriviaLoadedState(trivia)),
          );
        },
      );
    });
    on<GetTriviaForRandomNumberEvent>((event, emit) async {
      emit(NumberTriviaLoadingState());
      final usecaseResult = await randomNumberTriviaUsecase.call(NoParams());
      usecaseResult.fold(
        (failure) => emit(NumberTriviaErrorState(_mapFailureToMessage(failure))),
        (trivia) => emit(NumberTriviaLoadedState(trivia)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return "Unexpected Error";
    }
  }
}

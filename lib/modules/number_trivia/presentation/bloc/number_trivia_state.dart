part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaEmptyState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoadingState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTriviaEntity trivia;

  const NumberTriviaLoadedState(this.trivia);

  @override
  List<Object> get props => [trivia];
}

class NumberTriviaErrorState extends NumberTriviaState {
  final String message;

  const NumberTriviaErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

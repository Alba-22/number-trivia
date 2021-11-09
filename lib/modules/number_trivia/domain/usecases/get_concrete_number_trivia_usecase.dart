import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';

import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUsecase implements Usecase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository _repository;

  GetConcreteNumberTriviaUsecase(this._repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    return await _repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}

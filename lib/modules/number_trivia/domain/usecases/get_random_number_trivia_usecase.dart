import 'package:dartz/dartz.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';

import '../entities/number_trivia_entity.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUsecase implements Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository _repository;

  GetRandomNumberTriviaUsecase(this._repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await _repository.getRandomNumberTrivia();
  }
}

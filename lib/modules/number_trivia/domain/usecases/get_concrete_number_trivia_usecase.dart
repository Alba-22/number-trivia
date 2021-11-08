import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/modules/number_trivia/domain/entities/number_trivia_entity.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUsecase {
  final NumberTriviaRepository _repository;

  GetConcreteNumberTriviaUsecase(this._repository);

  Future<Either<Failure, NumberTriviaEntity>> execute({required int number}) async {
    return await _repository.getConcreteNumberTrivia(number);
  }
}

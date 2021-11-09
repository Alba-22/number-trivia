import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/repositories/number_trivia_repository_impl.dart';
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
}

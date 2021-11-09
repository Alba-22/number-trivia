import '../../domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  const NumberTriviaModel({
    required int number,
    required String text,
  }) : super(number: number, text: text);

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      number: (map["number"] as num).toInt(),
      text: map["text"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "text": text,
    };
  }
}

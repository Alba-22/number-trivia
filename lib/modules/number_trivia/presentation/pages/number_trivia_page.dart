import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:number_trivia/injection_container.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widget.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<NumberTriviaBloc>(),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top Half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaEmptyState) {
                    return const MessageDisplayWidget(message: "Start searching!");
                  } else if (state is NumberTriviaErrorState) {
                    return MessageDisplayWidget(message: state.message);
                  } else if (state is NumberTriviaLoadedState) {
                    return TriviaDisplayWidget(trivia: state.trivia);
                  } else if (state is NumberTriviaLoadingState) {
                    return const LoadingDisplayWidget();
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              // Bottom Half
              const TriviaControlsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

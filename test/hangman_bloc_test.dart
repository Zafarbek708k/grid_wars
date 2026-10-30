import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_wars/core/service/storage_service.dart';
import 'package:grid_wars/feature/hangman/presentation/blocs/hangman_bloc/hangman_bloc.dart';

Future<HangmanState> _settled(HangmanBloc bloc) => bloc.stream.first;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageRepository.getInstance();
  });

  group('HangmanBloc', () {
    test('starts with a word picked from the bank and no guesses yet', () async {
      final bloc = HangmanBloc(random: Random(1));
      final state = await _settled(bloc);

      expect(state.word, isNotEmpty);
      expect(state.guessedLetters, isEmpty);
      expect(state.isGameOver, isFalse);
      bloc.close();
    });

    test('guessing every letter of the word wins', () async {
      final bloc = HangmanBloc(random: Random(1));
      final initial = await _settled(bloc);
      final letters = initial.word.split('').toSet();

      HangmanState last = initial;
      for (final letter in letters) {
        final future = bloc.stream.first;
        bloc.add(GuessLetter$HangmanEvent(letter: letter));
        last = await future;
      }

      expect(last.isWin, isTrue);
      expect(last.maskedWord, initial.word);
      bloc.close();
    });

    test('6 wrong guesses loses the game', () async {
      final bloc = HangmanBloc(random: Random(1));
      final initial = await _settled(bloc);
      final wrongLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          .split('')
          .where((l) => !initial.word.contains(l))
          .take(6)
          .toList();
      expect(wrongLetters.length, 6, reason: 'need 6 letters absent from the chosen word for this test to be valid');

      HangmanState last = initial;
      for (final letter in wrongLetters) {
        final future = bloc.stream.first;
        bloc.add(GuessLetter$HangmanEvent(letter: letter));
        last = await future;
      }

      expect(last.isLoss, isTrue);
      expect(last.isGameOver, isTrue);
      bloc.close();
    });

    test('guessing an already-guessed letter does not count twice', () async {
      final bloc = HangmanBloc(random: Random(1));
      final initial = await _settled(bloc);
      final letter = initial.word[0];

      final future = bloc.stream.first;
      bloc.add(GuessLetter$HangmanEvent(letter: letter));
      final afterFirst = await future;
      expect(afterFirst.guessedLetters.length, 1);

      bloc.add(GuessLetter$HangmanEvent(letter: letter));
      // No second emission should occur — give the event loop a tick and
      // confirm state is unchanged.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.guessedLetters.length, 1);
      bloc.close();
    });

    test('new game resets guesses and picks a word again', () async {
      final bloc = HangmanBloc(random: Random(1));
      final initial = await _settled(bloc);
      final letter = initial.word[0];

      final guessFuture = bloc.stream.first;
      bloc.add(GuessLetter$HangmanEvent(letter: letter));
      await guessFuture;

      final resetFuture = bloc.stream.first;
      bloc.add(const NewGame$HangmanEvent());
      final reset = await resetFuture;

      expect(reset.guessedLetters, isEmpty);
      expect(reset.isGameOver, isFalse);
      bloc.close();
    });
  });
}

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/presentation/blocs/chess_bloc/chess_bloc.dart';

void main() {
  group('ChessBloc', () {
    test('selecting your own piece populates legalMoves', () async {
      final bloc = ChessBloc();
      final future = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 6, col: 4)); // white e2 pawn
      final state = await future;

      expect(state.selected, (6, 4));
      expect(state.legalMoves, isNotEmpty);
      bloc.close();
    });

    test('tapping a highlighted destination makes the move and advances the turn', () async {
      final bloc = ChessBloc();
      final selectFuture = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 6, col: 4));
      await selectFuture;

      final moveFuture = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 4, col: 4)); // e2-e4
      final state = await moveFuture;

      expect(state.board[4][4], const ChessPiece(PieceType.pawn, PieceColor.white));
      expect(state.board[6][4], isNull);
      expect(state.turn, PieceColor.black);
      expect(state.selected, isNull, reason: 'the selection clears once the move lands');
      bloc.close();
    });

    test("cannot select the opponent's piece on your turn", () async {
      final bloc = ChessBloc();
      final future = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 1, col: 4)); // black pawn, white to move
      final state = await future;

      expect(state.selected, isNull);
      bloc.close();
    });

    test('reset restores the initial board and white to move', () async {
      final bloc = ChessBloc();
      final selectFuture = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 6, col: 4));
      await selectFuture;
      final moveFuture = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 4, col: 4));
      await moveFuture;

      final resetFuture = bloc.stream.first;
      bloc.add(const ResetGame$ChessEvent());
      final state = await resetFuture;

      expect(state.turn, PieceColor.white);
      expect(state.board[6][4], const ChessPiece(PieceType.pawn, PieceColor.white));
      bloc.close();
    });

    test('in bot mode, the bot replies as black after white moves', () async {
      final bloc = ChessBloc(random: Random(1));

      final modeFuture = bloc.stream.first;
      bloc.add(const SelectMode$ChessEvent(mode: GameMode.bot));
      await modeFuture;

      final selectFuture = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 6, col: 4));
      await selectFuture;

      final moveFuture = bloc.stream.first;
      bloc.add(const SelectSquare$ChessEvent(row: 4, col: 4)); // e2-e4, turn flips to black, bot is requested
      final afterWhiteMove = await moveFuture;
      expect(afterWhiteMove.turn, PieceColor.black);

      final botReply = await bloc.stream
          .firstWhere((s) => s.turn == PieceColor.white)
          .timeout(const Duration(seconds: 2), onTimeout: () => throw TestFailure('Bot never replied.'));

      expect(botReply.turn, PieceColor.white);
      bloc.close();
    });
  });
}

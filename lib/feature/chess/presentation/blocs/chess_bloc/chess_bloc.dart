import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grid_wars/core/enums/game_mode_enum.dart';
import 'package:grid_wars/feature/chess/domain/entities/bot_difficulty.dart';
import 'package:grid_wars/feature/chess/domain/entities/castling_rights.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_move.dart';
import 'package:grid_wars/feature/chess/domain/entities/chess_piece.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_bot.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_engine.dart';
import 'package:grid_wars/feature/chess/domain/services/chess_rules.dart';
import 'package:grid_wars/feature/daily_challenge/domain/services/daily_challenge_service.dart';
import 'package:grid_wars/feature/game_stats/domain/services/game_stats_service.dart';

export 'package:grid_wars/core/enums/game_mode_enum.dart';
export 'package:grid_wars/feature/chess/domain/entities/bot_difficulty.dart';

part 'chess_event.dart';
part 'chess_state.dart';

/// The bot always plays black; a human (whichever color is to move when
/// mode is "friend") always plays white and moves first, same shape as
/// [TicTacToeBot] where the bot is always O.
class ChessBloc extends Bloc<ChessEvent, ChessState> {
  ChessBloc({Random? random})
    : _random = random ?? Random(),
      _engine = ChessEngine(),
      super(ChessState(board: ChessEngine.initialBoard())) {
    on<SelectSquare$ChessEvent>(_selectSquare);
    on<SelectMode$ChessEvent>(_selectMode);
    on<SelectDifficulty$ChessEvent>(_selectDifficulty);
    on<ResetGame$ChessEvent>(_resetGame);
    on<RequestBotMove$ChessEvent>(_requestBotMove);
  }

  final Random _random;
  final ChessEngine _engine;

  void _selectSquare(SelectSquare$ChessEvent event, Emitter<ChessState> emit) {
    if (state.isGameOver || state.isBotTurn) return;

    ChessMove? targetMove;
    for (final move in state.legalMoves) {
      if (move.toRow == event.row && move.toCol == event.col) {
        targetMove = move;
        break;
      }
    }
    if (state.selected != null && targetMove != null) {
      _applyMove(targetMove, emit);
      return;
    }

    final piece = _engine.board[event.row][event.col];
    if (piece != null && piece.color == _engine.turn) {
      final moves = _engine.legalMovesFrom(event.row, event.col);
      _emitFromEngine(emit, selected: (event.row, event.col), legalMoves: moves);
    } else {
      _emitFromEngine(emit);
    }
  }

  void _applyMove(ChessMove move, Emitter<ChessState> emit) {
    _engine.applyMove(move);

    if (_engine.isGameOver) {
      unawaited(DailyChallengeService.notifyGameCompleted('chess'));
      unawaited(GameStatsService.recordCompletion('chess'));
    }

    _emitFromEngine(emit);

    if (!_engine.isGameOver && state.mode == GameMode.bot && _engine.turn == PieceColor.black) {
      add(const RequestBotMove$ChessEvent());
    }
  }

  FutureOr<void> _requestBotMove(RequestBotMove$ChessEvent event, Emitter<ChessState> emit) async {
    await Future.delayed(const Duration(milliseconds: 450));
    if (isClosed) return;
    if (_engine.isGameOver || _engine.turn != PieceColor.black) return;

    final move = ChessBot.pickMove(_engine, state.botDifficulty, random: _random);
    if (move != null) _applyMove(move, emit);
  }

  FutureOr<void> _selectMode(SelectMode$ChessEvent event, Emitter<ChessState> emit) async {
    emit(state.copyWith(mode: event.mode));
  }

  FutureOr<void> _selectDifficulty(SelectDifficulty$ChessEvent event, Emitter<ChessState> emit) async {
    emit(state.copyWith(botDifficulty: event.difficulty));
  }

  FutureOr<void> _resetGame(ResetGame$ChessEvent event, Emitter<ChessState> emit) async {
    _engine.board = ChessEngine.initialBoard();
    _engine.turn = PieceColor.white;
    _engine.rights = const CastlingRights();
    _engine.enPassantTarget = null;
    _engine.lastMove = null;
    _engine.isCheckmate = false;
    _engine.isStalemate = false;
    _emitFromEngine(emit);
  }

  void _emitFromEngine(Emitter<ChessState> emit, {(int, int)? selected, List<ChessMove> legalMoves = const []}) {
    emit(
      ChessState(
        board: [for (final row in _engine.board) [...row]],
        turn: _engine.turn,
        mode: state.mode,
        botDifficulty: state.botDifficulty,
        isCheck: _engine.isInCheck(_engine.turn),
        isCheckmate: _engine.isCheckmate,
        isStalemate: _engine.isStalemate,
        lastMove: _engine.lastMove,
        selected: selected,
        legalMoves: legalMoves,
      ),
    );
  }
}

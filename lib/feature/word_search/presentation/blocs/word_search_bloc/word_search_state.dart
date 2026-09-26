part of 'word_search_bloc.dart';

class WordSearchState extends Equatable {
  final List<List<String>> grid;
  final List<String> words;
  final Set<String> foundWords;
  final Set<(int, int)> foundCells;
  final List<(int, int)> selection;
  final bool isSolved;

  const WordSearchState({
    this.grid = const [],
    this.words = const [],
    this.foundWords = const {},
    this.foundCells = const {},
    this.selection = const [],
    this.isSolved = false,
  });

  bool isSelected(int row, int col) => selection.contains((row, col));

  bool isFound(int row, int col) => foundCells.contains((row, col));

  WordSearchState copyWith({
    List<List<String>>? grid,
    List<String>? words,
    Set<String>? foundWords,
    Set<(int, int)>? foundCells,
    List<(int, int)>? selection,
    bool? isSolved,
  }) {
    return WordSearchState(
      grid: grid ?? this.grid,
      words: words ?? this.words,
      foundWords: foundWords ?? this.foundWords,
      foundCells: foundCells ?? this.foundCells,
      selection: selection ?? this.selection,
      isSolved: isSolved ?? this.isSolved,
    );
  }

  @override
  List<Object?> get props => [grid, words, foundWords, foundCells, selection, isSolved];
}

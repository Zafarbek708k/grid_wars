class MineCell {
  bool isMine;
  bool isRevealed;
  bool isFlagged;
  int adjacentMines;

  MineCell({
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.adjacentMines = 0,
  });
}

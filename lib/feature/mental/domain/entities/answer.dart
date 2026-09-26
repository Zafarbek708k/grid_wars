class Answer {
  const Answer({required this.answerText, this.isCorrect = false, this.isSelected = false});

  final String answerText;
  final bool isCorrect;
  final bool isSelected;

  Answer copyWith({String? answerText, bool? isCorrect, bool? isSelected}) {
    return Answer(
      answerText: answerText ?? this.answerText,
      isCorrect: isCorrect ?? this.isCorrect,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  int get hashCode => Object.hash(answerText, isCorrect, isSelected);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Answer &&
            other.runtimeType == runtimeType &&
            other.answerText == answerText &&
            other.isCorrect == isCorrect &&
            other.isSelected == isSelected;
  }

  @override
  String toString() {
    return 'Answer{answer_text: $answerText, is_correct: $isCorrect, is_selected: $isSelected}';
  }
}

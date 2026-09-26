class MemoryCard {
  final String imagePath;
  final int id;
  final bool isSelected;

  const MemoryCard({required this.id, required this.imagePath, this.isSelected = false});

  MemoryCard copyWith({String? imagePath, int? id, bool? isSelected}) {
    return MemoryCard(id: id ?? this.id, imagePath: imagePath ?? this.imagePath, isSelected: isSelected ?? this.isSelected);
  }

  @override
  int get hashCode => Object.hash(imagePath, id, isSelected);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MemoryCard &&
            other.runtimeType == runtimeType &&
            other.id == id &&
            other.imagePath == imagePath &&
            other.isSelected == isSelected;
  }

  @override
  String toString() {
    return "MemoryCard{id: $id, imagePath: $imagePath, isSelected: $isSelected}";
  }
}

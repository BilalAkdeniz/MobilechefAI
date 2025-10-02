class PreferenceModel {
  static const String defaultDiet = 'Farketmez';
  static const int defaultPeopleCount = 2;
  static const String defaultDifficulty = 'Orta';
  static const int defaultCookingTime = 45;

  final String diet;
  final int peopleCount;
  final String difficulty;
  final int cookingTime;
  final DateTime? updatedAt;

  const PreferenceModel({
    required this.diet,
    required this.peopleCount,
    required this.difficulty,
    required this.cookingTime,
    this.updatedAt,
  });

  factory PreferenceModel.defaults() {
    return PreferenceModel(
      diet: defaultDiet,
      peopleCount: defaultPeopleCount,
      difficulty: defaultDifficulty,
      cookingTime: defaultCookingTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diet': diet,
      'peopleCount': peopleCount,
      'difficulty': difficulty,
      'cookingTime': cookingTime,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  factory PreferenceModel.fromMap(Map<String, dynamic> map) {
    return PreferenceModel(
      diet: map['diet'] as String? ?? defaultDiet,
      peopleCount: map['peopleCount'] as int? ?? defaultPeopleCount,
      difficulty: map['difficulty'] as String? ?? defaultDifficulty,
      cookingTime: map['cookingTime'] as int? ?? defaultCookingTime,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  PreferenceModel copyWith({
    String? diet,
    int? peopleCount,
    String? difficulty,
    int? cookingTime,
    DateTime? updatedAt,
  }) {
    return PreferenceModel(
      diet: diet ?? this.diet,
      peopleCount: peopleCount ?? this.peopleCount,
      difficulty: difficulty ?? this.difficulty,
      cookingTime: cookingTime ?? this.cookingTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PreferenceModel &&
        other.diet == diet &&
        other.peopleCount == peopleCount &&
        other.difficulty == difficulty &&
        other.cookingTime == cookingTime &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      diet.hashCode ^
      peopleCount.hashCode ^
      difficulty.hashCode ^
      cookingTime.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'PreferenceModel(diet: $diet, peopleCount: $peopleCount, difficulty: $difficulty, cookingTime: $cookingTime, updatedAt: $updatedAt)';
}

class Friend {
  final String uid;
  final String name;
  final String imageUrl;
  final String lastSeen;
  final bool isFavourite;

  Friend({
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.lastSeen,
    required this.isFavourite,
  });

  Friend copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    String? lastSeen,
    bool? isFavourite,
  }) {
    return Friend(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      lastSeen: lastSeen ?? this.lastSeen,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}

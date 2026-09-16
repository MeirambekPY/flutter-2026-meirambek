class Author {
  final String name;
  final String? country;

  const Author (this.name, this.country);

  @override
  String toString() => 'Author(name: $name, country: $country)';
}

enum Genre {
  craft("Craft"),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  static Genre fromString(String? raw) {
    switch(raw?.toLowerCase()) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem (this.title, this.year);

  String describe();

  bool get isOld {
    if (year > 100) {
      return true;
    } else {
      return false;
    }
  }
}

class Book extends LibraryItem with Borrowable{
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required String title,
    required int year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  }): super(title, year);

  Book.missing(super.title, super.year)
  :pages = 0,
  author = const Author("Unknown", "Unknown"),
  genre = Genre.unknown,
  description = "Unknown";

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorData = json['author'];
    Author parsedAuthor;

    if (authorData is Map<String, dynamic>) {
      parsedAuthor = Author(
        authorData['name'] as String? ?? "Unknown",
        authorData['country'] as String?,
      );
    } else {
      parsedAuthor = const Author("Unknown", "Unknown");
    }

    return Book(
      title: json['title'] as String? ?? "Unknown",
      year: json['year'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      author: parsedAuthor,
      genre: Genre.fromString(json['genre'] as String?),
      description: json['description'] as String?,
    );
  }

  bool get isLong {
    if (pages > 400) {
      return true;
    } else {
      return false;
    }
  }

  Book copyWith ({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() {
    if (isOld) {
      return "The book is old";
    } else {
      return "The book is not old";
    }
  }

  @override
  String toString() => 'Book(title: $title, year: $year, pages: $pages, author: $author, genre: $genre, description: $description)';
}

class Magazine extends LibraryItem {
  final String issue;

  Magazine (String title, int year, this.issue): super(title, year);

  @override
  String describe() {
    if (isOld) {
      return 'The magazine is old';
    } else {
      return 'The magazine is not old';
    }
  }
}

mixin Borrowable {
  String borrowLabel(String title) {
    return '$title';
}
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost(this.title, this.year);

  @override
  String describe() {
    if (isOld) {
      return 'The ghost book is old';
    } else {
      return 'The ghost book is not old';
    }
  }

  @override
  bool get isOld {
    if (year > 100) {
      return true;
    } else {
      return false;
    }
  }
}
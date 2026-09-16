import 'models.dart';

class Library {
  final List<LibraryItem> items;
  late final DateTime openedAt;
  String? _cachedReport;

  Library (this.items);

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) {
    findByTitle(title)?.author.country ?? 'Unknown';
    return "Unknown";
  }

  void Open() {
    openedAt = DateTime.now();
  }

  String cachedReport() {
    return _cachedReport ??= '$items.length';
  }

  List<String> get titles {
    return items
        .map((item) => item.title)
        .toList();
  }

  List<Book> get booksPublishAft2010 {
    return items
        .whereType<Book>()
        .where((book) => book.year > 2010)
        .toList();
  }

  double get averagePageCount {
    final books = items.whereType<Book>();
    return books.isEmpty
        ? 0.0
        : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length;
  }

  Set<String> get authorNames {
    return items
        .whereType<Book>()
        .map((book) => book.author.name)
        .whereType<String>()
        .toSet();
  }

  List<String> get displayList {
    return [
      'CATALOGUE',
      for (final book in items.whereType<Book>())
        '${book.title} (${book.year})',
      ...authorNames,
      if (items.whereType<Book>().any((book) => book.pages == 0))
        '(incomplete data)',
    ];
  }
}
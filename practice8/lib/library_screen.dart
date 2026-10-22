import 'package:flutter/material.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'detail_screen.dart';
import 'add_book_screen.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((b) => b.read).toList(),
  };

  Future<void> _navigateToAddBook() async {
    final newBook = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (_) => const AddBookScreen()),
    );
    if (!mounted || newBook == null) return;
    setState(() {
      _books.add(newBook);
    });
  }

  Future<void> _navigateToDetail(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );
    if (!mounted || action == null) return;

    setState(() {
      switch (action) {
        case BookAction.toggleRead:
          book.read = !book.read;
          break;
        case BookAction.delete:
          _books.remove(book);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleBooks = _visible;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reading list (${visibleBooks.length})'),
      ),
      body: Column(
        children: [
          // Header summary card (Level 3)
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('${_books.length}',
                            style: theme.textTheme.headlineSmall),
                        Text('Books', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('${totalPages(_books)}',
                            style: theme.textTheme.headlineSmall),
                        Text('Pages', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('${unread(_books).length}',
                            style: theme.textTheme.headlineSmall),
                        Text('Unread', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Filter Chips (Level 2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Filter.values.map((f) {
                return ChoiceChip(
                  label: Text(f.name.toUpperCase()),
                  selected: _filter == f,
                  onSelected: (selected) {
                    if (selected) setState(() => _filter = f);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // List of Books (Level 2 & 3)
          Expanded(
            child: ListView.builder(
              itemCount: visibleBooks.length,
              itemBuilder: (context, index) {
                final book = visibleBooks[index];
                return InkWell(
                  onTap: () => _navigateToDetail(book),
                  child: BookTile(
                    book: book,
                    onToggle: () => setState(() => book.read = !book.read),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
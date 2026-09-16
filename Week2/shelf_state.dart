import 'models.dart';
sealed class ShelfState {}

class Empty extends ShelfState {}

class Ready extends ShelfState {
  final List<Book> books;
  Ready(this.books);
}
class Broken extends ShelfState {
  final String message;
  Broken(this.message);
}

String describe(ShelfState state) {
  return switch (state) {
    Empty() => 'The shelf is empty right now',
    Ready(books: final b) => 'The shelf has ${b.length} book(s)',
    Broken(message: final msg) => 'Error: $msg',
  };
}
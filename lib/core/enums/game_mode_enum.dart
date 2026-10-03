/// Shared "who's on the other side" choice for local 2-player games: a
/// second human sharing the device, or a local (fully offline) bot.
enum GameMode {
  friend(label: 'FRIEND'),
  bot(label: 'BOT');

  final String label;

  const GameMode({required this.label});
}

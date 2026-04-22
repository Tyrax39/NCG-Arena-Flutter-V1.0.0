class SnackbarMessage {
  final String content;
  final bool isLongMessage;
  final Duration duration;
  final bool isForError;

  const SnackbarMessage({required this.content, required this.isLongMessage, required this.isForError})
      : duration = isLongMessage ? const Duration(seconds: 7) : const Duration(seconds: 2);

  const SnackbarMessage.empty({bool isLongMessage = false}) : this(content: '', isLongMessage: isLongMessage, isForError: false);

  const SnackbarMessage.longMessage({required String content}) : this(content: content, isLongMessage: true, isForError: false);

  const SnackbarMessage.longMessageError({required String content})
      : this(content: content, isLongMessage: true, isForError: true);

  const SnackbarMessage.smallMessage({required String content}) : this(content: content, isLongMessage: false, isForError: false);

  const SnackbarMessage.smallMessageError({required String content})
      : this(content: content, isLongMessage: false, isForError: true);

  @override
  String toString() {
    return 'SnackbarMessage{content: $content, isLongMessage: $isLongMessage}';
  }
}
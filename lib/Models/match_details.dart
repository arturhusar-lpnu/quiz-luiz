//enum MatchSelectionType { button, circle }

class MatchDetails {
  final String title;
  final String type;
  final String topics;
  final String mode;
  //final MatchSelectionType selectionType;

  MatchDetails({
    required this.title,
    required this.type,
    required this.topics,
    required this.mode,
  });
}
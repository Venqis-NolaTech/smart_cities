extension ListExtension on List {
  bool get isNullOrEmpty => this == null || this.isEmpty;

  bool get isNotNullOrNotEmpty => !this.isNullOrEmpty;
}

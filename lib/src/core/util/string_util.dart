import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String enumName() {
    List<String> paths = this.split(".");
    return paths[paths.length - 1];
  }

  String formatPhoneNumber() {
    if (this.isNullOrEmpty) return this;

    if (this.length > 2 && this.length <= 7) {
      return '${this.substring(0, 3)}-${this.substring(3)}';
    } else if (this.length > 7 && this.length <= 10) {
      return '${this.substring(0, 3)}-${this.substring(3, 6)}-${this.substring(6)}';
    } else {
      return this;
    }
  }

  String formatDni() {
    if (this.isNullOrEmpty) return this;

    final onlyNumbers = this.replaceAll(RegExp(r'[^\d]'), '');

    if (onlyNumbers.length <= 7) {
      return '${onlyNumbers.substring(0, 3)}-${onlyNumbers.substring(3)}';
    } else if (onlyNumbers.length > 7 && onlyNumbers.length <= 11) {
      return '${onlyNumbers.substring(0, 3)}-${onlyNumbers.substring(3, 10)}-${onlyNumbers.substring(10)}';
    } else {
      return this;
    }
  }

  String get capitalize {
    if (this == null) {
      throw ArgumentError("string: $this");
    }

    if (this.isEmpty) {
      return this;
    }

    return this[0].toUpperCase() + this.substring(1);
  }

  bool get isNullOrEmpty => this == null || this.isEmpty;

  bool get isNotNullOrNotEmpty => !this.isNullOrEmpty;

  int countMatches(final String ch) {
    if (this.isEmpty) {
      return 0;
    }
    int count = 0;
    for (int i = 0; i < this.length; i++) {
      if (ch == this.charAt(i)) {
        count++;
      }
    }
    return count;
  }

  String charAt(int position) {
    if (this is! String ||
        this.length <= position ||
        this.length + position < 0) {
      return '';
    }

    int _realPosition = position < 0 ? this.length + position : position;

    return this[_realPosition];
  }

  String reverse() {
    if (this == null) {
      return null;
    }

    return this.split('').reversed.join('');
  }

  String removeStart(final String remove) {
    if (this.isEmpty || remove.isEmpty) {
      return this;
    }
    if (this.startsWith(remove)) {
      return this.substring(remove.length);
    }
    return this;
  }

  DateTime toDate() => DateTime.tryParse(this) ?? DateTime.now();

  String toDateFormated(DateFormat format) => format.format(toDate());

  TimeOfDay toTimeOfDay() {
    int hh = 0;

    if (this.endsWith('PM') || this.endsWith('p.m.') || this.endsWith('p. m.'))
      hh = 12;

    var time = this.split(' ')[0];

    return TimeOfDay(
      hour: hh + int.parse(time.split(":")[0]) % 24,
      minute: int.parse(time.split(":")[1]) % 60,
    );
  }
}



extension StringExtension on String {
  String upperCaseFirst() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

}
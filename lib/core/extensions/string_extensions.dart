extension StringExtensions on String {
  String get toPng => "assets/images/$this.png";
  String get toIcon => "assets/icons/ic_$this.png";
}
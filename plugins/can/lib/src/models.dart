class CanSignalData {
  CanSignalData(this.name, this.value, this.mid);

  final String name;
  final double value;
  final int mid;

  @override
  String toString() =>
      "CanSignalData - name:${name.toString()}, value: ${value.toString()}, mid: ${mid.toString()}";
}

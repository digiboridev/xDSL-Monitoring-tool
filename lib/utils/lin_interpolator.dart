List<double> scaleArray(List<int> sourceArray, int targetLength) {
  List<double> scaledArray = [];
  final double step = sourceArray.length / targetLength;

  for (int i = 0; i < targetLength; i++) {
    final int start = (i * step).floor();
    final int end = ((i + 1) * step).floor();
    final int sum = sourceArray.sublist(start, end).reduce((a, b) => a + b);
    final double avg = sum / (end - start);
    scaledArray.add(avg);
  }
  return scaledArray;
}

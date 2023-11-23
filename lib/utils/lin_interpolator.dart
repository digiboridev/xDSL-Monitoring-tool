List<double> interpolateArray(List<int> sourceArray, int targetLength) {
  List<double> interpolatedArray = [];
  final double step = sourceArray.length / targetLength;

  for (int i = 0; i < targetLength; i++) {
    final int start = (i * step).floor();
    final int end = ((i + 1) * step).floor();
    final int sum = sourceArray.sublist(start, end).reduce((a, b) => a + b);
    final double avg = sum / (end - start);
    interpolatedArray.add(avg);
  }
  return interpolatedArray;
}

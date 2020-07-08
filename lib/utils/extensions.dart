extension ListAverage on List<num> {
  double average() {
    try {
      return this.cast<num>().reduce((a, b) => a + b) / this.length;
    } on StateError {
      return 0;
    }
  }
}

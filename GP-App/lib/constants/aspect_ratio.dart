class AspectRatios {
  static final AspectRatios _instance = AspectRatios._internal();

  static late final double height;
  static late final double width;
  static bool isInitialized = false;
  factory AspectRatios() {
    return _instance;
  }
  AspectRatios._internal();
}

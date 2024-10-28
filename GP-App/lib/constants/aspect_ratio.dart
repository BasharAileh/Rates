class AspectRatios {
  static final AspectRatios _instance = AspectRatios._internal();

  static late final double height;
  static late final double width;
  static bool isInitialized = false;
  static void init(double h, double w) {
    if (!isInitialized) {
      height = h;
      width = w;
      isInitialized = true;
    }
  }

  factory AspectRatios() {
    return _instance;
  }
  AspectRatios._internal();
}

class AspectRatios {
  static late double height;
  static late double width;
  static late double heightWithoutAppBar;

  static void init(double h, double w) {
    height = h;
    width = w;
    heightWithoutAppBar = height - (height * 0.0663507109);
  }
}

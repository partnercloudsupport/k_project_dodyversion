class WidgetUtils {
  static List<T> mapListToWidgetList<T>(List list, Function handler) {
    List<T> result = [];
    if (list.length == 0) {
      result.add(handler(0, null, 0));
      return result;
    }
    for (int i = 0; i < list.length; i++) {
      result.add(handler(i, list[i], list.length));
    }
    return result;
  }
}

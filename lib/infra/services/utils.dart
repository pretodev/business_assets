typedef JsonList = List<JsonData>;
typedef JsonData = Map<String, dynamic>;

extension EnumExtension<T extends Enum> on List<T> {
  T? maybeName(String v) {
    for (var value in this) {
      if (value.name == v) {
        return value;
      }
    }
    return null;
  }
}

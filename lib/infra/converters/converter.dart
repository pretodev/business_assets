typedef JsonList = List<JsonData>;
typedef JsonData = Map<String, dynamic>;

abstract interface class DataConverter<E, D> {
  E toEntity(D data);
  D toData(E entity);

  static List<E> entities<E, D>(
    Iterable data,
    DataConverter<E, D> converter,
  ) {
    return data.map((d) => converter.toEntity(d)).toList();
  }

  static List<D> data<E, D>(
    Iterable entities,
    DataConverter<E, D> converter,
  ) {
    return entities.map((e) => converter.toData(e)).toList();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CitiesStore on _CitiesStoreBase, Store {
  late final _$citiesAtom =
      Atom(name: '_CitiesStoreBase.cities', context: context);

  @override
  ObservableList<String> get cities {
    _$citiesAtom.reportRead();
    return super.cities;
  }

  @override
  set cities(ObservableList<String> value) {
    _$citiesAtom.reportWrite(value, super.cities, () {
      super.cities = value;
    });
  }

  late final _$fetchCitiesAsyncAction =
      AsyncAction('_CitiesStoreBase.fetchCities', context: context);

  @override
  Future<void> fetchCities() {
    return _$fetchCitiesAsyncAction.run(() => super.fetchCities());
  }

  @override
  String toString() {
    return '''
cities: ${cities}
    ''';
  }
}

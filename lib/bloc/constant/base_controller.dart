import 'package:rxdart/rxdart.dart';

class BaseStreamController<T> {
  T _state;
  late final BehaviorSubject<T> _subject;

  BaseStreamController({required T state}) : _state = state {
    _subject = BehaviorSubject<T>.seeded(_state);
  }

  T get state => _state;

  set state(T value) {
    _state = value;
    _subject.add(_state);
  }

  BehaviorSubject<T> get subject => _subject;
}

abstract class BaseInterface<T> {
  Stream<T> get stream;
  void dispose();
}

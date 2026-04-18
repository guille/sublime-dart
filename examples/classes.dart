// SYNTAX TEST "Dart.sublime-syntax"
import 'dart:async';
//<- meta.declaration.dart keyword.other.import.dart
//^^^^ keyword.other.import.dart
//     ^^^^^^^^^^^^ string.interpolated.single.dart
//     ^ punctuation.definition.string.begin.dart
//                ^ punctuation.definition.string.end.dart
//                 ^ punctuation.terminator.dart
//^^^^^^^^^^^^^^^^^^ meta.declaration.dart

class Empty {}
abstract class Shape {}
class Point {}
class Box<T> {}
class Pair<A, B> {}
class Repository<T extends Entity> {}
class Cache<K extends Comparable<K>, V> {}
abstract class Transformer<In, Out> {}
class Rectangle extends Shape {}
class NumberBox extends Box<int> {}
class Note implements Describable {}
class Event extends Note implements Identified, Timestamped {}
abstract class JsonSerializable implements Encodable, Decodable {}
class Athlete extends Person with Runner {}
class SwimmingAthlete extends Person with Runner, Swimmer {}
class SortedList<T extends Comparable<T>> extends BaseList<T> implements Iterable<T>, Cloneable {}
abstract class AsyncRepository<T extends Model, ID> extends BaseRepository<T> implements Findable<T, ID>, Persistable<T> {}

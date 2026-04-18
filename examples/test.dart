#!/usr/bin/env dart
// =============================================================================
// dart_syntax_showcase.dart
// A comprehensive tour of Dart language features for syntax highlighting.
// =============================================================================

// ─── Imports & Libraries ─────────────────────────────────────────────────────

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io' show File, Platform, stdin, stdout;
import 'dart:math' as math;
import 'dart:typed_data';

part 'dart_syntax_showcase.part.dart'; // hypothetical part file

import augment 'b.dart';

augment library 'a.dart';


augment void foo() {
  print('augmented');
}
extension MyExt on String {
  void foo() {}
}

extension NumberParsing on String {
  int parseInt() => int.parse(this);
}

augment extension MyExt {
  augment void foo() {
    print('augmented');
  }
}

// ─── Top-level Constants & Variables ─────────────────────────────────────────

const String kAppName = "SyntaxShowcase";
const int kMaxRetries = 3;
const double kGoldenRatio = 1.6180339887;
const List<String> kSupportedLocales = ['en', 'es', 'fr', 'de', 'ja'];

final Uri kBaseUri = Uri.parse('https://example.com/api/v1');
late final String kComputedOnce;

var _instanceCounter = 0;

// ─── Misc ─────────────────────────────────────────────────────────────

var buffers = charCodes.map(StringBuffer.new);

// ─── Enumerations ─────────────────────────────────────────────────────────────

enum Direction { north, south, east, west }

enum Planet {
  mercury(3.303e+23, 2.4397e6),
  venus(4.869e+24, 6.0518e6),
  earth(5.976e+24, 6.37814e6),
  mars(6.421e+23, 3.3972e6);

  const Planet(this.mass, this.radius);

  final double mass;
  final double radius;

  static const double G = 6.67430e-11;

  double get surfaceGravity => G * mass / (radius * radius);
  double surfaceWeight(double otherMass) => otherMass * surfaceGravity;

  @override
  String toString() => 'Planet.$name (gravity: ${surfaceGravity.toStringAsFixed(2)})';
}

// ─── Type Aliases ─────────────────────────────────────────────────────────────

typedef Predicate<T> = bool Function(T value);
typedef AsyncMapper<A, B> = Future<B> Function(A input);
typedef JsonMap = Map<String, dynamic>;

// ─── Abstract Classes & Interfaces ───────────────────────────────────────────

abstract class Shape {
  const Shape({required this.color});

  final String color;

  double get area;
  double get perimeter;

  void describe() {
    print('$runtimeType [$color]: area=${area.toStringAsFixed(2)}, '
        'perimeter=${perimeter.toStringAsFixed(2)}');
  }
}

abstract interface class Serializable {
  JsonMap toJson();
  String toJsonString() => jsonEncode(toJson());
}

abstract interface class Drawable {
  void draw(StringBuffer canvas);
}

// ─── Mixins ───────────────────────────────────────────────────────────────────

mixin Identifiable {
  late final int id = ++_instanceCounter;
  String get label => '${runtimeType}#$id';
}

mixin Loggable on Shape {
  final List<String> _log = [];

  void log(String message) {
    final entry = '[${DateTime.now().toIso8601String()}] $message';
    _log.add(entry);
    print(entry);
  }

  List<String> get logHistory => List.unmodifiable(_log);
}

mixin Comparable2<T> {
  int compareTo2(T other);
  bool operator <(T other) => compareTo2(other) < 0;
  bool operator >(T other) => compareTo2(other) > 0;
}

// ─── Concrete Classes ─────────────────────────────────────────────────────────

final class Circle extends Shape
    with Identifiable, Loggable, Comparable2<Circle>
    implements Serializable, Drawable {
  Circle({required super.color, required this.radius})
      : assert(radius > 0, 'Radius must be positive');

  final double radius;
  double _cachedArea = -1;

  @override
  double get area {
    if (_cachedArea < 0) _cachedArea = math.pi * radius * radius;
    return _cachedArea;
  }

  @override
  double get perimeter => 2 * math.pi * radius;

  @override
  int compareTo2(Circle other) => area.compareTo(other.area);

  @override
  JsonMap toJson() => {
        'type': 'circle',
        'color': color,
        'radius': radius,
        'area': area,
      };

  @override
  void draw(StringBuffer canvas) {
    canvas.writeln('  ○  (r=$radius, color=$color)');
  }

  Circle copyWith({String? color, double? radius}) =>
      Circle(color: color ?? this.color, radius: radius ?? this.radius);

  @override
  String toString() => 'Circle(color: $color, radius: $radius)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Circle &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          radius == other.radius;

  @override
  int get hashCode => Object.hash(color, radius);
}

class Rectangle extends Shape
    with Identifiable
    implements Serializable, Drawable {
  const Rectangle({
    required super.color,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  double get area => width * height;

  @override
  double get perimeter => 2 * (width + height);

  bool get isSquare => width == height;

  @override
  JsonMap toJson() => {
        'type': 'rectangle',
        'color': color,
        'width': width,
        'height': height,
      };

  @override
  void draw(StringBuffer canvas) {
    canvas.writeln('  ▭  (${width}x$height, color=$color)');
  }
}

// ─── Generics ─────────────────────────────────────────────────────────────────

class Stack<T> {
  final _elements = <T>[];

  void push(T item) => _elements.add(item);
  T pop() => _elements.removeLast();
  T peek() => _elements.last;

  bool get isEmpty => _elements.isEmpty;
  int get length => _elements.length;

  Iterable<T> get items => _elements.reversed;

  @override
  String toString() => 'Stack<$T>(${_elements.join(', ')})';
}

class Either<L, R> {
  const Either._left(this._left) : _right = null, _isLeft = true;
  const Either._right(this._right) : _left = null, _isLeft = false;

  factory Either.left(L value) => Either._left(value);
  factory Either.right(R value) => Either._right(value);

  final L? _left;
  final R? _right;
  final bool _isLeft;

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;

  B fold<B>(B Function(L) onLeft, B Function(R) onRight) =>
      _isLeft ? onLeft(_left as L) : onRight(_right as R);

  @override
  String toString() =>
      _isLeft ? 'Left($_left)' : 'Right($_right)';
}

// ─── Extension Methods ────────────────────────────────────────────────────────

extension StringX on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String truncate(int maxLength, {String ellipsis = '…'}) =>
      length <= maxLength ? this : '${substring(0, maxLength)}$ellipsis';

  bool get isPalindrome {
    final clean = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return clean == clean.split('').reversed.join();
  }

  int? tryParseInt() => int.tryParse(this);
}

extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final result = <K, List<T>>{};
    for (final item in this) {
      result.putIfAbsent(keySelector(item), () => []).add(item);
    }
    return result;
  }
}

extension NumX on num {
  bool get isEven => this % 2 == 0;
  bool get isPrime {
    if (this < 2) return false;
    for (int i = 2; i <= math.sqrt(toDouble()); i++) {
      if (this % i == 0) return false;
    }
    return true;
  }

  Duration get seconds => Duration(seconds: toInt());
  Duration get milliseconds => Duration(milliseconds: toInt());
}

extension FutureX<T> on Future<T> {
  Future<T> withTimeout(Duration timeout, {T Function()? onTimeout}) =>
      this.timeout(timeout, onTimeout: onTimeout == null ? null : () => onTimeout());
}

// ─── Records ──────────────────────────────────────────────────────────────────

typedef Point2D = ({double x, double y});
typedef RGB = (int red, int green, int blue);

(String name, int age, String email) parseUserRecord(JsonMap json) {
  return (
    json['name'] as String,
    json['age'] as int,
    json['email'] as String,
  );
}

Point2D midpoint(Point2D a, Point2D b) =>
    (x: (a.x + b.x) / 2, y: (a.y + b.y) / 2);

double distance(Point2D a, Point2D b) {
  final dx = a.x - b.x;
  final dy = a.y - b.y;
  return math.sqrt(dx * dx + dy * dy);
}

// ─── Sealed Classes & Pattern Matching ───────────────────────────────────────

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error, [this.stackTrace]);
  final Object error;
  final StackTrace? stackTrace;
}

final class Loading<T> extends Result<T> {
  const Loading();
}

String describeResult<T>(Result<T> result) => switch (result) {
      Success(:final value) => 'Success: $value',
      Failure(:final error) => 'Failure: $error',
      Loading() => 'Loading…',
    };

// ─── Pattern Matching (exhaustive switch, guards, destructuring) ──────────────

String classifyNumber(num n) => switch (n) {
      0 => 'zero',
      < 0 => 'negative',
      int i when i.isPrime => 'prime ($i)',
      int i when i.isEven => 'even ($i)',
      int() => 'odd int',
      double d when d.isInfinite => 'infinite',
      double d when d.isNaN => 'NaN',
      _ => 'other ($n)',
    };

void demonstratePatterns() {
  // List patterns
  const list = [1, 2, 3, 4, 5];
  final [first, second, ...rest] = list;
  print('first=$first, second=$second, rest=$rest');

  // Map patterns
  final json = {'name': 'Alice', 'age': 30, 'active': true};
  if (json case {'name': String name, 'age': int age}) {
    print('Name: $name, Age: $age');
  }

  // Object patterns
  final shape = Circle(color: 'red', radius: 5.0);
  if (shape case Circle(radius: > 3.0, color: final c)) {
    print('Large circle in $c');
  }

  // Record patterns
  final record = ('hello', 42, true);
  final (str, num2, flag) = record;
  print('$str, $num2, $flag');
}

// ─── Async / Await / Streams ──────────────────────────────────────────────────

Future<String> fetchUserName(int id) async {
  await Future.delayed(50.milliseconds);
  if (id <= 0) throw ArgumentError('Invalid ID: $id');
  return 'User_$id';
}

Future<List<String>> fetchAllUsers(List<int> ids) async {
  return Future.wait(ids.map(fetchUserName));
}

Future<Either<String, int>> safeDivide(int a, int b) async {
  if (b == 0) return Either.left('Division by zero');
  return Either.right(a ~/ b);
}

Stream<int> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    yield i;
    await Future.delayed(1.milliseconds);
  }
}

Stream<String> transformStream(Stream<int> source) async* {
  await for (final value in source) {
    if (value % 2 == 0) yield 'even:$value';
  }
}

Stream<int> fibonacci() sync* {
  int a = 0, b = 1;
  while (true) {
    yield a;
    final next = a + b;
    a = b;
    b = next;
  }
}

// ─── Isolates (conceptual stub) ───────────────────────────────────────────────

Future<int> heavyComputation(int n) async {
  // In real code: return Isolate.run(() => _expensiveWork(n));
  return _expensiveWork(n);
}

int _expensiveWork(int n) => List.generate(n, (i) => i).fold(0, (a, b) => a + b);

// ─── Collections & Functional Operations ─────────────────────────────────────

void demonstrateCollections() {
  // List literals & spread
  final primes = [2, 3, 5, 7, 11, 13];
  final extended = [...primes, 17, 19, 23];

  // Conditional elements
  const debug = true;
  final config = [
    'release',
    if (debug) 'debug_symbols',
    if (debug) ...['-O0', '--no-tree-shake'],
  ];

  // Set
  final vowels = <String>{'a', 'e', 'i', 'o', 'u'};
  final consonants = 'hello world'.split('').toSet().difference(vowels);

  // Map literals
  final scores = <String, int>{
    'Alice': 95,
    'Bob': 87,
    'Carol': 92,
    for (final name in ['Dave', 'Eve']) name: 0,
  };

  // Functional pipeline
  final topStudents = scores.entries
      .where((e) => e.value >= 90)
      .map((e) => e.key.capitalize)
      .toList()
    ..sort();

  // Queue and LinkedHashMap
  final queue = Queue<int>()..addAll(primes);
  final ordered = LinkedHashMap<String, int>.from(scores);

  // Int32List / typed data
  final typedList = Int32List.fromList(primes);

  print('extended: $extended');
  print('config: $config');
  print('consonants: $consonants');
  print('topStudents: $topStudents');
  print('typed: $typedList');
  _ = ordered; // suppress unused warning
  _ = queue;
}

// ─── Closures & Higher-Order Functions ───────────────────────────────────────

Function compose(Function f, Function g) => (x) => f(g(x));

List<T> myMap<T, U>(List<U> list, T Function(U) f) => [for (final x in list) f(x)];

List<T> myFilter<T>(List<T> list, Predicate<T> pred) =>
    [for (final x in list if pred(x)) x];

U myFold<T, U>(List<T> list, U init, U Function(U, T) f) {
  var acc = init;
  for (final x in list) acc = f(acc, x);
  return acc;
}

Function memoize(Function f) {
  final cache = <dynamic, dynamic>{};
  return (x) => cache.putIfAbsent(x, () => f(x));
}

// ─── Operator Overloading ─────────────────────────────────────────────────────

class Vector2 {
  const Vector2(this.x, this.y);

  final double x, y;

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);
  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);
  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);
  Vector2 operator /(double scalar) => Vector2(x / scalar, y / scalar);
  Vector2 operator -() => Vector2(-x, -y);

  double operator [](int index) => switch (index) {
        0 => x,
        1 => y,
        _ => throw RangeError('Index $index out of range for Vector2'),
      };

  double get magnitude => math.sqrt(x * x + y * y);
  Vector2 get normalized => this / magnitude;
  double dot(Vector2 other) => x * other.x + y * other.y;

  @override
  String toString() => 'Vector2($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is Vector2 && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

// ─── Exception Handling ───────────────────────────────────────────────────────

class AppException implements Exception {
  const AppException(this.message, {this.code = 0});
  final String message;
  final int code;

  @override
  String toString() => 'AppException(code=$code): $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {required this.statusCode})
      : super(code: statusCode);
  final int statusCode;
}

Future<String> riskyOperation(int attempt) async {
  try {
    if (attempt < 0) throw ArgumentError.value(attempt, 'attempt', 'Must be ≥ 0');
    if (attempt == 0) throw const NetworkException('Not found', statusCode: 404);
    if (attempt == 1) throw const NetworkException('Server error', statusCode: 500);
    return await fetchUserName(attempt);
  } on NetworkException catch (e, st) {
    print('Network error ${e.statusCode}: ${e.message}\n$st');
    rethrow;
  } on AppException catch (e) {
    print('App error: $e');
    return 'fallback';
  } catch (e) {
    print('Unknown error: $e');
    return 'unknown';
  } finally {
    print('riskyOperation($attempt) finished.');
  }
}

// ─── Annotations & Metadata ───────────────────────────────────────────────────

@Deprecated('Use newFunction() instead')
void oldFunction() => print('old');

@pragma('vm:prefer-inline')
int fastAdd(int a, int b) => a + b;

class Route {
  const Route(this.path);
  final String path;
}

@Route('/home')
class HomeController {
  @Route('/index')
  void index() => print('Home index');
}

// ─── Null Safety ──────────────────────────────────────────────────────────────

String greet(String? name) {
  final displayName = name ?? 'stranger';
  return 'Hello, ${displayName.capitalize}!';
}

int? tryFindIndex(List<int> list, int target) {
  final idx = list.indexOf(target);
  return idx >= 0 ? idx : null;
}

void demonstrateNullSafety() {
  String? nullable;
  final length = nullable?.length ?? 0;         // null-aware access
  final upper = nullable?.toUpperCase();         // still nullable
  nullable ??= 'default';                        // null-coalescing assignment
  final forced = nullable!;                      // null assertion
  print('$length $upper $forced');
}

// ─── String Interpolation & Multi-line Strings ───────────────────────────────

String buildReport(List<Shape> shapes) {
  final buffer = StringBuffer();
  buffer.writeln('''
╔══════════════════════════════════╗
║         SHAPE  REPORT            ║
╠══════════════════════════════════╣''');

  for (final (i, shape) in shapes.indexed) {
    final row = '  ${(i + 1).toString().padLeft(2)}. '
        '${shape.runtimeType.toString().padRight(12)} '
        'area=${shape.area.toStringAsFixed(3).padLeft(10)}';
    buffer.writeln(row);
  }

  buffer.writeln('╚══════════════════════════════════╝');
  buffer.write('  Total: ${shapes.length} shape(s)');
  return buffer.toString();
}

const rawString = r'No \n escape here: $variable';
const multiline = '''
  Line one
  Line two
  Line three
''';

// ─── Regular Expressions ──────────────────────────────────────────────────────

final _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
);

final _phoneRegex = RegExp(r'(\+\d{1,3})?\s?(\(?\d{3}\)?[\s.\-]?\d{3}[\s.\-]?\d{4})');

bool isValidEmail(String email) => _emailRegex.hasMatch(email);

Iterable<RegExpMatch> findPhones(String text) => _phoneRegex.allMatches(text);

// ─── Cascade Notation ────────────────────────────────────────────────────────

StringBuffer buildMessage() => StringBuffer()
  ..write('Hello')
  ..write(', ')
  ..write('World')
  ..writeln('!')
  ..writeln('From Dart.');

List<int> buildList() => <int>[]
  ..addAll([1, 2, 3])
  ..add(4)
  ..addAll([5, 6, 7])
  ..sort((a, b) => b - a); // descending

// ─── Zone & Error Zones ───────────────────────────────────────────────────────

Future<void> runInZone() async {
  await runZonedGuarded(
    () async {
      // Zone-protected async work
      final result = await fetchUserName(42);
      print('Zone result: $result');
    },
    (error, stack) {
      print('Caught in zone: $error');
    },
  );
}

// ─── Completer & Custom Futures ───────────────────────────────────────────────

Future<int> delayedValue(int value, Duration delay) {
  final completer = Completer<int>();
  Future.delayed(delay, () => completer.complete(value));
  return completer.future;
}

// ─── StreamController ────────────────────────────────────────────────────────

class EventBus<T> {
  final _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;
  void emit(T event) => _controller.add(event);
  Future<void> close() => _controller.close();
}

// ─── Entry Point ──────────────────────────────────────────────────────────────

void main(List<String> args) async {
  // ── Late initialization ─────────────────────────────────────────────────
  kComputedOnce = Platform.operatingSystem;

  // ── Basic types & arithmetic ────────────────────────────────────────────
  const int i = 42;
  const double d = 3.14;
  const bool b = true;
  const String s = 'Dart';
  final bigInt = BigInt.parse('9007199254740993');

  print('i=$i, d=$d, b=$b, s=$s, bigInt=$bigInt');
  print('Bitwise: ${i & 0xFF}, ${i | 0x100}, ${i ^ 0x2A}, ${i << 2}, ${i >> 1}');
  print('Integer division: ${10 ~/ 3}, remainder: ${10 % 3}');

  // ── Enums ───────────────────────────────────────────────────────────────
  for (final planet in Planet.values) {
    print('$planet weight(75kg)=${planet.surfaceWeight(75).toStringAsFixed(2)}N');
  }

  final dir = Direction.north;
  final label = switch (dir) {
    Direction.north => '↑ North',
    Direction.south => '↓ South',
    Direction.east  => '→ East',
    Direction.west  => '← West',
  };
  print(label);

  // ── Objects & polymorphism ───────────────────────────────────────────────
  final shapes = <Shape>[
    Circle(color: 'red', radius: 5),
    Circle(color: 'blue', radius: 3),
    Rectangle(color: 'green', width: 4, height: 6),
    Rectangle(color: 'yellow', width: 7, height: 7),
  ];

  for (final shape in shapes) {
    shape.describe();
    if (shape is Drawable) {
      final sb = StringBuffer();
      shape.draw(sb);
      stdout.write(sb);
    }
    if (shape case Rectangle(isSquare: true, :final color)) {
      print('  ^ That\'s a $color square!');
    }
  }

  print(buildReport(shapes));

  // ── Generics & records ───────────────────────────────────────────────────
  final stack = Stack<String>()
    ..push('first')
    ..push('second')
    ..push('third');

  while (!stack.isEmpty) print('Popped: ${stack.pop()}');

  final p1 = (x: 0.0, y: 0.0);
  final p2 = (x: 3.0, y: 4.0);
  print('Distance: ${distance(p1, p2)}, midpoint: ${midpoint(p1, p2)}');

  // ── Collections ──────────────────────────────────────────────────────────
  demonstrateCollections();

  // ── Pattern matching ─────────────────────────────────────────────────────
  demonstratePatterns();

  for (final n in [-5, 0, 1, 2, 7, 9, 12, 13, double.infinity, double.nan]) {
    print('$n → ${classifyNumber(n)}');
  }

  // ── Either monad ─────────────────────────────────────────────────────────
  final r1 = await safeDivide(10, 3);
  final r2 = await safeDivide(10, 0);
  print(r1.fold((e) => 'Error: $e', (v) => 'Result: $v'));
  print(r2.fold((e) => 'Error: $e', (v) => 'Result: $v'));

  // ── Async / Streams ──────────────────────────────────────────────────────
  final users = await fetchAllUsers([1, 2, 3, 4, 5]);
  print('Users: $users');

  final evens = await transformStream(countDown(10)).toList();
  print('Even countdown: $evens');

  final fibs = fibonacci().take(10).toList();
  print('Fibonacci: $fibs');

  // ── Extensions ───────────────────────────────────────────────────────────
  print('racecar'.isPalindrome);         // true
  print('hello'.capitalize);            // Hello
  print('Long text here'.truncate(7)); // Long te…
  print(13.isPrime);                    // true

  // ── Vectors & operator overloading ───────────────────────────────────────
  const v1 = Vector2(3, 4);
  const v2 = Vector2(1, 2);
  print('v1+v2=${v1 + v2}, magnitude=${v1.magnitude}, normalized=${v1.normalized}');
  print('v1·v2=${v1.dot(v2)}, -v1=${-v1}, v1[0]=${v1[0]}');

  // ── Cascades ─────────────────────────────────────────────────────────────
  print(buildMessage());
  print(buildList());

  // ── Null safety ──────────────────────────────────────────────────────────
  print(greet(null));
  print(greet('alice'));
  demonstrateNullSafety();

  // ── Closures & HOF ───────────────────────────────────────────────────────
  final doubleIt = (int x) => x * 2;
  final addTen = (int x) => x + 10;
  final doubleAndAdd = compose(addTen, doubleIt);
  print(doubleAndAdd(5)); // 20

  final nums = List.generate(10, (i) => i);
  final squaredEvens = myFilter(myMap(nums, (x) => x * x), (x) => x.isEven);
  final sum = myFold<int, int>(squaredEvens, 0, (a, b) => a + b);
  print('Sum of squared evens: $sum');

  // ── Memoization ──────────────────────────────────────────────────────────
  final memoFib = memoize((int n) => n <= 1 ? n : n - 1 + (n - 2));
  print(memoFib(10));

  // ── Regex ────────────────────────────────────────────────────────────────
  print(isValidEmail('user@example.com'));  // true
  print(isValidEmail('not-an-email'));       // false

  // ── Error handling ───────────────────────────────────────────────────────
  for (int attempt in [2, 1, 0]) {
    try {
      final name = await riskyOperation(attempt);
      print('Got: $name');
    } on NetworkException catch (e) {
      print('Handled outside: ${e.statusCode}');
    }
  }

  // ── Serialisation ─────────────────────────────────────────────────────────
  final circle = Circle(color: 'purple', radius: 2.5);
  final jsonStr = circle.toJsonString();
  print('JSON: $jsonStr');
  final decoded = jsonDecode(jsonStr) as JsonMap;
  print('Decoded type: ${decoded['type']}');

  // ── Typed data ───────────────────────────────────────────────────────────
  final bytes = Uint8List.fromList([72, 101, 108, 108, 111]);
  print(String.fromCharCodes(bytes)); // Hello

  // ── Zone ─────────────────────────────────────────────────────────────────
  await runInZone();

  // ── Completer ────────────────────────────────────────────────────────────
  final val = await delayedValue(99, 1.milliseconds);
  print('Delayed value: $val');

  // ── EventBus ─────────────────────────────────────────────────────────────
  final bus = EventBus<String>();
  final sub = bus.stream.listen((e) => print('Event: $e'));
  bus
    ..emit('startup')
    ..emit('data_loaded')
    ..emit('shutdown');
  await Future.delayed(1.milliseconds);
  await sub.cancel();
  await bus.close();

  // ── String constants ─────────────────────────────────────────────────────
  print(rawString);
  print(multiline);
  print('Platform: $kComputedOnce');
  print('Done — $kAppName');
}

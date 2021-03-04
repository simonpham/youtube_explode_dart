library _youtube_explode.extensions;

import '../reverse_engineering/cipher/cipher_operations.dart';

/// Utility for Strings.
extension StringUtility on String {
  /// Returns null if this string is whitespace.
  String? get nullIfWhitespace => trim().isEmpty ? null : this;

  /// Returns null if this string is a whitespace.
  String substringUntil(String separator) => substring(0, indexOf(separator));

  ///
  String substringAfter(String separator) =>
      substring(indexOf(separator) + separator.length);

  static final _exp = RegExp(r'\D');

  /// Strips out all non digit characters.
  String stripNonDigits() => replaceAll(_exp, '');

  ///
  String extractJson() {
    var buffer = StringBuffer();
    var depth = 0;

    for (var i = 0; i < length; i++) {
      var ch = this[i];
      var chPrv = i > 0 ? this[i - 1] : '';

      buffer.write(ch);

      if (ch == '{' && chPrv != '\\') {
        depth++;
      } else if (ch == '}' && chPrv != '\\') {
        depth--;
      }

      if (depth == 0) {
        break;
      }
    }
    return buffer.toString();
  }
}

/// Utility for Strings.
extension StringUtility2 on String? {
  /// Parses this value as int stripping the non digit characters,
  /// returns null if this fails.
  int? parseInt() => int.tryParse(this?.stripNonDigits() ?? '');

  /// Returns true if the string is null or empty.
  bool get isNullOrWhiteSpace {
    if (this == null) {
      return true;
    }
    if (this!.trim().isEmpty) {
      return true;
    }
    return false;
  }
}

/// List decipher utility.
extension ListDecipher on Iterable<CipherOperation> {
  /// Apply every CipherOperation on the [signature]
  String decipher(String signature) {
    for (var operation in this) {
      signature = operation.decipher(signature);
    }

    return signature;
  }
}

/// List Utility.
extension ListUtil<E> on Iterable<E> {
  /// Returns the first element of a list or null if empty.
  E? get firstOrNull {
    if (length == 0) {
      return null;
    }
    return first;
  }

  /// Same as [elementAt] but if the index is higher than the length returns
  /// null
  E? elementAtSafe(int index) {
    if (index >= length) {
      return null;
    }
    return elementAt(index);
  }

  /// Same as [firstWhere] but returns null if no found
  E? firstWhereNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

/// Uri utility
extension UriUtility on Uri {
  /// Returns a new Uri with the new query parameters set.
  Uri setQueryParam(String key, String value) {
    var query = Map<String, String>.from(queryParameters);

    query[key] = value;

    return replace(queryParameters: query);
  }
}

///
extension GetOrNull<K, V> on Map<K, V> {
  /// Get a value from a map
  V? getValue(K key) {
    var v = this[key];
    if (v == null) {
      return null;
    }
    return v;
  }
}

///
extension GetOrNullMap on Map {
  /// Get a map inside a map
  Map<String, dynamic>? get(String key) {
    var v = this[key];
    if (v == null) {
      return null;
    }
    return v;
  }

  /// Get a value inside a map.
  /// If it is null this returns null, if of another type this throws.
  T? getT<T>(String key) {
    var v = this[key];
    if (v == null) {
      return null;
    }
    if (v is! T) {
      throw Exception('Invalid type: ${v.runtimeType} should be $T');
    }
    return v;
  }

  /// Get a List<Map<String, dynamic>>> from a map.
  List<Map<String, dynamic>>? getList(String key) {
    var v = this[key];
    if (v == null) {
      return null;
    }
    if (v is! List<dynamic>) {
      throw Exception('Invalid type: ${v.runtimeType} should be of type List');
    }

    return (v.toList()).cast<Map<String, dynamic>>();
  }
}

///
extension UriUtils on Uri {
  ///
  Uri replaceQueryParameters(Map<String, String> parameters) {
    var query = Map<String, String>.from(queryParameters);
    query.addAll(parameters);

    return replace(queryParameters: query);
  }
}

/// Parse properties with `text` method.
extension RunsParser on List<dynamic> {
  ///
  String parseRuns() => map((e) => e['text']).join() ?? '';
}

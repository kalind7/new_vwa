const _fieldSeparator = ' · ';

/// Generic API envelopes that should not override specific [errors] entries.
const _genericMessages = {
  'validation error',
  'the given data was invalid.',
  'unprocessable entity',
  'unprocessable content',
  'bad request',
  'error',
  'request failed',
  'failed',
};

/// User-facing text for toasts and [Failure.message] from API error JSON.
String? formatApiErrorForUser(dynamic data) {
  final parsed = parseApiErrorResponse(data);
  return parsed.toUserMessage();
}

/// Backward-compatible alias used by older call sites.
String? messageFromApiResponse(dynamic data) => formatApiErrorForUser(data);

/// Structured API error body (Laravel / bike-wash API shapes).
class ParsedApiError {
  const ParsedApiError({
    this.headline,
    this.fieldErrors = const [],
    this.usedFieldErrorsOverHeadline = false,
  });

  final String? headline;
  final List<ApiFieldError> fieldErrors;
  final bool usedFieldErrorsOverHeadline;

  String? toUserMessage() {
    if (fieldErrors.isNotEmpty && usedFieldErrorsOverHeadline) {
      return _formatFieldErrorsForToast(fieldErrors);
    }
    if (headline != null && headline!.isNotEmpty) {
      return headline;
    }
    if (fieldErrors.isNotEmpty) {
      return _formatFieldErrorsForToast(fieldErrors);
    }
    return null;
  }
}

class ApiFieldError {
  const ApiFieldError({required this.field, required this.message});

  final String field;
  final String message;

  String get displayLine {
    final label = _labelForField(field);
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains(field.toLowerCase()) ||
        lowerMessage.contains(label.toLowerCase())) {
      return message;
    }
    return '$label: $message';
  }
}

ParsedApiError parseApiErrorResponse(dynamic data) {
  if (data == null) {
    return const ParsedApiError();
  }

  if (data is String) {
    final trimmed = data.trim();
    return ParsedApiError(headline: trimmed.isEmpty ? null : trimmed);
  }

  if (data is! Map) {
    return const ParsedApiError();
  }

  final map = Map<String, dynamic>.from(data);
  final headline = _readString(map['message']);
  final fieldErrors = _collectFieldErrors(map['errors']);

  if (map['error'] is String) {
    final errorString = _readString(map['error']);
    if (errorString != null && fieldErrors.isEmpty) {
      return ParsedApiError(headline: errorString);
    }
  }

  if (map['error'] is Map) {
    final nested = parseApiErrorResponse(map['error']);
    if (nested.fieldErrors.isNotEmpty || nested.headline != null) {
      return ParsedApiError(
        headline: nested.headline ?? headline,
        fieldErrors: nested.fieldErrors.isNotEmpty
            ? nested.fieldErrors
            : fieldErrors,
        usedFieldErrorsOverHeadline: nested.usedFieldErrorsOverHeadline,
      );
    }
  }

  final dataField = map['data'];
  if (dataField is Map && fieldErrors.isEmpty) {
    return parseApiErrorResponse(dataField);
  }

  final useFieldErrors = fieldErrors.isNotEmpty &&
      (headline == null || _isGenericMessage(headline));

  return ParsedApiError(
    headline: headline,
    fieldErrors: fieldErrors,
    usedFieldErrorsOverHeadline: useFieldErrors,
  );
}

List<ApiFieldError> _collectFieldErrors(dynamic errors) {
  if (errors is! Map) {
    return const [];
  }

  final result = <ApiFieldError>[];
  for (final entry in errors.entries) {
    final message = _firstStringFromErrorValue(entry.value);
    if (message != null) {
      result.add(
        ApiFieldError(field: entry.key.toString(), message: message),
      );
    }
  }
  return result;
}

String _formatFieldErrorsForToast(List<ApiFieldError> errors) {
  if (errors.length == 1) {
    return errors.first.displayLine;
  }
  return errors.map((error) => error.displayLine).join(_fieldSeparator);
}

bool _isGenericMessage(String message) {
  return _genericMessages.contains(message.trim().toLowerCase());
}

String? _firstStringFromErrorValue(dynamic value) {
  if (value is List) {
    for (final item in value) {
      if (item is String) {
        final trimmed = item.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
    }
    return null;
  }
  return _readString(value);
}

String? _readString(dynamic value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String _labelForField(String field) {
  final normalized = field.replaceAll('_', ' ').trim();
  if (normalized.isEmpty) {
    return 'Error';
  }
  return normalized[0].toUpperCase() +
      (normalized.length > 1 ? normalized.substring(1) : '');
}

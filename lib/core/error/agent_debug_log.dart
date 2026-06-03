import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Debug-session NDJSON log (dev / emulator with workspace access only).
void agentDebugLog({
  required String hypothesisId,
  required String location,
  required String message,
  Map<String, dynamic>? data,
  String runId = 'pre-fix',
}) {
  if (!kDebugMode) {
    return;
  }
  try {
    const logPath =
        '/home/kalind7/visual_studio_projects/new_vwa/VWA/.cursor/debug-306b20.log';
    final payload = <String, dynamic>{
      'sessionId': '306b20',
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data ?? <String, dynamic>{},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'runId': runId,
    };
    File(logPath).writeAsStringSync(
      '${jsonEncode(payload)}\n',
      mode: FileMode.append,
    );
  } catch (_) {
    // Ignore when running on a device without workspace access.
  }
}

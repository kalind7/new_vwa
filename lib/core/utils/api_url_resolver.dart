import '../../config/app_config.dart';

/// Resolves relative API asset paths (e.g. `/img/default-avatar.jpg`) to absolute URLs.
String? resolveApiAssetUrl(String? path) {
  if (path == null || path.trim().isEmpty) {
    return null;
  }

  final trimmed = path.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final base = AppConfig.apiBaseUrl;
  final origin = base.endsWith('/api/v1/')
      ? base.substring(0, base.length - 'api/v1/'.length)
      : (base.endsWith('/') ? base : '$base/');

  if (trimmed.startsWith('/')) {
    return '$origin${trimmed.substring(1)}';
  }
  return '$origin$trimmed';
}

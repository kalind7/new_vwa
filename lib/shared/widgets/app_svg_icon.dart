import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppSvgIconName {
  arrowLeft,
  calendar,
  card,
  chevronRight,
  clock,
  filter,
  home,
  location,
  notification,
  payment,
  profile,
  route,
  search,
  star,
  success,
  wash,
  bike,
  bookmark,
  wallet,
  close,
  gift,
  logOut,
}

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.color = Colors.black,
  });

  final AppSvgIconName name;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svgFor(name),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

String _svgFor(AppSvgIconName name) {
  return switch (name) {
    AppSvgIconName.arrowLeft => _svg('<path d="M19 12H5M12 19l-7-7 7-7"/>'),
    AppSvgIconName.calendar => _svg(
      '<path d="M8 3v3M16 3v3M4.5 9.5h15M6.5 5h11A2.5 2.5 0 0 1 20 7.5v10A2.5 2.5 0 0 1 17.5 20h-11A2.5 2.5 0 0 1 4 17.5v-10A2.5 2.5 0 0 1 6.5 5Z"/>',
    ),
    AppSvgIconName.card => _svg(
      '<path d="M4 7.5A2.5 2.5 0 0 1 6.5 5h11A2.5 2.5 0 0 1 20 7.5v9A2.5 2.5 0 0 1 17.5 19h-11A2.5 2.5 0 0 1 4 16.5v-9ZM4 9h16M7 15h4"/>',
    ),
    AppSvgIconName.chevronRight => _svg('<path d="m9 18 6-6-6-6"/>'),
    AppSvgIconName.clock => _svg(
      '<path d="M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM12 7.5V12l3 2"/>',
    ),
    AppSvgIconName.filter => _svg('<path d="M5 7h14M8 12h8M10.5 17h3"/>'),
    AppSvgIconName.home => _svg(
      '<path d="M4 10.5 12 4l8 6.5V19a1 1 0 0 1-1 1h-5v-6h-4v6H5a1 1 0 0 1-1-1v-8.5Z"/>',
    ),
    AppSvgIconName.location => _svg(
      '<path d="M12 21s7-5.2 7-11.2A7 7 0 1 0 5 9.8C5 15.8 12 21 12 21Z"/><path d="M12 12.3a2.4 2.4 0 1 0 0-4.8 2.4 2.4 0 0 0 0 4.8Z"/>',
    ),
    AppSvgIconName.notification => _svg(
      '<path d="M18 9.5a6 6 0 1 0-12 0c0 7-3 6.5-3 8h18c0-1.5-3-.9-3-8ZM9.5 20a2.5 2.5 0 0 0 5 0"/>',
    ),
    AppSvgIconName.payment => _svg(
      '<path d="M6.5 4.5h11A2.5 2.5 0 0 1 20 7v10a2.5 2.5 0 0 1-2.5 2.5h-11A2.5 2.5 0 0 1 4 17V7a2.5 2.5 0 0 1 2.5-2.5ZM8 9h8M8 13h4"/>',
    ),
    AppSvgIconName.profile => _svg(
      '<path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM4.5 20a7.5 7.5 0 0 1 15 0"/>',
    ),
    AppSvgIconName.route => _svg(
      '<path d="M6.5 18.5C4.6 18.5 3 16.9 3 15s1.6-3.5 3.5-3.5h11A3.5 3.5 0 1 0 14 8M14 8l-2.5 2.5M14 8l-2.5-2.5M7 18.5l2-2M7 18.5l2 2"/>',
    ),
    AppSvgIconName.search => _svg(
      '<path d="m20 20-4.2-4.2M18 11a7 7 0 1 1-14 0 7 7 0 0 1 14 0Z"/>',
    ),
    AppSvgIconName.star => _svg(
      '<path d="m12 3 2.6 5.3 5.9.9-4.3 4.1 1 5.8L12 16.4 6.8 19l1-5.8-4.3-4.1 5.9-.9L12 3Z"/>',
    ),
    AppSvgIconName.success => _svg(
      '<path d="M21 11.1V12a9 9 0 1 1-5.3-8.2"/><path d="m21 4-9 9-2.7-2.7"/>',
    ),
    AppSvgIconName.wash => _svg(
      '<path d="M12 3s5 5.3 5 9a5 5 0 0 1-10 0c0-3.7 5-9 5-9Z"/><path d="M8.5 17.5c2.3 1.4 4.7 1.4 7 0"/>',
    ),
    AppSvgIconName.bike => _svg(
      '<path d="M6.5 18.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM17.5 18.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM9 15.5h4l-2-5h3l3.5 5M6.5 15.5l3.5-5h1"/>',
    ),
    AppSvgIconName.bookmark => _svg(
      '<path d="M7 4.5h10A1.5 1.5 0 0 1 18.5 6v14l-6.5-4-6.5 4V6A1.5 1.5 0 0 1 7 4.5Z"/>',
    ),
    AppSvgIconName.wallet => _svg(
      '<path d="M5.5 6h12A2.5 2.5 0 0 1 20 8.5v8A2.5 2.5 0 0 1 17.5 19h-12A2.5 2.5 0 0 1 3 16.5v-8A2.5 2.5 0 0 1 5.5 6Z"/><path d="M16 12.5h4M6 6V4.5h10V6"/>',
    ),
    AppSvgIconName.close => _svg('<path d="m6 6 12 12M18 6 6 18"/>'),
    AppSvgIconName.gift => _svg(
      '<path d="M20 12v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8M12 22V12M12 12H7.5a2.5 2.5 0 0 1 0-5C9 7 12 12 12 12ZM12 12h4.5a2.5 2.5 0 0 0 0-5C15 7 12 12 12 12ZM4.5 12h15M12 7V4"/>',
    ),
    AppSvgIconName.logOut => _svg(
      '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>',
    ),
  };
}

String _svg(String paths) {
  return '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none"
  xmlns="http://www.w3.org/2000/svg">
  <g stroke="currentColor" stroke-width="1.8" stroke-linecap="round"
    stroke-linejoin="round">
    $paths
  </g>
</svg>
''';
}

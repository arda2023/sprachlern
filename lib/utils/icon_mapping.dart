import 'package:flutter/widgets.dart';
import 'package:forui/assets.dart';

// Add icon names here when new catalog stacks use additional icons.
IconData iconForName(String name) => switch (name) {
  'bookOpen' => FLucideIcons.bookOpen,
  'messagesSquare' => FLucideIcons.messagesSquare,
  'folderOpen' => FLucideIcons.folderOpen,
  _ => FLucideIcons.bookOpen,
};

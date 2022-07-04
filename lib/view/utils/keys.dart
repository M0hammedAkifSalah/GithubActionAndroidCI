import 'package:flutter/material.dart';

class WidgetKeys {
  static final GlobalKey<PopupMenuButtonState> assignment =
      GlobalKey<PopupMenuButtonState>(debugLabel: 'Assignment');
  static final GlobalKey<PopupMenuButtonState> event =
      GlobalKey<PopupMenuButtonState>(debugLabel: 'Event');
  static final GlobalKey<PopupMenuButtonState> announcement =
      GlobalKey<PopupMenuButtonState>(debugLabel: 'Announcement');
  static final GlobalKey<PopupMenuButtonState> livePoll =
      GlobalKey<PopupMenuButtonState>(debugLabel: 'Live Poll');
  static final GlobalKey<PopupMenuButtonState> checkList =
      GlobalKey<PopupMenuButtonState>(debugLabel: 'CheckList');
}

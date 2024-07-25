import 'package:flutter/material.dart';

/// A widget that manages the visibility of its child based on the app's lifecycle state.
///
/// The [AppVisibilityManager] listens to the app's lifecycle changes and updates the visibility
/// of the child widget accordingly. When the app is inactive or paused, the child widget is hidden,
/// and a custom image is displayed. When the app resumes, the child widget is shown again.
///
/// The [child] parameter is the main widget that will be managed, and the [image] parameter is the
/// widget that will be displayed when the [child] is hidden.
class AppVisibilityManager extends StatefulWidget {
  /// Creates an [AppVisibilityManager].
  ///
  /// The [child] and [image] parameters must not be null.
  const AppVisibilityManager({
    required this.child,
    required this.image,
    super.key,
  });

  /// The widget that will be managed and displayed when the app is active.
  final Widget child;

  /// The widget that will be displayed when the app is inactive or paused.
  final Widget image;

  @override
  AppVisibilityManagerState createState() => AppVisibilityManagerState();
}

class AppVisibilityManagerState extends State<AppVisibilityManager>
    with WidgetsBindingObserver {
  final ValueNotifier<bool> _isUIVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isUIVisible.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _isUIVisible.value = false;
    } else if (state == AppLifecycleState.resumed) {
      _isUIVisible.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isUIVisible,
      builder: (context, isUIVisible, child) {
        return Stack(
          children: <Widget>[
            widget.child,
            if (!isUIVisible)
              Scaffold(
                body: Center(child: widget.image),
              ),
          ],
        );
      },
    );
  }
}

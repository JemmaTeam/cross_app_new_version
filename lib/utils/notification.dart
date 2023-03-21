import 'package:flutter/material.dart';

enum NotificationType{
  success,
  error,
  info
}

/// Shows notification in a Scaffold and returns it's controller.
/// Returns a controller to know when the SnackBar has been closed.
///
/// Example:
/// ```dart
///  showNotification(context,"Put your msg here",NotificationType.info, duration:Duration(seconds:4));
/// ```
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showNotification(
    BuildContext context,
    String notificationMessage,
    NotificationType type,
    {duration = const Duration(seconds: 2)}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(notificationMessage, textAlign: TextAlign.center,),
      duration: duration,
      width: 200.0,
      backgroundColor: _getColor(type),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}


/// Returns color for the SnackBar, given a NotificationType.
_getColor(NotificationType type){
  switch(type){
    case NotificationType.success:
      return Colors.green;
    case NotificationType.error:
      return Colors.red;
    case NotificationType.info:
      return Colors.blue;
  }
}
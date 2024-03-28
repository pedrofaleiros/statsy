import 'package:flutter/material.dart';

bool isWaiting(AsyncSnapshot<Object?> snapshot) {
  return snapshot.connectionState == ConnectionState.waiting;
}

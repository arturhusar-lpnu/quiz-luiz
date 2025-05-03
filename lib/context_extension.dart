import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension SafeBlocAccess on BuildContext {
  T? maybeRead<T>() {
    try {
      return read<T>();
    } catch (_) {
      return null;
    }
  }
}
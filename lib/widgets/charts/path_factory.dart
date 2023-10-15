// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';

typedef TimeValue = ({int t, int v});
typedef TimeStatus = ({int t, SampleStatus s});

abstract class PathFactory {
  /// Object pool for paths to avoid creating them on every frame (and avoid GC)
  static final Map<String, dynamic> _pathsPool = {};

  static clearPool() => _pathsPool.clear();

  static Path makeFilledLinePath(Iterable<TimeValue> data, String key) {
    return _pathsPool.putIfAbsent(key, () => _makeFilledLinePath(data));
  }

  static Path _makeFilledLinePath(Iterable<TimeValue> data) {
    final path = Path();
    final tDiff = data.last.t - data.first.t;

    // Layout data as it is on the timeline (x: time, y: value)
    int maxY = 1; // save max value for normalize y
    for (int i = 0; i < data.length; i++) {
      final e = data.elementAt(i);
      final x = e.t - data.first.t;
      final y = e.v;

      path.lineTo(x.toDouble(), 0 - y.toDouble());

      if (y > maxY) maxY = y;
    }
    path.lineTo(tDiff.toDouble(), 0);

    // Clamp path to 0-1 range
    // Makes it more universal to draw and independent of the view
    // So it can be coputed once, memozied or even cached
    final Matrix4 clampMatrix = Matrix4.identity();
    clampMatrix.scale(1 / tDiff, 1 / maxY);
    clampMatrix.translate(1.0, maxY.toDouble());
    final Path clampedPath = path.transform(clampMatrix.storage);
    return clampedPath;
  }

  static Path makeWaveFormPath(Iterable<TimeValue> data, String key) {
    return _pathsPool.putIfAbsent(key, () => _makeWaveFormPath(data));
  }

  static Path _makeWaveFormPath(Iterable<TimeValue> data) {
    final tDiff = data.last.t - data.first.t;
    final path = Path();

    // Layout data as it is on the timeline (x: time, y: value)
    int maxY = 1; // save max value for normalize y
    for (int i = 0; i < data.length; i++) {
      final e = data.elementAt(i);
      final x = e.t - data.first.t;
      final y = e.v;

      path.moveTo(x.toDouble(), 0 - y / 2);
      path.lineTo(x.toDouble(), 0 + y / 2);

      if (y > maxY) maxY = y;
    }

    // Clamp path to 0-1 range
    // Makes it more universal to draw and independent of the view
    // So it can be coputed once, memozied or even cached
    final Matrix4 clampMatrix = Matrix4.identity();
    clampMatrix.scale(1 / tDiff, 1 / maxY);
    clampMatrix.translate(1.0, maxY / 2);
    final Path clampedPath = path.transform(clampMatrix.storage);

    return clampedPath;
  }

  static ({Path u, Path d, Path e}) makeStatusLinePath(Iterable<TimeStatus> data, String key) {
    return _pathsPool.putIfAbsent(key, () => _makeStatusLinePath(data));
  }

  static ({Path u, Path d, Path e}) _makeStatusLinePath(Iterable<TimeStatus> data) {
    final tDiff = data.last.t - data.first.t;
    Path pathUp = Path();
    Path pathDown = Path();
    Path pathError = Path();

    // Layout data as three lines on the timeline (x: time)
    for (int i = 0; i < data.length; i++) {
      final e = data.elementAt(i);
      final x = e.t - data.first.t;
      final SampleStatus status = e.s;

      if (status == SampleStatus.connectionUp) {
        pathUp.moveTo(x.toDouble(), 0);
        pathUp.lineTo(x.toDouble(), 1);
      }
      if (status == SampleStatus.connectionDown) {
        pathDown.moveTo(x.toDouble(), 0);
        pathDown.lineTo(x.toDouble(), 1);
      }
      if (status == SampleStatus.samplingError) {
        pathError.moveTo(x.toDouble(), 0);
        pathError.lineTo(x.toDouble(), 1);
      }
    }
    // Clamp path to 0-1 range
    // Makes it more universal to draw and independent of the view
    // So it can be coputed once, memozied or even cached
    final Matrix4 clampMatrix = Matrix4.identity();
    clampMatrix.scale(1 / tDiff, 1);
    pathUp = pathUp.transform(clampMatrix.storage);
    pathDown = pathDown.transform(clampMatrix.storage);
    pathError = pathError.transform(clampMatrix.storage);

    return (u: pathUp, d: pathDown, e: pathError);
  }
}

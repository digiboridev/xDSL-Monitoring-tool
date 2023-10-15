import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/utils/formatters.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class SnapshotViewer extends StatefulWidget {
  final String snapshotId;
  const SnapshotViewer(this.snapshotId, {super.key});

  @override
  State<SnapshotViewer> createState() => _SnapshotViewerState();
}

class _SnapshotViewerState extends State<SnapshotViewer> {
  late final statsRepository = context.read<StatsRepository>();
  List<LineStats> statsList = [];
  SnapshotStats? snapshotStats;

  @override
  void initState() {
    super.initState();
    statsRepository.lineStatsBySnapshot(widget.snapshotId).then((data) {
      if (mounted) setState(() => statsList = data);
    });
    statsRepository.snapshotStatsById(widget.snapshotId).then((data) {
      if (mounted) setState(() => snapshotStats = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
            color: Colors.cyan.shade100,
          ),
        ],
        title: Hero(
          child: Material(
            key: Key(widget.snapshotId),
            color: Colors.transparent,
            child: Text(
              'Snapshot: ${widget.snapshotId}',
              style: TextStyles.f18w6.cyan100,
            ),
          ),
          tag: widget.snapshotId,
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: SizedBox.expand(
        child: body(),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.blueGrey.shade900,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            SizedBox(height: 200),
            if (statsList.isNotEmpty) InteractiveChart(statsList: statsList),
          ],
        ),
      ),
    );
  }
}

class InteractiveChart extends StatefulWidget {
  final List<LineStats> statsList;
  const InteractiveChart({
    Key? key,
    required this.statsList,
  }) : super(key: key);

  @override
  State<InteractiveChart> createState() => _InteractiveChartState();
}

class _InteractiveChartState extends State<InteractiveChart> with TickerProviderStateMixin {
  double scale = 1.0;
  double offset = 0.0;
  double pScale = 1.0;
  double pOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      double width = c.maxWidth;
      return GestureDetector(
        onScaleStart: (details) {
          pScale = scale;
          pOffset = offset;
        },
        onScaleUpdate: (details) {
          setState(() {
            scale = pScale * details.scale;
            offset = offset + details.focalPointDelta.dx / scale;

            // Prevent scrolling out of bounds
            if (offset > width / scale - width / scale) offset = width / scale - width / scale;
            if (offset < 0 - (width - (width / scale))) offset = 0 - (width - (width / scale));

            // Prevent scaling out of bounds
            if (scale < 1.0) scale = 1;
            if (scale == 1.0 && offset != 1) offset = 1;

            debugPrint(scale.toString());
            debugPrint(offset.toString());
          });
        },
        child: Column(
          children: [
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: TimelinePainter(
                    start: widget.statsList.first.time,
                    end: widget.statsList.last.time,
                    scale: scale,
                    offset: offset,
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: Container(
                height: 16,
                width: double.infinity,
                child: CustomPaint(
                  painter: StatusPathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, s: e.status)),
                    scale: scale,
                    offset: offset,
                    key: 'status' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: RSCPathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downFECIncr ?? 0)),
                    scale: scale,
                    offset: offset,
                    key: 'downFECIncr' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: RSCPathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upFECIncr ?? 0)),
                    scale: scale,
                    offset: offset,
                    key: 'upFECIncr' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: RSCPathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downCRCIncr ?? 0)),
                    scale: scale,
                    offset: offset,
                    key: 'downCRCIncr' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: RSCPathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upCRCIncr ?? 0)),
                    scale: scale,
                    offset: offset,
                    key: 'upCRCIncr' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: LinePathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downMargin ?? 0)),
                    scale: scale,
                    offset: offset,
                    key: 'downMargin' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            RepaintBoundary(
              child: Container(
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: LinePathPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upMargin ?? 0)),
                    scale: scale,
                    offset: offset,
                    key: 'upMargin' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Timestamp and value
typedef TimeValue = ({int t, int v});

class TimelinePainter extends CustomPainter {
  final DateTime start;
  final DateTime end;
  final double scale;
  final double offset;
  TimelinePainter({required this.start, required this.end, required this.scale, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paintTime = DateTime.now();

    final paint = Paint()
      ..color = Colors.cyan.shade100
      ..style = PaintingStyle.stroke;
    final int tDiff = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final double scaledOffset = offset * scale;
    final double widthInTime = size.width / tDiff * scale;
    final int startStamp = start.millisecondsSinceEpoch;

    final double baseLine = size.height / 2.5;
    int ceilScale = scale.floor();
    int scaleSteps = 100 * ceilScale;
    int timeSteps = 4 * ceilScale;
    double timeStep = tDiff / timeSteps;

    // Scale steps
    for (int i = 0; i < scaleSteps; i++) {
      final double x = tDiff / scaleSteps * i * widthInTime + scaledOffset;
      final double y = size.height / 8;

      // skip offscreen points render
      if (x < 0 - 20) continue;
      if (x > size.width + 20) continue;

      // draw scale step line
      canvas.drawLine(Offset(x, baseLine + y / 2), Offset(x, baseLine - y / 2), paint);
    }

    // Time steps
    for (int i = 0; i <= timeSteps; i++) {
      final double curTimeStep = timeStep * i;
      final double x = curTimeStep * widthInTime + scaledOffset;
      final double y = size.height / 4;

      // skip offscreen points render
      // + 20px margin to prevent cutting time on the edges
      if (x < 0 - 20) continue;
      if (x > size.width + 20) continue;

      // draw accent scale step line
      canvas.drawLine(Offset(x, baseLine + y / 2), Offset(x, baseLine - y / 2), paint);

      // Make time painter
      final curTimeDate = DateTime.fromMillisecondsSinceEpoch((startStamp + curTimeStep).toInt());
      final timePainter = TextPainter(
        text: TextSpan(
          text: curTimeDate.numhms + '\n' + curTimeDate.numymd,
          style: TextStyle(color: Colors.cyan.shade100, fontSize: 8),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      timePainter.layout();

      // Draw first and last time inside scale bounds
      if (i == 0) {
        timePainter.paint(canvas, Offset(x, y / 2 + baseLine));
        continue;
      }
      if (i == timeSteps) {
        timePainter.paint(canvas, Offset(x - timePainter.width, y / 2 + baseLine));
        continue;
      }

      // Draw time in the middle of the step
      timePainter.paint(canvas, Offset(x - timePainter.width / 2, y / 2 + baseLine));
    }

    debugPrint('TimelinePainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    bool sameStart = start == oldDelegate.start;
    bool sameEnd = end == oldDelegate.end;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    return !(sameStart && sameEnd && sameScale && sameOffset);
  }
}

/// Timestamp and status
typedef TimeStatus = ({int t, SampleStatus s});

class RSCPathPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  RSCPathPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Map<String, Path> pathsPool = {};
  static final p = Paint()
    ..color = Colors.cyan.shade100
    ..style = PaintingStyle.stroke;
  int get startStamp => data.first.t;
  int get tDiff => data.last.t - data.first.t;

  Path _makeDataPath() {
    debugPrint('new path: $key');

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

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Draw center line
    final double halfHeight = size.height / 2;
    final Offset lineStart = Offset(offset * scale, halfHeight);
    final Offset lineEnd = Offset((offset + size.width) * scale, halfHeight);
    canvas.drawLine(lineStart, lineEnd, p);

    // Draw data
    // pathsPool.clear();
    final Path dataPath = pathsPool.putIfAbsent(key, _makeDataPath);
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    final Path displayPath = dataPath.transform(displayMatrix.storage);
    canvas.drawPath(displayPath, p);

    // Debug
    final paintEnd = DateTime.now();
    debugPrint('RSCPathPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(RSCPathPainter oldDelegate) {
    bool sameData = data.length == oldDelegate.data.length;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    bool sameKey = key == oldDelegate.key;
    return !(sameData && sameScale && sameOffset && sameKey);
  }
}

class StatusPathPainter extends CustomPainter {
  final Iterable<({int t, SampleStatus s})> data;
  final double scale;
  final double offset;
  final String key;
  StatusPathPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Map<String, ({Path u, Path d, Path e})> pathsPool = {};
  static final p = Paint()..style = PaintingStyle.stroke;
  int get startStamp => data.first.t;
  int get tDiff => data.last.t - data.first.t;

  ({Path u, Path d, Path e}) _makeDataPath() {
    debugPrint('new path: $key');

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

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Draw data
    final ({Path u, Path d, Path e}) dataPath = pathsPool.putIfAbsent(key, _makeDataPath);
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);

    final Path pathU = dataPath.u.transform(displayMatrix.storage);
    canvas.drawPath(pathU, p..color = Colors.cyan.shade100);
    final Path pathD = dataPath.d.transform(displayMatrix.storage);
    canvas.drawPath(pathD, p..color = Colors.black);
    final Path pathE = dataPath.e.transform(displayMatrix.storage);
    canvas.drawPath(pathE, p..color = Colors.red);

    // Debug
    final paintEnd = DateTime.now();
    debugPrint('StatusPathPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(StatusPathPainter oldDelegate) {
    bool sameData = data.length == oldDelegate.data.length;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    bool sameKey = key == oldDelegate.key;
    return !(sameData && sameScale && sameOffset && sameKey);
  }
}

class LinePathPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  LinePathPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Map<String, Path> pathsPool = {};
  static final p = Paint()
    ..color = Colors.cyan.shade100
    ..style = PaintingStyle.fill;
  int get startStamp => data.first.t;
  int get tDiff => data.last.t - data.first.t;

  Path _makeDataPath() {
    debugPrint('new path: $key');

    final path = Path();

    // Layout data as it is on the timeline (x: time, y: value)
    int maxY = 1; // save max value for normalize y
    for (int i = 0; i < data.length; i++) {
      final e = data.elementAt(i);
      final x = e.t - data.first.t;
      final y = e.v;

      path.lineTo(x.toDouble(), 0 - y.toDouble());

      if (y > maxY) maxY = y;
    }

    // Clamp path to 0-1 range
    // Makes it more universal to draw and independent of the view
    // So it can be coputed once, memozied or even cached
    final Matrix4 clampMatrix = Matrix4.identity();
    clampMatrix.scale(1 / tDiff, 1 / maxY);
    clampMatrix.translate(1.0, maxY.toDouble());
    final Path clampedPath = path.transform(clampMatrix.storage);
    return clampedPath;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Draw data
    final Path dataPath = pathsPool.putIfAbsent(key, _makeDataPath);
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    final Path displayPath = dataPath.transform(displayMatrix.storage);
    canvas.drawPath(displayPath, p);

    // Debug
    final paintEnd = DateTime.now();
    debugPrint('RSCPathPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(LinePathPainter oldDelegate) {
    bool sameData = data.length == oldDelegate.data.length;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    bool sameKey = key == oldDelegate.key;
    return !(sameData && sameScale && sameOffset && sameKey);
  }
}

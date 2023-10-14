// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      child: Column(
        children: [
          SizedBox(height: 200),
          if (statsList.isNotEmpty) InteractiveChart(statsList: statsList),
        ],
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
    double width = MediaQuery.of(context).size.width;
    double scaledOffset = offset * scale;
    int startStamp = widget.statsList.first.time.millisecondsSinceEpoch;
    int endStamp = widget.statsList.last.time.millisecondsSinceEpoch;
    int tDiff = endStamp - startStamp;
    double widthInTime = width / tDiff * scale;

    return SizedBox(
      // height: 200,
      width: double.infinity,
      child: GestureDetector(
        onScaleStart: (details) {
          pScale = scale;
          pOffset = offset;
        },
        onScaleUpdate: (details) {
          setState(() {
            scale = pScale * details.scale;
            offset = offset + details.focalPointDelta.dx / scale;
            if (offset > width) offset = width;
            if (offset < 0 - width) offset = 0 - width;
            if (scale < 1.0) scale = 1;
            // print(scale);
            // print(offset);
          });
        },
        child: Column(
          children: [
            RepaintBoundary(
              child: Container(
                color: Colors.blueGrey.shade900,
                height: 50,
                width: double.infinity,
                child: CustomPaint(
                  painter: TimelinePainter(
                    start: widget.statsList.first.time,
                    end: widget.statsList.last.time,
                    scale: scale,
                    offset: offset,
                    scaledOffset: scaledOffset,
                    startStamp: startStamp,
                    endStamp: endStamp,
                    tDiff: tDiff,
                    widthInTime: widthInTime,
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: Container(
                color: Colors.blueGrey.shade900,
                height: 75,
                width: double.infinity,
                child: CustomPaint(
                  painter: StatusPainter(
                    data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, s: e.status)),
                    scale: scale,
                    offset: offset,
                    scaledOffset: scaledOffset,
                    startStamp: startStamp,
                    endStamp: endStamp,
                    tDiff: tDiff,
                    widthInTime: widthInTime,
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: Container(
                color: Colors.blueGrey.shade900,
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
            RepaintBoundary(
              child: Container(
                color: Colors.blueGrey.shade900,
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
            RepaintBoundary(
              child: Container(
                color: Colors.blueGrey.shade900,
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
            RepaintBoundary(
              child: Container(
                color: Colors.blueGrey.shade900,
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
          ],
        ),
      ),
    );
  }
}

/// Timestamp and value
typedef TimeValue = ({int t, int v});

class TimelinePainter extends CustomPainter {
  final DateTime start;
  final DateTime end;
  final double scale;
  final double offset;
  final double scaledOffset;
  final int startStamp;
  final int endStamp;
  final int tDiff;
  final double widthInTime;
  TimelinePainter({
    required this.start,
    required this.end,
    required this.scale,
    required this.offset,
    required this.scaledOffset,
    required this.startStamp,
    required this.endStamp,
    required this.tDiff,
    required this.widthInTime,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final paintTime = DateTime.now();

    final paint = Paint()
      ..color = Colors.cyan.shade100
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

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
      if (x < 0) continue;
      if (x > size.width) continue;

      // draw scale step line
      canvas.drawLine(Offset(x, baseLine + y / 2), Offset(x, baseLine - y / 2), paint);
    }

    // Time steps
    for (int i = 0; i <= timeSteps; i++) {
      final double curTimeStep = timeStep * i;
      final double x = curTimeStep * widthInTime + scaledOffset;
      final double y = size.height / 4;

      // skip offscreen points render
      if (x < 0) continue;
      if (x > size.width) continue;

      // draw accent scale step line
      canvas.drawLine(Offset(x, baseLine + y / 2), Offset(x, baseLine - y / 2), paint);

      // draw time
      final curTimeDate = DateTime.fromMillisecondsSinceEpoch((startStamp + curTimeStep).toInt());
      final timePainter = TextPainter(
          text: TextSpan(
            text: curTimeDate.numhms + '\n' + curTimeDate.numymd,
            style: TextStyle(color: Colors.cyan.shade100, fontSize: 8),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center);

      timePainter.layout();
      timePainter.paint(canvas, Offset(x - 20, y / 2 + baseLine));
    }

    debugPrint('TimelinePainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }
}

/// Timestamp and status
typedef TimeStatus = ({int t, SampleStatus s});

class StatusPainter extends CustomPainter {
  final Iterable<TimeStatus> data;
  final double scale;
  final double offset;
  final double scaledOffset;
  final int startStamp;
  final int endStamp;
  final int tDiff;
  final double widthInTime;
  StatusPainter({
    required this.data,
    required this.scale,
    required this.offset,
    required this.scaledOffset,
    required this.startStamp,
    required this.endStamp,
    required this.tDiff,
    required this.widthInTime,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final paintTime = DateTime.now();

    for (int i = 0; i < data.length - 1; i++) {
      final val = data.elementAt(i);
      final next = data.elementAt(i + 1);
      final double halfHeight = size.height / 2;
      final double x = (val.t - startStamp) * widthInTime + scaledOffset;
      final double x2 = (next.t - startStamp) * widthInTime + scaledOffset;

      // skip offscreen points render
      if (x < 0) continue;
      if (x > size.width) continue;

      final paint = Paint()
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke;

      final status = val.s;
      if (status == SampleStatus.samplingError) {
        canvas.drawLine(Offset(x, halfHeight), Offset(x2, halfHeight), paint..color = Colors.red);
      } else if (status == SampleStatus.connectionDown) {
        canvas.drawLine(Offset(x, halfHeight), Offset(x2, halfHeight), paint..color = Colors.black);
      } else {
        canvas.drawLine(Offset(x, halfHeight), Offset(x2, halfHeight), paint..color = Colors.cyan.shade100);
      }
    }

    debugPrint('StatusPainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }
}

class RSCPainter extends CustomPainter {
  final Iterable<TimeValue> data;
  final double scale;
  final double offset;
  final double scaledOffset;
  final int startStamp;
  final int endStamp;
  final int tDiff;
  final double widthInTime;
  RSCPainter({
    required this.data,
    required this.scale,
    required this.offset,
    required this.scaledOffset,
    required this.startStamp,
    required this.endStamp,
    required this.tDiff,
    required this.widthInTime,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintTime = DateTime.now();

    final paint = Paint()
      ..color = Colors.cyan.shade100.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double halfHeight = size.height / 2;
    final lineStart = Offset(offset * scale, halfHeight);
    final lineEnd = Offset(offset * scale + size.width * scale, halfHeight);
    canvas.drawLine(lineStart, lineEnd, paint);

    int maxH = 1000;
    for (int i = 0; i < data.length - 1; i++) {
      final val = data.elementAt(i);
      final double x = (val.t - startStamp) * widthInTime + scaledOffset;
      final double y = (val.v / maxH).clamp(0, 1) * size.height;

      // skip offscreen points render
      if (x < 0) continue;
      if (x > size.width) continue;

      // draw line
      canvas.drawLine(Offset(x, halfHeight + y / 2), Offset(x, halfHeight - y / 2), paint);
    }

    debugPrint('RSCPainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }
}

class RSCPathPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  RSCPathPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Map<String, Path> pathsPool = {};
  static final p = Paint()
    ..color = Colors.cyan.shade100.withOpacity(1)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  int get startStamp => data.first.t;
  int get tDiff => data.last.t - data.first.t;

  Path _makeDataPath() {
    debugPrint('new path: $key');

    final path = Path();

    // Layout data as it is on the timeline (x: time, y: value)
    int maxV = 1; // save max value normalize y
    for (int i = 0; i < data.length; i++) {
      final e = data.elementAt(i);
      final x = e.t - data.first.t;
      final y = e.v;

      path.moveTo(x.toDouble(), 0 - y / 2);
      path.lineTo(x.toDouble(), 0 + y / 2);

      if (e.v > maxV) maxV = e.v;
    }

    // Clamp path to 0-1 range
    // Makes it more universal to draw and independent of the view
    // So it can be coputed once, memozied or even cached
    final Matrix4 clampMatrix = Matrix4.identity();
    clampMatrix.scale(1 / tDiff, 1 / maxV);
    clampMatrix.translate(1.0, maxV / 2);
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

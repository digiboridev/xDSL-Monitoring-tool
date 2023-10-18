import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/utils/formatters.dart';
import 'package:xdslmt/widgets/charts/path_factory.dart';
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

            // debugPrint(scale.toString());
            // debugPrint(offset.toString());
          });
        },
        child: Column(
          children: [
            Container(
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
            Container(
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
            SizedBox(height: 8),
            Container(
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
            SizedBox(height: 8),
            Container(
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
            SizedBox(height: 8),
            Container(
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
            SizedBox(height: 8),
            Container(
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
            SizedBox(height: 8),
            Container(
              height: 50,
              width: double.infinity,
              child: CustomPaint(
                painter: LinePathPainter(
                  data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downMargin ?? 0)),
                  scale: scale,
                  offset: offset,
                  key: 'downMargin' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  scaleFormat: (d) => (d / 10).toStringAsFixed(1),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              width: double.infinity,
              child: CustomPaint(
                painter: LinePathPainter(
                  data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upMargin ?? 0)),
                  scale: scale,
                  offset: offset,
                  key: 'upMargin' + widget.statsList.last.time.millisecondsSinceEpoch.toString(),
                  scaleFormat: (d) => (d / 10).toStringAsFixed(1),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

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

    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));

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

class RSCPathPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  RSCPathPainter({required this.data, required this.scale, required this.offset, required this.key});

  Paint get p => Paint()
    ..color = Colors.cyan.shade100
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Create data path
    final cp = PathFactory.makeWaveFormPath(data, key);
    final Path dataPath = cp.path;
    final PathMetadata metadata = cp.metadata;

    canvas.save(); // save canvas state before data clipping

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath, p);

    canvas.restore(); // restore canvas state after clipping (so it doesn't affect other painters)

    // Draw vMax vertical mesh
    final int vMax = metadata.vMax;
    final int meshSteps = 3;
    final double meshStep = size.height / meshSteps;
    for (int i = 0; i < meshSteps; i++) {
      final double y = meshStep * i;
      final double x = size.width;
      final text = TextPainter(
        text: TextSpan(
          text: (vMax / meshSteps * (meshSteps - i)).toStringAsFixed(1),
          style: TextStyle(
            color: Colors.cyan.shade50,
            fontSize: 6,
            shadows: [
              Shadow(blurRadius: 2, color: Colors.black),
              Shadow(blurRadius: 8, color: Colors.blueGrey.shade800),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      text.layout();
      text.paint(canvas, Offset(x - text.width, y / 2 - text.height / 2));
      canvas.drawLine(
        Offset(0, y / 2),
        Offset(x - text.width - 4, y / 2),
        Paint()..color = Colors.cyan.shade200.withOpacity(0.25),
      );
      canvas.drawLine(
        Offset(0, size.height - y / 2),
        Offset(x, size.height - y / 2),
        Paint()..color = Colors.cyan.shade200.withOpacity(0.25),
      );
    }

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

  Paint get p => Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Create data path
    final dataPath = PathFactory.makeStatusLinePath(data, key);

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath.u, p..color = Colors.cyan.shade100);
    canvas.drawPath(dataPath.d, p..color = Colors.black);
    canvas.drawPath(dataPath.e, p..color = Colors.red);

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
  final String Function(double d) scaleFormat;
  LinePathPainter({required this.data, required this.scale, required this.offset, required this.key, required this.scaleFormat});

  Paint get p => Paint()
    ..color = Colors.cyan.shade100
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Create data path
    final cp = PathFactory.makeLinePath(data, key);
    final Path dataPath = cp.path;
    final PathMetadata metadata = cp.metadata;

    canvas.save(); // save canvas state before data clipping

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath, p);

    canvas.restore(); // restore canvas state after clipping (so it doesn't affect other painters)

    // Draw vMax vertical mesh
    final int vMax = metadata.vMax;
    final int meshSteps = 5;
    final double meshStep = size.height / meshSteps;
    for (int i = 0; i < meshSteps; i++) {
      final double y = meshStep * i;
      final double x = size.width;
      final text = TextPainter(
        text: TextSpan(
          text: scaleFormat(vMax / meshSteps * (meshSteps - i)),
          style: TextStyle(
            color: Colors.cyan.shade50,
            fontSize: 6,
            shadows: [
              Shadow(blurRadius: 2, color: Colors.black),
              Shadow(blurRadius: 8, color: Colors.blueGrey.shade800),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      text.layout();
      text.paint(canvas, Offset(x - text.width, y - text.height / 2));
      canvas.drawLine(
        Offset(0, y),
        Offset(x - text.width - 4, y),
        Paint()..color = Colors.cyan.shade200.withOpacity(0.25),
      );
    }

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

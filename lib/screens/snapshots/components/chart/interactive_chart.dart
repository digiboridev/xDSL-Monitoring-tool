// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/screens/snapshots/components/chart/painters/line_path_painter.dart';
import 'package:xdslmt/screens/snapshots/components/chart/painters/status_events_painter.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/core/text_styles.dart';
import 'package:xdslmt/screens/snapshots/components/chart/painters/wave_form_painter.dart';
import 'package:xdslmt/screens/snapshots/components/chart/painters/timeline_painter.dart';
import 'package:xdslmt/core/formatters.dart';
import 'package:xdslmt/utils/to_csv.dart';

class InteractiveChart extends StatefulWidget {
  final List<LineStats> statsList;
  final SnapshotStats snapshotStats;

  const InteractiveChart({super.key, required this.statsList, required this.snapshotStats});

  @override
  State<InteractiveChart> createState() => _InteractiveChartState();
}

class _InteractiveChartState extends State<InteractiveChart> with TickerProviderStateMixin {
  double scale = 1.0;
  double offset = 0.0;
  double pScale = 1.0;
  double pOffset = 0.0;
  // Dropdowns open state
  bool downFec = false;
  bool upFec = false;
  bool downCrc = false;
  bool upCrc = false;
  bool downMargin = false;
  bool upMargin = false;
  bool downAttn = false;
  bool upAttn = false;
  bool upRate = false;
  bool downRate = false;
  bool upAttainableRate = false;
  bool downAttainableRate = false;

  void zoomIn(double width) {
    final startTime = DateTime.now();

    setState(() {
      scale = scale * 1.5;
      offset = offset - (width / scale / 4);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final endTime = DateTime.now();
      final Duration duration = endTime.difference(startTime);
      debugPrint('zoomIn: ${duration.inMicroseconds}us');
    });
  }

  void zoomOut(double width) {
    final startTime = DateTime.now();

    setState(() {
      offset = offset + (width / scale / 4);
      scale = scale / 1.5;

      // Prevent scrolling out of bounds
      if (offset > width / scale - width / scale) offset = width / scale - width / scale;
      if (offset < 0 - (width - (width / scale))) offset = 0 - (width - (width / scale));

      // Prevent scaling out of bounds
      if (scale < 1.0) scale = 1;
      if (scale == 1.0 && offset != 1) offset = 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final endTime = DateTime.now();
      final Duration duration = endTime.difference(startTime);
      debugPrint('zoomOut: ${duration.inMicroseconds}us');
    });
  }

  void forward(double width) {
    final startTime = DateTime.now();

    setState(() {
      offset = offset - 10 / scale;
      // Prevent scrolling out of bounds
      if (offset > width / scale - width / scale) offset = width / scale - width / scale;
      if (offset < 0 - (width - (width / scale))) offset = 0 - (width - (width / scale));
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final endTime = DateTime.now();
      final Duration duration = endTime.difference(startTime);
      debugPrint('forward: ${duration.inMicroseconds}us');
    });
  }

  void backward(double width) {
    final startTime = DateTime.now();

    setState(() {
      offset = offset + 10 / scale;

      // Prevent scrolling out of bounds
      if (offset > width / scale - width / scale) offset = width / scale - width / scale;
      if (offset < 0 - (width - (width / scale))) offset = 0 - (width - (width / scale));
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final endTime = DateTime.now();
      final Duration duration = endTime.difference(startTime);
      debugPrint('backward: ${duration.inMicroseconds}us');
    });
  }

  @override
  void initState() {
    super.initState();
    // debug
    // WidgetsBinding.instance.addTimingsCallback((timings) {
    //   for (final timing in timings) {
    //     debugPrint('build: ${timing.buildDuration.inMilliseconds}');
    //     debugPrint('raster: ${timing.rasterDuration.inMilliseconds}');
    //     debugPrint('vsyncOverhead: ${timing.vsyncOverhead.inMilliseconds}');
    //     debugPrint('totalSpan: ${timing.totalSpan.inMilliseconds}');
    //   }
    //   debugPrint('Timings length: ${timings.length}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        double width = c.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
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
            });
          },
          child: Container(
            color: AppColors.blueGrey900,
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Summary',
                    style: TextStyles.f18w6.cyan100,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SnapshotID', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.snapshotId, style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Host', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.host, style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Login', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.login, style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Password', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.password, style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mode', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.lastConnectionType ?? 'N/A', style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total samples', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.samples.toString(), style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Errored samples', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.samplingErrors.toString(), style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Line disconnects', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.disconnects.toString(), style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Start date', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.startTime.ymdhms, style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total duration', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.samplingDuration.hms, style: TextStyles.f14.cyan100),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Uplink duration', style: TextStyles.f14.cyan100),
                          Text(widget.snapshotStats.uplinkDuration.hms, style: TextStyles.f14.cyan100),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Interactive view',
                    style: TextStyles.f18w6.cyan100,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text('Timeline', style: TextStyles.f14w6.cyan100),
                      const Spacer(),
                      IconButton(
                        onPressed: () => backward(width),
                        icon: const Icon(Icons.fast_rewind),
                        color: AppColors.cyan100,
                      ),
                      IconButton(
                        onPressed: () => forward(width),
                        icon: const Icon(Icons.fast_forward),
                        color: AppColors.cyan100,
                      ),
                      IconButton(
                        onPressed: () => zoomIn(width),
                        icon: const Icon(Icons.zoom_in),
                        color: AppColors.cyan100,
                      ),
                      IconButton(
                        onPressed: () => zoomOut(width),
                        icon: const Icon(Icons.zoom_out),
                        color: AppColors.cyan100,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: RepaintBoundary(
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
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text('Status events', style: TextStyles.f14w6.cyan100),
                      const Spacer(),
                      Container(width: 16, height: 8, color: Colors.cyan),
                      const SizedBox(width: 4),
                      const Text('UP', style: TextStyles.f8hc100),
                      const SizedBox(width: 4),
                      Container(width: 16, height: 8, color: Colors.black),
                      const SizedBox(width: 4),
                      const Text('DOWN', style: TextStyles.f8hc100),
                      const SizedBox(width: 4),
                      Container(width: 16, height: 8, color: Colors.red),
                      const SizedBox(width: 4),
                      const Text('ERROR', style: TextStyles.f8hc100),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                  width: double.infinity,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: StatusEventsPainter(
                        data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, s: e.status)),
                        scale: scale,
                        offset: offset,
                        key: 'status${widget.statsList.last.time.millisecondsSinceEpoch}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => downRate = !downRate),
                    child: Row(
                      children: [
                        Text('Downstream Rate', style: TextStyles.f14w6.cyan100),
                        Icon(downRate ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${widget.snapshotStats.downRateMin ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${widget.snapshotStats.downRateMax ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${widget.snapshotStats.downRateAvg ?? 0}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (downRate)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downRate)),
                          scale: scale,
                          offset: offset,
                          key: 'downRate${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => d.toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => upRate = !upRate),
                    child: Row(
                      children: [
                        Text('Upstream Rate', style: TextStyles.f14w6.cyan100),
                        Icon(upRate ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${widget.snapshotStats.upRateMin ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${widget.snapshotStats.upRateMax ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${widget.snapshotStats.upRateAvg ?? 0}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (upRate)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upRate)),
                          scale: scale,
                          offset: offset,
                          key: 'upRate${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => d.toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => downAttainableRate = !downAttainableRate),
                    child: Row(
                      children: [
                        Text('Down Attainable Rate', style: TextStyles.f14w6.cyan100),
                        Icon(downAttainableRate ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${widget.snapshotStats.downAttainableRateMin ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${widget.snapshotStats.downAttainableRateMax ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${widget.snapshotStats.downAttainableRateAvg ?? 0}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (downAttainableRate)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downAttainableRate)),
                          scale: scale,
                          offset: offset,
                          key: 'downAttainableRate${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => d.toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => upAttainableRate = !upAttainableRate),
                    child: Row(
                      children: [
                        Text('Up Attainable Rate', style: TextStyles.f14w6.cyan100),
                        Icon(upAttainableRate ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${widget.snapshotStats.upAttainableRateMin ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${widget.snapshotStats.upAttainableRateMax ?? 0}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${widget.snapshotStats.upAttainableRateAvg ?? 0}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (upAttainableRate)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upAttainableRate)),
                          scale: scale,
                          offset: offset,
                          key: 'upAttainableRate${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => d.toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => downFec = !downFec),
                    child: Row(
                      children: [
                        Text('Downstream FEC INCR', style: TextStyles.f14w6.cyan100),
                        Icon(downFec ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('TOTAL: ${widget.snapshotStats.downFecTotal}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (downFec)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: WaveFormPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downFECIncr)),
                          scale: scale,
                          offset: offset,
                          key: 'downFECIncr${widget.statsList.last.time.millisecondsSinceEpoch}',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => upFec = !upFec),
                    child: Row(
                      children: [
                        Text('Upstream FEC INCR', style: TextStyles.f14w6.cyan100),
                        Icon(upFec ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('TOTAL: ${widget.snapshotStats.upFecTotal}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (upFec)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: WaveFormPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upFECIncr)),
                          scale: scale,
                          offset: offset,
                          key: 'upFECIncr${widget.statsList.last.time.millisecondsSinceEpoch}',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => downCrc = !downCrc),
                    child: Row(
                      children: [
                        Text('Downstream CRC INCR', style: TextStyles.f14w6.cyan100),
                        Icon(downCrc ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('TOTAL: ${widget.snapshotStats.downCrcTotal}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (downCrc)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: WaveFormPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downCRCIncr)),
                          scale: scale,
                          offset: offset,
                          key: 'downCRCIncr${widget.statsList.last.time.millisecondsSinceEpoch}',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => upCrc = !upCrc),
                    child: Row(
                      children: [
                        Text('Upstream CRC INCR', style: TextStyles.f14w6.cyan100),
                        Icon(upCrc ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('TOTAL: ${widget.snapshotStats.upCrcTotal}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (upCrc)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: WaveFormPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upCRCIncr)),
                          scale: scale,
                          offset: offset,
                          key: 'upCRCIncr${widget.statsList.last.time.millisecondsSinceEpoch}',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => downMargin = !downMargin),
                    child: Row(
                      children: [
                        Text('Downstream SRNM', style: TextStyles.f14w6.cyan100),
                        Icon(downMargin ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${((widget.snapshotStats.downSNRmMin ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${((widget.snapshotStats.downSNRmMax ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${((widget.snapshotStats.downSNRmAvg ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (downMargin)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downMargin)),
                          scale: scale,
                          offset: offset,
                          key: 'downMargin${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => (d / 10).toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => upMargin = !upMargin),
                    child: Row(
                      children: [
                        Text('Upstream SRNM', style: TextStyles.f14w6.cyan100),
                        Icon(upMargin ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${((widget.snapshotStats.upSNRmMin ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${((widget.snapshotStats.upSNRmMax ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${((widget.snapshotStats.upSNRmAvg ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (upMargin)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upMargin)),
                          scale: scale,
                          offset: offset,
                          key: 'upMargin${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => (d / 10).toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => downAttn = !downAttn),
                    child: Row(
                      children: [
                        Text('Downstream ATTN', style: TextStyles.f14w6.cyan100),
                        Icon(downAttn ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${((widget.snapshotStats.downAttenuationMin ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${((widget.snapshotStats.downAttenuationMax ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${((widget.snapshotStats.downAttenuationAvg ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (downAttn)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.downAttenuation)),
                          scale: scale,
                          offset: offset,
                          key: 'downAttenuation${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => (d / 10).toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => upAttn = !upAttn),
                    child: Row(
                      children: [
                        Text('Upstream ATTN', style: TextStyles.f14w6.cyan100),
                        Icon(upAttn ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.cyan100),
                        const Spacer(),
                        Text('MIN: ${((widget.snapshotStats.upAttenuationMin ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('MAX: ${((widget.snapshotStats.upAttenuationMax ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                        const SizedBox(width: 4),
                        Text('AVG: ${((widget.snapshotStats.upAttenuationAvg ?? 0) / 10).toStringAsFixed(1)}', style: TextStyles.f8hc100),
                      ],
                    ),
                  ),
                ),
                if (upAttn)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePathPainter(
                          data: widget.statsList.map((e) => (t: e.time.millisecondsSinceEpoch, v: e.upAttenuation)),
                          scale: scale,
                          offset: offset,
                          key: 'upAttenuation${widget.statsList.last.time.millisecondsSinceEpoch}',
                          scaleFormat: (d) => (d / 10).toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CSVExportButton(id: widget.snapshotStats.snapshotId, statsList: widget.statsList),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CSVExportButton extends StatelessWidget {
  final List<LineStats> statsList;
  final String id;

  const CSVExportButton({super.key, required this.id, required this.statsList});

  Future<void> export(BuildContext context) async {
    List<String> header = [
      'Time',
      'Sample status',
      'Status Text',
      'Connection Type',
      'Downstream Rate',
      'Upstream Rate',
      'Downstream Attainable Rate',
      'Upstream Attainable Rate',
      'Downstream SNRm',
      'Upstream SNRm',
      'Downstream Attenuation',
      'Upstream Attenuation',
      'Downstream FEC',
      'Upstream FEC',
      'Downstream CRC',
      'Upstream CRC',
      'Downstream FEC Incr',
      'Upstream FEC Incr',
      'Downstream CRC Incr',
      'Upstream CRC Incr',
    ];
    List<List<String>> listOfLists = [];
    for (var stat in statsList) {
      listOfLists.add([
        stat.time.ymdhms,
        stat.status.name,
        stat.statusText,
        stat.connectionType ?? 'N/A',
        stat.downRate.toString(),
        stat.upRate.toString(),
        stat.downAttainableRate.toString(),
        stat.upAttainableRate.toString(),
        stat.downMargin.toString(),
        stat.upMargin.toString(),
        stat.downAttenuation.toString(),
        stat.upAttenuation.toString(),
        stat.downFEC.toString(),
        stat.upFEC.toString(),
        stat.downCRC.toString(),
        stat.upCRC.toString(),
        stat.downFECIncr.toString(),
        stat.upFECIncr.toString(),
        stat.downCRCIncr.toString(),
        stat.upCRCIncr.toString(),
      ]);
    }

    try {
      final filename = await toCSV(id, header, listOfLists);
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text('Saved to $filename'),
          backgroundColor: AppColors.cyan400,
          actions: [
            TextButton(
              onPressed: () => launchUrl(Uri.parse('content://$filename')),
              child: const Text('Open'),
            ),
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e, s) {
      debugPrint(e.toString());
      AppLogger.error('Error: $e', error: e, stack: s);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text('Export to CSV'),
      onPressed: () => export(context),
      icon: const Icon(Icons.file_download),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.cyan100,
        backgroundColor: AppColors.blueGrey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

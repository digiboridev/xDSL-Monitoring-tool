// ignore_for_file: avoid_print
import 'dart:async';

/// A [StreamTransformer] that captures events from the source [Stream] and
/// emits them after a specified duration has passed since the previous event.
class DebounceBuffer extends StreamTransformerBase<String, String> {
  /// The duration to wait before emitting an event.
  final Duration duration;

  /// The separator to use between events.
  final String separator;
  DebounceBuffer(this.duration, {this.separator = '\n'});

  @override
  Stream<String> bind(Stream<String> stream) {
    final controller = StreamController<String>();
    final List<String> buffer = [];
    Timer? timer;

    final StreamSubscription(:cancel, :pause, :resume) = stream.listen(
      (event) {
        timer?.cancel();
        buffer.add(event);
        timer = Timer(duration, () {
          if (controller.isClosed) return;
          controller.add(buffer.join(separator));
          buffer.clear();
        });
      },
      onError: controller.addError,
      onDone: controller.close,
    );

    controller.onCancel = cancel;
    controller.onPause = pause;
    controller.onResume = resume;

    return controller.stream;
  }
}
    


// import 'dart:async';

// final asd = StreamTransformer.fromHandlers(
//   handleData: (event, sink) {
//     sink.add(event);
//   },
//   handleDone: (sink) {
//     sink.close();
//   },
//   handleError: (error, stackTrace, sink) {
//     sink.addError(error, stackTrace);
//   },
// );

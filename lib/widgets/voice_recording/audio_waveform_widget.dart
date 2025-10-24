import 'package:flutter/material.dart';
import 'dart:math' as math;

class AudioWaveformWidget extends StatefulWidget {
  final Stream<double>? amplitudeStream;
  final bool isRecording;
  final bool isPaused;
  final Color waveColor;
  final Color backgroundColor;
  final double height;
  final int barCount;

  const AudioWaveformWidget({
    super.key,
    this.amplitudeStream,
    required this.isRecording,
    this.isPaused = false,
    this.waveColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.height = 120,
    this.barCount = 60,
  });

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with SingleTickerProviderStateMixin {
  final List<double> _amplitudes = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // ⚡ Performance: Reduced from 50ms to 100ms (20 fps → 10 fps)
    // Reduces widget rebuilds by 50% while maintaining smooth visual effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    // Initialize with zero amplitudes
    _amplitudes.addAll(List.filled(widget.barCount, 0.0));
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.amplitudeStream != oldWidget.amplitudeStream) {
      _listenToAmplitude();
    }
  }

  void _listenToAmplitude() {
    widget.amplitudeStream?.listen((amplitude) {
      if (mounted && widget.isRecording && !widget.isPaused) {
        setState(() {
          // Add new amplitude to the end
          _amplitudes.add(amplitude);
          // Remove oldest amplitude to maintain fixed count
          if (_amplitudes.length > widget.barCount) {
            _amplitudes.removeAt(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              amplitudes: _amplitudes,
              waveColor: widget.waveColor,
              isRecording: widget.isRecording,
              isPaused: widget.isPaused,
            ),
          );
        },
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color waveColor;
  final bool isRecording;
  final bool isPaused;

  WaveformPainter({
    required this.amplitudes,
    required this.waveColor,
    required this.isRecording,
    required this.isPaused,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = waveColor.withValues(alpha: 0.8)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final barWidth = size.width / amplitudes.length;
    final centerY = size.height / 2;
    final maxBarHeight = size.height * 0.8;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final amplitude = amplitudes[i];

      // Calculate bar height based on amplitude
      // When recording, bars should be responsive
      // When paused, bars should be static
      final barHeight = isPaused
          ? maxBarHeight * amplitude * 0.3  // Smaller when paused
          : maxBarHeight * amplitude;

      // Create rounded rectangle for each bar
      final barRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, centerY),
          width: barWidth * 0.6,  // Leave some spacing between bars
          height: math.max(barHeight, 4),  // Minimum height of 4
        ),
        const Radius.circular(2),
      );

      // Apply gradient effect based on position
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          waveColor.withValues(alpha: 0.6),
          waveColor,
          waveColor.withValues(alpha: 0.6),
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCenter(
          center: Offset(x, centerY),
          width: barWidth,
          height: barHeight,
        ),
      );

      canvas.drawRRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes ||
        oldDelegate.isRecording != isRecording ||
        oldDelegate.isPaused != isPaused;
  }
}

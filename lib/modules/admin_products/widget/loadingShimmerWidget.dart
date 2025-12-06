import 'package:flutter/material.dart';

class LoadingShimmerWidget extends StatefulWidget {
  const LoadingShimmerWidget({super.key});

  @override
  State<LoadingShimmerWidget> createState() => _LoadingShimmerWidgetState();
}

class _LoadingShimmerWidgetState extends State<LoadingShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Slower animation: 2 seconds instead of default
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShimmerStep('1'),
                _buildShimmerLine(),
                _buildShimmerStep('2'),
                _buildShimmerLine(),
                _buildShimmerStep('3'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedShimmerBox(width: 150, height: 20),
                const SizedBox(height: 16),
                _buildAnimatedShimmerBox(width: double.infinity, height: 56),
                const SizedBox(height: 16),
                _buildAnimatedShimmerBox(width: double.infinity, height: 120),
                const SizedBox(height: 24),
                _buildAnimatedShimmerBox(width: 100, height: 20),
                const SizedBox(height: 12),
                _buildAnimatedShimmerBox(width: double.infinity, height: 48),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildAnimatedShimmerBox(width: 100, height: 48),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAnimatedShimmerBox(width: 100, height: 48),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerStep(String step) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildAnimatedShimmerBox(width: 50, height: 12),
      ],
    );
  }

  Widget _buildShimmerLine() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey.shade300,
    );
  }

  /// Animated shimmer box - smooth wave effect
  Widget _buildAnimatedShimmerBox({required double width, required double height}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              final pos = _controller.value;
              
              return LinearGradient(
                begin: Alignment(-1 - pos, 0),
                end: Alignment(3 - pos, 0),
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade100,
                  Colors.grey.shade300,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds);
            },
            child: Container(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpexUnlockScreen extends StatefulWidget {
  final VoidCallback onUnlock;

  const SpexUnlockScreen({super.key, required this.onUnlock});

  @override
  State<SpexUnlockScreen> createState() => _SpexUnlockScreenState();
}

class _SpexUnlockScreenState extends State<SpexUnlockScreen> {
  bool _isVisible = true;

  void _handleUnlock() {
    setState(() => _isVisible = false);
    Future.delayed(500.ms, () => widget.onUnlock());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 800.ms,
      child:
          _isVisible
              ? Container(
                key: const ValueKey('unlock'),
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.5,
                    colors: [Color(0xFF11111a), Colors.black],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _handleUnlock,
                          child: AnimatedContainer(
                            duration: 300.ms,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                color: SpexColors.spexYellow,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Enter the Spex',
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                fontSize: 24,
                                letterSpacing: 3.0,
                                color: SpexColors.spexYellow,
                                shadows: [
                                  Shadow(
                                    color: SpexColors.spexYellow.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : const SizedBox.shrink(),
    );
  }
}

import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpexWelcomeScreen extends StatelessWidget {
  final VoidCallback onNewSession;

  const SpexWelcomeScreen({super.key, required this.onNewSession});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF11111a), Color(0xFF050508)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Title
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              SpexColors.spexCyan,
                              SpexColors.spexYellow,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SpexColors.spexCyan.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.memory,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'SPEX',
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                fontSize: 56,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: '.AI',
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                fontSize: 56,
                                color: SpexColors.spexYellow,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Automated Intelligence Engine',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SpexColors.spexTextSecondary,
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Options Card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(32),
                  decoration: SpexTheme.glassBox,
                  child: Column(
                    children: [
                      Text(
                        'Select Mode',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                          color: SpexColors.spexWhite,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Choose how you want to continue',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SpexColors.spexTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // New Session Button
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: _OptionCard(
                          title: 'New Website Session',
                          subtitle: 'Crawl and index a new website',
                          icon: Icons.add_circle_outline,
                          color: SpexColors.spexCyan,
                          onTap: onNewSession,
                          isEnabled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isEnabled ? color.withOpacity(0.05) : SpexColors.spexSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEnabled ? color.withOpacity(0.3) : SpexColors.spexBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color:
                      isEnabled
                          ? color.withOpacity(0.1)
                          : SpexColors.spexSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isEnabled
                            ? color.withOpacity(0.5)
                            : SpexColors.spexBorder,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isEnabled ? color : SpexColors.spexTextSecondary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            isEnabled
                                ? SpexColors.spexWhite
                                : SpexColors.spexTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            isEnabled
                                ? color.withOpacity(0.8)
                                : SpexColors.spexTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: isEnabled ? color : SpexColors.spexTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

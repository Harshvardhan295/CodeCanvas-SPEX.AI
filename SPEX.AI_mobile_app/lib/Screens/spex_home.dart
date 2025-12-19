import 'package:code_canvas/Screens/url_input_screen.dart';
import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:code_canvas/widgets/spex_chat_interface.dart';
import 'package:code_canvas/widgets/unlock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpexHome extends StatefulWidget {
  const SpexHome({super.key});

  @override
  State<SpexHome> createState() => _SpexHomeState();
}

class _SpexHomeState extends State<SpexHome> {
  bool _isUnlocked = true;
  int _chatResetKey = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _unlockApp() {
    setState(() {
      _isUnlocked = true;
    });
  }

  void _resetChat() {
    setState(() {
      _chatResetKey++;
    });
    Navigator.pop(_scaffoldKey.currentContext!);
  }

  void _showAbout() {
    Navigator.pop(_scaffoldKey.currentContext!);

    showDialog(
      context: _scaffoldKey.currentContext!,
      builder:
          (context) => AlertDialog(
            backgroundColor: SpexColors.botMessageBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: SpexColors.spexCyan, width: 1),
            ),
            title: Row(
              children: [
                Icon(Icons.memory, color: SpexColors.spexYellow),
                const SizedBox(width: 12),
                Text(
                  'PROJECT: SPEX.AI',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    color: SpexColors.spexYellow,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automated Intelligence Engine v2.4.0',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: SpexColors.spexCyan),
                ),
                const SizedBox(height: 16),
                Text(
                  'Spex is an RAG-based system that allows users to input a website URL, automatically crawl and extract its content, and generate a custom Retrieval-Augmented Generation (RAG) based AI chatbot capable of answering user queries accurately using only the website’s data.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                const Divider(color: SpexColors.spexBorder),
                const SizedBox(height: 12),
                Text(
                  'TECHNOLOGIES:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: SpexColors.spexTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TechChip('React & TypeScript'),
                    _TechChip('Flutter & Dart'),
                    _TechChip('FAST API'),
                    _TechChip('Qdrant'),
                    _TechChip('Jina AI'),
                    _TechChip('Vector Embeddings'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: SpexColors.spexCyan,
                ),
                child: Text(
                  'ACKNOWLEDGE',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Content with Scaffold and Drawer
        AnimatedSwitcher(
          duration: 500.ms,
          child:
              _isUnlocked
                  ? Scaffold(
                    key: _scaffoldKey,
                    backgroundColor: Colors.transparent,
                    drawer: _buildSpexDrawer(context),
                    appBar: _buildSpexAppBar(context),
                    body: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topCenter,
                          radius: 1.5,
                          colors: [Color(0xFF11111a), Color(0xFF050508)],
                        ),
                      ),
                      child: SpexChatInterface(key: ValueKey(_chatResetKey)),
                    ),
                  ).animate().fadeIn(duration: 500.ms)
                  : Container(),
        ),

        // Unlock Screen Overlay
        if (!_isUnlocked) SpexUnlockScreen(onUnlock: _unlockApp),
      ],
    );
  }

  AppBar _buildSpexAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: SpexColors.spexWhite,
                size: 28,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'SPEX',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 28,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: '.AI',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 28,
                    color: SpexColors.spexYellow,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Automated Intelligence Engine',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: SpexColors.spexTextSecondary,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: SpexTheme.statusBadge,
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: SpexColors.spexCyan,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SpexColors.spexCyan.withOpacity(0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              Text(
                'SYSTEM OPTIMAL',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: SpexColors.spexCyan.withOpacity(0.8),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpexDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, SpexColors.spexSurface],
          ),
        ),
        child: Column(
          children: [
            // Drawer Header (unchanged)
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.transparent],
                ),
                border: Border(
                  bottom: BorderSide(color: SpexColors.spexBorder, width: 1),
                ),
              ),

              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Terminal Prompt "> _"
                    Text(
                      '> _',
                      style: TextStyle(
                        color: SpexColors.spexYellow,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        height: 1,
                        letterSpacing: -13,
                      ),
                    ),
                    const SizedBox(width: 19),

                    // SPEX.AI Text
                    RichText(
                      text: TextSpan(
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(
                          fontSize: 36,
                          fontStyle: FontStyle.italic,

                          height: 1,
                          letterSpacing: -1,
                        ),
                        children: [
                          const TextSpan(
                            text: 'SPEX',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: '.AI',
                            style: TextStyle(color: SpexColors.spexYellow),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Drawer Items (unchanged)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  _DrawerTile(
                    icon: Icons.add,
                    title: 'New Project',
                    subtitle: 'Start fresh AI session',
                    onTap: _resetChat,
                    isPrimary: true,
                  ),
                  _DrawerTile(
                    icon: Icons.history,
                    title: 'History',
                    subtitle: 'Previous sessions',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerTile(
                    icon: Icons.apps,
                    title: 'My Agents',
                    subtitle: 'Active AI models',
                    onTap: () {},
                  ),
                  _DrawerTile(
                    icon: Icons.design_services,
                    title: 'Templates',
                    subtitle: 'Pre-built workflows',
                    onTap: () {},
                  ),
                  const Divider(
                    color: SpexColors.spexBorder,
                    height: 32,
                    thickness: 1,
                  ),
                  _DrawerTile(
                    icon: Icons.settings,
                    title: 'Configuration',
                    subtitle: 'System settings',
                    onTap: () {},
                  ),
                  _DrawerTile(
                    icon: Icons.security,
                    title: 'Security',
                    subtitle: 'Encryption & privacy',
                    onTap: () {},
                  ),
                  _DrawerTile(
                    icon: Icons.help_outline,
                    title: 'Help & Docs',
                    subtitle: 'Documentation & guides',
                    onTap: _showAbout,
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────
            // NEW: Logout button (replaces System Status)
            // ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: SpexColors.spexBorder, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Close the drawer first
                    Navigator.pop(context);

                    // Optional: clear any auth tokens / session data here
                    // await AuthService().signOut();

                    // Navigate to your URL input / login screen
                    // Replace the entire navigation stack so the user can't go back
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const UrlInputScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SpexColors.spexCyan.withOpacity(0.2),
                    foregroundColor: SpexColors.spexCyan,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isPrimary;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              isPrimary
                  ? SpexColors.spexYellow
                  : SpexColors.spexCyan.withOpacity(0.3), // Increased from 0.1
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isPrimary
                    ? SpexColors.spexYellow
                    : SpexColors.spexCyan.withOpacity(
                      0.7,
                    ), // Increased from 0.3
            width: 2, // Increased from 1
          ),
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.black : SpexColors.spexCyan,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700, // Increased from w600
          color: isPrimary ? SpexColors.spexYellow : Colors.white, // Brighter
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: SpexColors.spexWhite.withOpacity(0.8), // Brighter
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: SpexColors.spexCyan.withOpacity(0.8), // Increased from 0.5
        size: 24, // Increased from default
      ),
      onTap: () {
        onTap();
        HapticFeedback.lightImpact();
      },
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusIndicator({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 8),
            ],
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SpexColors.spexSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SpexColors.spexBorder, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: SpexColors.spexCyan),
      ),
    );
  }
}

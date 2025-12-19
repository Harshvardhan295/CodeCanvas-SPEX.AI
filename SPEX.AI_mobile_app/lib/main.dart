// import 'package:code_canvas/constants/cyberpunk_theme.dart';
// import 'package:code_canvas/widgets/unlock_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/spex_home.dart';
// import 'screens/url_input_screen.dart';

// import 'providers/spex_chat_provider.dart';

// void main() {
//   runApp(const SpexApp());
// }

// class SpexApp extends StatelessWidget {
//   const SpexApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => SpexChatProvider(),
//       child: MaterialApp(
//         title: 'SPEX.AI',
//         theme: SpexTheme.theme,
//         debugShowCheckedModeBanner: false,
//         home: Consumer<SpexChatProvider>(
//           builder: (context, chatProvider, child) {
//             // Show URL input screen if not initialized
//             if (!chatProvider.isInitialized) {
//               return const UrlInputScreen();
//             }
//             // Show main chat screen once initialized
//             return const SpexHome();
//           },
//         ),
//       ),
//     );
//   }
// }

// class AppNavigator extends StatefulWidget {
//   const AppNavigator({super.key});

//   @override
//   State<AppNavigator> createState() => _AppNavigatorState();
// }

// class _AppNavigatorState extends State<AppNavigator> {
//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<SpexChatProvider>(context);

//     // Simple logic:
//     // 1. Show unlock screen first
//     // 2. After unlock, show URL input
//     // 3. After crawl, show chat

//     // Check if we should show chat (already initialized)
//     if (chatProvider.isInitialized && chatProvider.isChatActive) {
//       return const SpexHome();
//     }

//     // Otherwise, use a state to track unlock status
//     return _UnlockToUrlFlow();
//   }
// }

// class _UnlockToUrlFlow extends StatefulWidget {
//   const _UnlockToUrlFlow();

//   @override
//   State<_UnlockToUrlFlow> createState() => _UnlockToUrlFlowState();
// }

// class _UnlockToUrlFlowState extends State<_UnlockToUrlFlow> {
//   bool _isUnlocked = false;

//   @override
//   Widget build(BuildContext context) {
//     if (!_isUnlocked) {
//       return SpexUnlockScreen(
//         onUnlock: () {
//           setState(() {
//             _isUnlocked = true;
//           });
//         },
//       );
//     }

//     // After unlock, show URL input
//     return const UrlInputScreen();
//   }
// }

import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/spex_home.dart';
import 'screens/url_input_screen.dart';
import 'widgets/unlock_screen.dart';
import 'providers/spex_chat_provider.dart';

void main() {
  runApp(const SpexApp());
}

class SpexApp extends StatelessWidget {
  const SpexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SpexChatProvider(),
      child: MaterialApp(
        title: 'SPEX.AI',
        theme: SpexTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<SpexChatProvider>();

    // If chat is active, go directly to chat
    if (chatProvider.isInitialized && chatProvider.isChatActive) {
      return const SpexHome();
    }

    // Otherwise start with unlock flow
    return const _UnlockFlowWrapper();
  }
}

class _UnlockFlowWrapper extends StatefulWidget {
  const _UnlockFlowWrapper();

  @override
  State<_UnlockFlowWrapper> createState() => _UnlockFlowWrapperState();
}

class _UnlockFlowWrapperState extends State<_UnlockFlowWrapper> {
  bool _isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return _isUnlocked
        ? const UrlInputScreen()
        : SpexUnlockScreen(
          onUnlock: () {
            setState(() {
              _isUnlocked = true;
            });
          },
        );
  }
}

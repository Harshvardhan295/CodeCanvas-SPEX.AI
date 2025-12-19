import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spex_chat_provider.dart';

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  State<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen> {
  final TextEditingController _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<SpexChatProvider>(context);

    return Scaffold(
      backgroundColor: SpexColors.spexBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF11111a), SpexColors.spexBg],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'SPEX',
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                fontSize: 48,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: '.AI',
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                fontSize: 48,
                                color: SpexColors.spexYellow,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Website to AI Chatbot',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SpexColors.spexTextSecondary,
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Input Card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(32),
                  decoration: SpexTheme.glassBox,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Website URL',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(
                            fontSize: 24,
                            color: SpexColors.spexWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the URL of the website you want to transform into an AI chatbot',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: SpexColors.spexTextSecondary),
                        ),
                        const SizedBox(height: 32),

                        // URL Input Field
                        Container(
                          decoration: BoxDecoration(
                            color: SpexColors.spexSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: SpexColors.spexBorder,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _urlController,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: SpexColors.spexWhite),
                            decoration: InputDecoration(
                              hintText: 'https://example.com',
                              hintStyle: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: SpexColors.spexTextSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              prefixIcon: Icon(
                                Icons.link,
                                color: SpexColors.spexCyan,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a website URL';
                              }
                              if (!Uri.parse(value).isAbsolute) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Crawling Parameters
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: SpexColors.spexSurface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: SpexColors.spexBorder,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crawling Parameters',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: SpexColors.spexCyan,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _CrawlingOption(
                                    label: 'Max Depth: 2',
                                    tooltip:
                                        'How deep to follow internal links',
                                  ),
                                  const SizedBox(width: 16),
                                  _CrawlingOption(
                                    label: 'Max Pages: 20',
                                    tooltip: 'Maximum pages to index',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Start Indexing Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                chatProvider.isCrawling
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          await chatProvider.initializeWebsite(
                                            _urlController.text.trim(),
                                          );
                                          // Navigation handled automatically via provider state
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Error: $e',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              backgroundColor: Colors.black87,
                                            ),
                                          );
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SpexColors.spexYellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child:
                                chatProvider.isCrawling
                                    ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Crawling Website...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                    : chatProvider.isIndexing
                                    ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Indexing Content...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                    : const Text(
                                      'Start Indexing',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),

                        // Progress Indicator
                        if (chatProvider.isCrawling ||
                            chatProvider.isIndexing) ...[
                          const SizedBox(height: 20),
                          LinearProgressIndicator(
                            value: chatProvider.isCrawling ? null : 0.7,
                            backgroundColor: SpexColors.spexSurface,
                            color: SpexColors.spexCyan,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            chatProvider.isCrawling
                                ? 'Crawling website pages...'
                                : 'Indexing content for AI chat...',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: SpexColors.spexTextSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Footer Info
                Text(
                  'SPEX will crawl the website, extract content, and create an AI chatbot that can answer questions about it.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SpexColors.spexTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

class _CrawlingOption extends StatelessWidget {
  final String label;
  final String tooltip;

  const _CrawlingOption({required this.label, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
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
          ).textTheme.bodySmall?.copyWith(color: SpexColors.spexTextSecondary),
        ),
      ),
    );
  }
}

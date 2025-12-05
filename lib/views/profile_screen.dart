import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _emailController;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailController.addListener(_updateCanSubmit);
  }

  void _updateCanSubmit() {
    final hasText = _emailController.text.trim().isNotEmpty;
    if (hasText != _canSubmit) {
      setState(() => _canSubmit = hasText);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateCanSubmit);
    _emailController.dispose();
    super.dispose();
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // make the scrollable area at least the height of the viewport so we can center vertically
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Center(
            // keep the same padded, constrained column but now centered vertically
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 35,
                      child: Image.network(
                        'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text('Sign in', style: heading2, textAlign: TextAlign.start),
                    const SizedBox(height: 10),
                    const Text(
                      'Enter your email to continue',
                      style: normalText,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: 'Email address',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ElevatedButton that is disabled when the text field is empty
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: _canSubmit
                            ? () {
                                final email = _emailController.text.trim();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Continue with: ${email.isEmpty ? '(empty)' : email}')),
                                );
                              }
                            : null,
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
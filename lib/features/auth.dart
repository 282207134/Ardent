import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import '../shared/widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(this.state, this.mode, {super.key});
  final AppState state;
  final String mode;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(text: 'Maria');
  final last = TextEditingController(text: 'Osa');
  final username = TextEditingController(text: 'Maria Osa');
  final password = TextEditingController(text: 'demo1234');
  final phone = TextEditingController(text: '+12 1234567890');
  bool hidden = true;
  bool get signup => widget.mode == 'signup';
  bool get forgot => widget.mode == 'forgot';
  @override
  void dispose() {
    for (final c in [name, last, username, password, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  void login() {
    widget.state.signIn();
    Navigator.pushNamedAndRemoveUntil(
      context,
      widget.state.setupComplete ? '/home' : '/goal',
      (_) => false,
    );
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    if (forgot) {
      open(context, '/verify');
      return;
    }
    if (signup) {
      widget.state.update(() {
        widget.state.name = '${name.text.trim()} ${last.text.trim()}';
        widget.state.phone = phone.text.trim();
      });
    }
    login();
  }

  Widget field(
    String label,
    TextEditingController c, {
    bool secret = false,
    bool mobile = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: c,
      obscureText: secret && hidden,
      keyboardType: mobile ? TextInputType.phone : TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: secret
            ? IconButton(
                tooltip: 'Show or hide password',
                icon: Icon(
                  hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () => setState(() => hidden = !hidden),
              )
            : null,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Please enter $label';
        if (secret && v.length < 6) return 'Use at least 6 characters';
        if (mobile && v.replaceAll(RegExp(r'\D'), '').length < 8) {
          return 'Enter a valid mobile number';
        }
        return null;
      },
    ),
  );
  void social(String provider) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$provider sign in', style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 12),
          const Text(
            'Explore the app with a demo account. Social sign in will be available when the service is connected.',
          ),
          const SizedBox(height: 24),
          ActionButton('Explore demo', () {
            Navigator.pop(context);
            login();
          }),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    body: LayoutBuilder(
      builder: (context, size) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.viewInsetsOf(context).bottom > 0
                  ? 130
                  : size.maxHeight * (signup ? .25 : .33),
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Photo('auth', fit: BoxFit.fill),
                  if (forgot)
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forgot
                          ? 'Forgot\nPassword'
                          : signup
                          ? 'Welcome\ncreate your account'
                          : 'Welcome\nlog in to continue',
                      style: const TextStyle(fontSize: 34, height: 1.05),
                    ),
                    const SizedBox(height: 32),
                    if (signup) ...[
                      Row(
                        children: [
                          Expanded(child: field('First Name', name)),
                          const SizedBox(width: 20),
                          Expanded(child: field('Last Name', last)),
                        ],
                      ),
                    ],
                    if (signup || forgot) field('Mobile', phone, mobile: true),
                    if (!forgot && !signup) field('Username', username),
                    if (!forgot) field('Password', password, secret: true),
                    if (forgot)
                      const Text(
                        'Enter your registered mobile number to receive the instructions to reset your password.',
                        style: TextStyle(color: AppColors.muted, fontSize: 14),
                      ),
                    if (!forgot && !signup)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => open(context, '/forgot'),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ActionButton(
                        forgot
                            ? 'Send me now'
                            : signup
                            ? 'Create account'
                            : 'Log in',
                        submit,
                        red: true,
                        arrow: !forgot,
                      ),
                    ),
                    if (!forgot) ...[
                      const SizedBox(height: 26),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'or login via',
                              style: TextStyle(color: Colors.black26),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 12,
                        children: [
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF3992FA),
                            ),
                            onPressed: () => social('Facebook'),
                            icon: const Text(
                              'f',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            label: const Text('Facebook'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => social('Google'),
                            icon: const Text(
                              'G',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            label: const Text(
                              'Google',
                              style: TextStyle(color: AppColors.ink),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            signup ? '/login' : '/signup',
                          ),
                          child: Text(
                            signup
                                ? 'Have an account? Sign In'
                                : 'Here for the first time? Sign Up',
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Demo account · no online account required',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final code = TextEditingController();
  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(),
            const Text('Verification', style: TextStyle(fontSize: 34)),
            const SizedBox(height: 8),
            const Text(
              'Enter your four-digit verification code',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: code,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 38, letterSpacing: 28),
              decoration: const InputDecoration(
                hintText: '− − − −',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Demo verification code: 5555',
              style: TextStyle(color: AppColors.blue),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: ActionButton('Verify', () {
                if (code.text != '5555') {
                  notice(context, 'Please enter the demo code 5555.');
                  return;
                }
                FocusScope.of(context).unfocus();
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Verification complete'),
                    content: const Text(
                      'This demo does not send SMS or store passwords. You can return to the demo login.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (_) => false,
                        ),
                        child: const Text('Back to login'),
                      ),
                    ],
                  ),
                );
              }, red: true),
            ),
          ],
        ),
      ),
    ),
  );
}

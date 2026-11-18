import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_textfield.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../root/root_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  final auth = AuthService();
  final userService = UserService();

  void handleSignup() async {
    if (loading) return; // ✅ prevent double tap

    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    try {
      final user = await auth.signup(
        email.text.trim(),
        password.text.trim(),
      );

      if (user != null) {
        final newUser = AppUser(
          uid: user.uid,
          email: user.email!,
          name: name.text.trim(),
        );

        await userService.createUser(newUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RootScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception:', '').trim(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // ================= BRAND =================
              const Text(
                "CloudMoV",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Create your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),

              // ================= NAME =================
              AppTextField(
                controller: name,
                label: "Full Name",
                backgroundColor: const Color(0xFF1E1E1E),
                textColor: Colors.white,
              ),
              const SizedBox(height: 15),

              // ================= EMAIL =================
              AppTextField(
                controller: email,
                label: "Email",
                backgroundColor: const Color(0xFF1E1E1E),
                textColor: Colors.white,
              ),
              const SizedBox(height: 15),

              // ================= PASSWORD =================
              AppTextField(
                controller: password,
                label: "Password",
                obscure: true,
                backgroundColor: const Color(0xFF1E1E1E),
                textColor: Colors.white,
              ),

              const SizedBox(height: 25),

              // ================= SIGN UP BUTTON =================
              AppButton(
                text: "Create Account",
                loading: loading,
                onTap: handleSignup, // ✅ ALWAYS non-null
                backgroundColor: const Color(0xFFE50914),
                textColor: Colors.white,
              ),

              const SizedBox(height: 20),

              // ================= DIVIDER =================
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),

              const SizedBox(height: 10),

              // ================= LOGIN LINK =================
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

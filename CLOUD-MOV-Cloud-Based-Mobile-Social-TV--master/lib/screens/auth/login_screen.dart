import 'package:flutter/material.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_textfield.dart';
import '../../services/auth_service.dart';
import '../root/root_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  final auth = AuthService();

  void handleLogin() async {
    if (loading) return; // ✅ prevent double tap

    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    try {
      await auth.login(
        email.text.trim(),
        password.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootScreen()),
      );
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

              // ================= LOGO =================
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
                "Sign in to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),

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

              // ================= LOGIN BUTTON =================
              AppButton(
                text: "Login",
                loading: loading,
                onTap: handleLogin, // ✅ ALWAYS pass a function
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

              // ================= SIGN UP =================
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Create an account",
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

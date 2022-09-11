import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/injection.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final authController = i<AuthController>();
  var email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(),
              _buildEmailField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/logo.svg',
        height: 100,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) {
          final isLoading = authController.isLoading;

          if (isLoading) {
            return const OutlinedButton(
              onPressed: null,
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }

          return OutlinedButton(
            onPressed: () => authController.sendPasswordResetEmail(email),
            child: const Text('Solicitar Redefinição de Senha'),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Observer(
      builder: (_) {
        final isLoading = authController.isLoading;

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed:
                    !isLoading ? authController.navigateToLoginPage : null,
                child: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed:
                    !isLoading ? authController.navigateToRegisterPage : null,
                child: const Text('Solicitar Cadastro'),
              ),
            ),
          ],
        );
      },
    );
  }
}

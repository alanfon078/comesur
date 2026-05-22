// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'logic/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _controller = AuthController();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _contrasenaCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await _controller.login(_correoCtrl.text.trim(), _contrasenaCtrl.text);
    if (ok && mounted) _irAlHome();
  }

  Future<void> _loginGoogle() async {
    final ok = await _controller.loginConGoogle();
    if (ok && mounted) _irAlHome();
  }

  Future<void> _loginFacebook() async {
    final ok = await _controller.loginConFacebook();
    if (ok && mounted) _irAlHome();
  }

  void _irAlHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo y Título
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'COMESUR',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.black,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'BIENVENIDO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Center(
                  child: Text(
                    '¿QUÉ BUSCAS COMER?',
                    style: TextStyle(fontSize: 14, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: 40),

                // Error
                if (_controller.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _controller.error!,
                      style: TextStyle(color: Colors.red[800], fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
// Correo
                const Text('CORREO ELECTRÓNICO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _correoCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'ejemplo@correo.com',
                    filled: true,
                    fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'El correo es requerido';
                    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!emailRegex.hasMatch(v)) return 'Correo inválido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Contraseña
                const Text('CONTRASEÑA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contrasenaCtrl, // Faltaba el controlador para la contraseña
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: '******',
                    filled: true,
                    fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Botón Iniciar Sesión
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _controller.isLoading ? null : _iniciarSesion,
                  child: _controller.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('INICIAR SESIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),

                const Center(child: Text('O ingresa con')),
                const SizedBox(height: 20),

                // Google
                OutlinedButton.icon(
                  icon: Icon(Icons.g_mobiledata, color: isDark ? Colors.white : Colors.black, size: 30),
                  label: Text('Login con Google', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                  onPressed: _controller.isLoading ? null : _loginGoogle,
                ),
                const SizedBox(height: 12),

                // Facebook
                OutlinedButton.icon(
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  label: Text('Login con Facebook', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                  onPressed: _controller.isLoading ? null : _loginFacebook,
                ),
                const SizedBox(height: 30),

                // Crear cuenta nueva
                TextButton(
                  onPressed: _controller.isLoading
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          ),
                  child: Text(
                    'Crear Cuenta Nueva',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Icon(
                    Icons.fastfood_rounded,
                    size: 60,
                    color: primaryColor.withOpacity(0.5),
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
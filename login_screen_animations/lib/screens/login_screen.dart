import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _logoVisible = false;
  bool _formVisible = false;

  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isError = false;

  double _buttonScale = 1.0;
  double _checkmarkScale = 0.0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Animation<double> _shakeAnimation;

  void _onButtonTapDown(TapDownDetails details) {
    setState(() => _buttonScale = 0.95);
  }

  void _onButtonTapUp(TapUpDetails details) {
    setState(() => _buttonScale = 1.0);
  }

  Future<void> _login() async {
    setState(() {
      _isError = false;
      _isSuccess = false;
      _checkmarkScale = 0.0;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _isError = true);
      _shake();
      _showError('Please fill all fields');
      return;
    }

    setState(() {
      _isError = false;
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (_emailController.text == 'test@test.com' &&
        _passwordController.text == '123456') {
      setState(() => _isSuccess = true);
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => _checkmarkScale = 1.0);
    } else {
      setState(() => _isError = true);
      _shake();
      _showError('Invalid credentials');
    }

    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _checkmarkScale = 1.0);
  }

  void _shake() {
    _controller.reset();
    _controller.forward();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _reset() {
    setState(() {
      _isError = false;
      _isSuccess = false;
      _isLoading = false;
      _checkmarkScale = 0.0;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _logoVisible = true);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _formVisible = true);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _logoVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Icon(
                    Icons.lock,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          AnimatedPositioned(
            bottom: _formVisible ? 0 : -300,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                child: _isSuccess
                    ? Column(
                        key: const ValueKey('success'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            key: const ValueKey('success'),
                            scale: _checkmarkScale,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 100,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Try Again'),
                          ),
                        ],
                      )
                    : _isLoading
                    ? const Center(
                        key: ValueKey('loader'),
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: Padding(
                          key: const ValueKey('form'),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                  errorText: _isError ? ' ' : null,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                  errorText: _isError ? ' ' : null,
                                ),
                                obscureText: true,
                              ),
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTapDown: _onButtonTapDown,
                                onTapUp: _onButtonTapUp,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  transform: Matrix4.identity()
                                    ..scale(_buttonScale),
                                  transformAlignment: Alignment.center,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      child: const Text('Login'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

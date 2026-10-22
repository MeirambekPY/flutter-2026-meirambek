import 'package:flutter/material.dart';
import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
    home: const SignUpScreen(),
  );
}

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birthDate;
  bool _agreed = false;
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _birthController]) {
      c.dispose();
    }
    _emailFocus.dispose();
    super.dispose();
  }

  void _clearForm() {
    _name.clear();
    _email.clear();
    _password.clear();
    _confirm.clear();
    _birthController.clear();
    setState(() {
      _group = null;
      _birthDate = null;
      _agreed = false;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: _done
          ? Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SummaryCard(
                name: _name.text,
                email: _email.text,
                group: _group ?? '',
                birthDate: _birthController.text,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _clearForm,
                child: const Text('Start over'),
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) {
                  final val = (v ?? '').trim();
                  if (val.isEmpty) return 'Name is required';
                  if (val.length < 2) return 'Name is too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _email,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'name@kbtu.kz',
                ),
                validator: (v) {
                  final val = (v ?? '').trim();
                  if (val.isEmpty) return 'Email is required';
                  if (!val.contains('@') || !val.contains('.')) {
                    return 'Email looks wrong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _password,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Password',
                  helperText: 'At least 8 characters',
                  counterText: '${_password.text.length} of 8',
                ),
                validator: (v) {
                  final val = v ?? '';
                  if (val.length < 8) return 'Password is too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirm,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                decoration: const InputDecoration(labelText: 'Confirm password'),
                validator: (v) {
                  if ((v ?? '') != _password.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Group'),
                items: groups
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (g) => setState(() => _group = g),
                validator: (g) => g == null ? 'Choose a group' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _birthController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime(2005, 1, 1),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && context.mounted) {
                    setState(() {
                      _birthDate = picked;
                      _birthController.text =
                      '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
                    });
                  }
                },
                validator: (_) => _birthDate == null ? 'Choose a date of birth' : null,
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                title: const Text('I agree to the rules'),
                value: _agreed,
                onChanged: (val) => setState(() => _agreed = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: !_agreed
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _done = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account created')),
                    );
                  }
                },
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
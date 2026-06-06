import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../services/laravel_api.dart';

<<<<<<< HEAD
const _primary = Color(0xFF17C1E8);
const _primaryDark = Color(0xFF0F3047);
const _success = Color(0xFF21A67A);
const _warning = Color(0xFFF59E0B);
const _danger = Color(0xFFDC2626);
const _ink = Color(0xFF172033);
const _muted = Color(0xFF667085);
const _line = Color(0xFFE4E7EC);
const _surface = Color(0xFFF7F8FB);
=======
const _primary = Color(0xFF1F6FBF);
const _primaryDark = Color(0xFF163B67);
const _success = Color(0xFF0FB37B);
const _warning = Color(0xFFF59E0B);
const _danger = Color(0xFFDC2626);
const _bg = Color(0xFFF8FAFC);
const _border = Color(0xFFE2E8F0);
const _text = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

class IncubateeApp extends StatefulWidget {
  const IncubateeApp({super.key});

  @override
  State<IncubateeApp> createState() => _IncubateeAppState();
}

class _IncubateeAppState extends State<IncubateeApp> {
  final LaravelApi api = LaravelApi();
  late Future<void> _boot;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _boot = _load();
  }

  Future<void> _load() async {
    await api.loadSession();
    if (api.isAuthenticated) {
      try {
        _user = await api.me();
      } catch (_) {
        await api.clearSession();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'Pickle Ballan ni Juan',
=======
      title: 'DSSC Agri-Food TBI',
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
<<<<<<< HEAD
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          primary: _primary,
          secondary: _success,
        ),
        scaffoldBackgroundColor: _surface,
=======
        colorScheme: ColorScheme.fromSeed(seedColor: _primary),
        scaffoldBackgroundColor: _bg,
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        fontFamily: 'Arial',
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
<<<<<<< HEAD
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _primary, width: 1.4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(44, 44),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryDark,
            minimumSize: const Size(44, 44),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
=======
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _border),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
          ),
        ),
      ),
      home: FutureBuilder<void>(
        future: _boot,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingScreen();
          }

          if (_user == null) {
            return AuthScreen(
              api: api,
              onAuthenticated: (user) => setState(() => _user = user),
            );
          }

          return PortalShell(
            api: api,
            user: _user!,
<<<<<<< HEAD
            onUserChanged: (user) => setState(() => _user = user),
=======
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
            onLogout: () async {
              await api.logout();
              setState(() => _user = null);
            },
          );
        },
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
<<<<<<< HEAD
  const AuthScreen({
    super.key,
    required this.api,
    required this.onAuthenticated,
  });
=======
  const AuthScreen(
      {super.key, required this.api, required this.onAuthenticated});
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

  final LaravelApi api;
  final ValueChanged<Map<String, dynamic>> onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
<<<<<<< HEAD
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController(text: 'user@example.com');
  final _mobile = TextEditingController();
  final _password = TextEditingController(text: 'password');
  final _confirm = TextEditingController(text: 'password');
=======
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  bool _register = false;
  bool _busy = false;
  String? _error;

<<<<<<< HEAD
  @override
  void dispose() {
    for (final controller in [
      _firstName,
      _lastName,
      _email,
      _mobile,
      _password,
      _confirm,
=======
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  final _business = TextEditingController();
  final _address = TextEditingController();
  final _focus = TextEditingController();

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _confirm,
      _phone,
      _business,
      _address,
      _focus
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
<<<<<<< HEAD

    try {
      final user = _register
          ? await widget.api.register(
              firstName: _firstName.text.trim(),
              lastName: _lastName.text.trim(),
              email: _email.text.trim(),
              mobileNumber: _mobile.text.trim(),
              password: _password.text,
              passwordConfirmation: _confirm.text,
=======
    try {
      final user = _register
          ? await widget.api.register(
              name: _name.text.trim(),
              email: _email.text.trim(),
              password: _password.text,
              passwordConfirmation: _confirm.text,
              phone: _phone.text.trim(),
              businessName: _business.text.trim(),
              businessAddress: _address.text.trim(),
              focusArea: _focus.text.trim(),
              stage: 'Screening',
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
            )
          : await widget.api.login(
              email: _email.text.trim(),
              password: _password.text,
            );
      widget.onAuthenticated(user);
    } on LaravelApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
<<<<<<< HEAD
              constraints: const BoxConstraints(maxWidth: 1040),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 840;
                  final brand = _AuthBrand(api: widget.api);
                  final form = _AuthCard(
                    formKey: _formKey,
                    register: _register,
                    busy: _busy,
                    error: _error,
                    firstName: _firstName,
                    lastName: _lastName,
                    email: _email,
                    mobile: _mobile,
                    password: _password,
                    confirm: _confirm,
                    onModeChanged: (value) => setState(() {
                      _register = value;
                      _error = null;
                    }),
                    onSubmit: _submit,
                  );

                  if (!wide) {
                    return Column(
                      children: [brand, const SizedBox(height: 16), form],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: brand),
=======
              constraints: const BoxConstraints(maxWidth: 980),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 820;
                  final form = _AuthCard(
                    register: _register,
                    busy: _busy,
                    error: _error,
                    formKey: _formKey,
                    name: _name,
                    email: _email,
                    password: _password,
                    confirm: _confirm,
                    phone: _phone,
                    business: _business,
                    address: _address,
                    focus: _focus,
                    onModeChanged: (value) => setState(() => _register = value),
                    onSubmit: _submit,
                  );

                  const brand = _AuthBrand();
                  if (!wide) {
                    return Column(
                        children: [brand, const SizedBox(height: 16), form]);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: _AuthBrand()),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
                      const SizedBox(width: 24),
                      Expanded(child: form),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthBrand extends StatelessWidget {
<<<<<<< HEAD
  const _AuthBrand({required this.api});

  final LaravelApi api;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.16,
            child: Image.network(
              api.publicAsset('/images/671478450_122128991829155269_859094970721700938_n.jpg'),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _primaryDark,
                child: const Icon(Icons.sports_tennis,
                    color: Colors.white, size: 80),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.28),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pickle Ballan ni Juan',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Court booking, GCash verification, receipts, and profile records connected to Laravel MySQL.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ],
            ),
=======
  const _AuthBrand();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _primaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _Logo(size: 52),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DSSC',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 3)),
                    Text('Agri-Food Innovation TBI',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Incubatee Portal',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Submit applications, book facilities, report quarterly KPIs, and track your MOA status from the same MySQL data used by Laravel.',
            style: TextStyle(color: Color(0xFFC7D9EF), height: 1.5),
          ),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SoftPill(icon: Icons.assignment_outlined, label: 'Applications'),
              _SoftPill(icon: Icons.calendar_month_outlined, label: 'Bookings'),
              _SoftPill(icon: Icons.analytics_outlined, label: 'KPIs'),
              _SoftPill(icon: Icons.description_outlined, label: 'MOA'),
            ],
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
<<<<<<< HEAD
    required this.formKey,
    required this.register,
    required this.busy,
    required this.error,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirm,
=======
    required this.register,
    required this.busy,
    required this.error,
    required this.formKey,
    required this.name,
    required this.email,
    required this.password,
    required this.confirm,
    required this.phone,
    required this.business,
    required this.address,
    required this.focus,
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    required this.onModeChanged,
    required this.onSubmit,
  });

<<<<<<< HEAD
  final GlobalKey<FormState> formKey;
  final bool register;
  final bool busy;
  final String? error;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController mobile;
  final TextEditingController password;
  final TextEditingController confirm;
=======
  final bool register;
  final bool busy;
  final String? error;
  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirm;
  final TextEditingController phone;
  final TextEditingController business;
  final TextEditingController address;
  final TextEditingController focus;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  final ValueChanged<bool> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return _Panel(
=======
    return _Surface(
      padding: const EdgeInsets.all(20),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
<<<<<<< HEAD
          children: [
            Row(
              children: [
                Expanded(
                  child: _SegmentButton(
                    selected: !register,
                    label: 'Login',
                    icon: Icons.login,
                    onTap: () => onModeChanged(false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SegmentButton(
                    selected: register,
                    label: 'Register',
                    icon: Icons.person_add_alt_1,
                    onTap: () => onModeChanged(true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              register ? 'Create customer account' : 'Welcome back',
              style: const TextStyle(
                color: _ink,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              register
                  ? 'Use your mobile number and email for booking receipts.'
                  : 'Use the seeded account or your registered customer login.',
              style: const TextStyle(color: _muted, height: 1.35),
            ),
            const SizedBox(height: 18),
            if (error != null) ...[
              _Notice(text: error!, tone: _danger),
              const SizedBox(height: 12),
            ],
            if (register) ...[
              _TwoColumnFields(
                children: [
                  _LabeledField(
                    label: 'First name',
                    controller: firstName,
                    validator: _required,
                  ),
                  _LabeledField(
                    label: 'Last name',
                    controller: lastName,
                    validator: _required,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            _LabeledField(
              label: 'Email',
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value != null && value.contains('@') ? null : 'Valid email required',
            ),
            if (register) ...[
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Mobile number',
                controller: mobile,
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
            ],
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Password',
              controller: password,
              obscureText: true,
              validator: _required,
            ),
            if (register) ...[
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Confirm password',
                controller: confirm,
                obscureText: true,
                validator: (value) =>
                    value == password.text ? null : 'Passwords must match',
              ),
            ],
            const SizedBox(height: 18),
            ElevatedButton.icon(
=======
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                    value: false,
                    icon: Icon(Icons.login),
                    label: Text('Login')),
                ButtonSegment(
                    value: true,
                    icon: Icon(Icons.person_add_alt),
                    label: Text('Register')),
              ],
              selected: {register},
              onSelectionChanged: (value) => onModeChanged(value.first),
            ),
            const SizedBox(height: 18),
            if (register) ...[
              _Field(
                  controller: name,
                  label: 'Full name',
                  icon: Icons.person_outline),
              const SizedBox(height: 12),
            ],
            _Field(
                controller: email,
                label: 'Email',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _Field(
                controller: password,
                label: 'Password',
                icon: Icons.lock_outline,
                obscure: true),
            if (register) ...[
              const SizedBox(height: 12),
              _Field(
                  controller: confirm,
                  label: 'Confirm password',
                  icon: Icons.lock_reset,
                  obscure: true),
              const SizedBox(height: 12),
              _Field(
                  controller: phone,
                  label: 'Phone',
                  icon: Icons.phone_outlined,
                  required: false),
              const SizedBox(height: 12),
              _Field(
                  controller: business,
                  label: 'Business name',
                  icon: Icons.storefront_outlined,
                  required: false),
              const SizedBox(height: 12),
              _Field(
                  controller: address,
                  label: 'Business address',
                  icon: Icons.location_on_outlined,
                  required: false),
              const SizedBox(height: 12),
              _Field(
                  controller: focus,
                  label: 'Focus area',
                  icon: Icons.eco_outlined,
                  required: false),
            ],
            if (error != null) ...[
              const SizedBox(height: 12),
              _Message(text: error!, color: _danger),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
              onPressed: busy ? null : onSubmit,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
<<<<<<< HEAD
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(register ? Icons.person_add_alt_1 : Icons.login),
              label: Text(register ? 'Create account' : 'Login'),
=======
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(register ? Icons.person_add_alt : Icons.login),
              label: Text(register ? 'Create account' : 'Sign in'),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
            ),
          ],
        ),
      ),
    );
  }
}

class PortalShell extends StatefulWidget {
  const PortalShell({
    super.key,
    required this.api,
    required this.user,
<<<<<<< HEAD
    required this.onUserChanged,
=======
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    required this.onLogout,
  });

  final LaravelApi api;
  final Map<String, dynamic> user;
<<<<<<< HEAD
  final ValueChanged<Map<String, dynamic>> onUserChanged;
=======
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  final Future<void> Function() onLogout;

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  int _index = 0;
  int _refresh = 0;
<<<<<<< HEAD
  late Future<Map<String, dynamic>> _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = widget.api.catalog();
  }

  void _reload() {
    setState(() {
      _refresh++;
      _catalog = widget.api.catalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _catalog,
      builder: (context, snapshot) {
        final catalog = snapshot.data ?? <String, dynamic>{};
        final loading = snapshot.connectionState != ConnectionState.done;
        final pages = [
          DashboardPage(api: widget.api, refresh: _refresh),
          BookingsPage(
            api: widget.api,
            catalog: catalog,
            refresh: _refresh,
            onChanged: _reload,
          ),
          PaymentsPage(
            api: widget.api,
            refresh: _refresh,
            onChanged: _reload,
          ),
          ReceiptsPage(api: widget.api, refresh: _refresh),
          ProfilePage(
            api: widget.api,
            user: widget.user,
            onUserChanged: widget.onUserChanged,
          ),
        ];

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final content = Column(
                children: [
                  _TopBar(
                    api: widget.api,
                    user: widget.user,
                    loading: loading,
                    onRefresh: _reload,
                    onLogout: widget.onLogout,
                  ),
                  Expanded(child: pages[_index]),
                ],
              );

              if (!wide) {
                return content;
              }

              return Row(
                children: [
                  NavigationRail(
                    selectedIndex: _index,
                    onDestinationSelected: (value) =>
                        setState(() => _index = value),
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.white,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.space_dashboard_outlined),
                        selectedIcon: Icon(Icons.space_dashboard),
                        label: Text('Dashboard'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.event_note_outlined),
                        selectedIcon: Icon(Icons.event_note),
                        label: Text('Bookings'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.payments_outlined),
                        selectedIcon: Icon(Icons.payments),
                        label: Text('GCash'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.receipt_long_outlined),
                        selectedIcon: Icon(Icons.receipt_long),
                        label: Text('Receipts'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1, color: _line),
                  Expanded(child: content),
                ],
              );
            },
          ),
          bottomNavigationBar: MediaQuery.sizeOf(context).width < 900
              ? NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.space_dashboard_outlined),
                      selectedIcon: Icon(Icons.space_dashboard),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.event_note_outlined),
                      selectedIcon: Icon(Icons.event_note),
                      label: 'Bookings',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.payments_outlined),
                      selectedIcon: Icon(Icons.payments),
                      label: 'GCash',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long),
                      label: 'Receipts',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                )
              : null,
=======

  final _items = const [
    _NavItem('Dashboard', Icons.dashboard_outlined),
    _NavItem('My Application', Icons.assignment_outlined),
    _NavItem('My Bookings', Icons.calendar_month_outlined),
    _NavItem('Progress & KPIs', Icons.analytics_outlined),
    _NavItem('MOA Status', Icons.description_outlined),
  ];

  void _markChanged() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;
        final page = KeyedSubtree(
          key: ValueKey('$_index-$_refresh'),
          child: _pageForIndex(),
        );

        return Scaffold(
          body: Row(
            children: [
              if (desktop)
                _Sidebar(
                  items: _items,
                  selected: _index,
                  user: widget.user,
                  onSelected: (value) => setState(() => _index = value),
                  onLogout: widget.onLogout,
                ),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      _TopBar(
                        title: _items[_index].label,
                        user: widget.user,
                        showMenu: !desktop,
                        onLogout: widget.onLogout,
                      ),
                      Expanded(child: page),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  destinations: _items
                      .map((item) => NavigationDestination(
                          icon: Icon(item.icon), label: item.shortLabel))
                      .toList(),
                ),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        );
      },
    );
  }
<<<<<<< HEAD
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.api,
    required this.user,
    required this.loading,
    required this.onRefresh,
    required this.onLogout,
  });

  final LaravelApi api;
  final Map<String, dynamic> user;
  final bool loading;
  final VoidCallback onRefresh;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final name = (user['display_name'] ?? user['email'] ?? 'Customer').toString();
    return Material(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sports_tennis, color: _primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickle Ballan ni Juan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: loading ? null : onRefresh,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
              ),
              IconButton(
                tooltip: 'Logout',
                onPressed: () => onLogout(),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
=======

  Widget _pageForIndex() {
    switch (_index) {
      case 1:
        return ApplicationsPage(api: widget.api, onChanged: _markChanged);
      case 2:
        return BookingsPage(api: widget.api, onChanged: _markChanged);
      case 3:
        return ReportsPage(api: widget.api, onChanged: _markChanged);
      case 4:
        return MoaPage(api: widget.api);
      default:
        return DashboardPage(
            api: widget.api, onJump: (index) => setState(() => _index = index));
    }
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  }
}

class DashboardPage extends StatelessWidget {
<<<<<<< HEAD
  const DashboardPage({super.key, required this.api, required this.refresh});

  final LaravelApi api;
  final int refresh;

  @override
  Widget build(BuildContext context) {
    return _FutureBody<Map<String, dynamic>>(
      future: api.dashboard(),
      builder: (context, data) {
        final metrics = _asList(data['metrics']);
        final health = _asList(data['reservation_health']);
        final recent = _asList(data['recent_bookings']);
        return _ScreenScroll(
          children: [
            _HeroStrip(api: api),
            const SizedBox(height: 16),
            _ResponsiveCards(
              minWidth: 210,
              children: metrics
                  .map(
                    (metric) => _StatTile(
                      label: _string(metric['label']),
                      value: _string(metric['value']),
                      icon: _metricIcon(_string(metric['icon'])),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            _Panel(
              title: 'Reservation Health',
              child: Column(
                children: health
                    .map(
                      (row) => _ProgressRow(
                        label: _string(row['label']),
                        value: _asInt(row['value']),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _Panel(
              title: 'Recent Bookings',
              trailing: const Icon(Icons.event_note, color: _primary),
              child: recent.isEmpty
                  ? const _EmptyState(text: 'No bookings yet.')
                  : Column(
                      children: recent
                          .map((booking) => _CompactBookingRow(booking: booking))
                          .toList(),
                    ),
=======
  const DashboardPage({super.key, required this.api, required this.onJump});

  final LaravelApi api;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    return _FuturePane<Map<String, dynamic>>(
      future: api.dashboard(),
      builder: (data) {
        final stats = Map<String, dynamic>.from(data['stats'] as Map? ?? {});
        final incubatee =
            Map<String, dynamic>.from(data['incubatee'] as Map? ?? {});
        final recent = _asList(data['recent_applications']);
        final bookings = _asList(data['upcoming_bookings']);
        final metrics = _asList(data['kpi_metrics']);
        final deadline = data['report_deadline']?.toString();

        return _PageScroll(
          children: [
            _ProfileHeader(incubatee: incubatee, deadline: deadline),
            _ResponsiveGrid(
              minWidth: 190,
              children: [
                _StatCard(
                    label: 'Applications',
                    value:
                        '${stats['applications_pending'] ?? 0}/${stats['applications_approved'] ?? 0}',
                    caption: 'Pending / Approved',
                    icon: Icons.assignment_outlined,
                    color: _warning),
                _StatCard(
                    label: 'Bookings',
                    value: '${stats['bookings_pending'] ?? 0}',
                    caption: 'Waiting for approval',
                    icon: Icons.calendar_month_outlined,
                    color: _success),
                _StatCard(
                    label: 'Compliance',
                    value: '${stats['violations_open'] ?? 0}',
                    caption: 'Open violations',
                    icon: Icons.shield_outlined,
                    color: _danger),
                _StatCard(
                    label: 'Trainings',
                    value: '${stats['trainings'] ?? 0}',
                    caption: 'Available sessions',
                    icon: Icons.school_outlined,
                    color: _primary),
              ],
            ),
            _SectionGrid(
              left: _Surface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                        title: 'KPI & Monitoring Trend', action: 'Performance'),
                    const SizedBox(height: 12),
                    if (metrics.isEmpty)
                      const _EmptyState(
                          icon: Icons.analytics_outlined,
                          text: 'No progress reports yet.')
                    else
                      _KpiBars(metrics: metrics),
                  ],
                ),
              ),
              right: _Surface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(title: 'Quick Actions'),
                    const SizedBox(height: 12),
                    _ActionButton(
                        icon: Icons.assignment_outlined,
                        label: 'My Application',
                        onTap: () => onJump(1)),
                    _ActionButton(
                        icon: Icons.calendar_month_outlined,
                        label: 'Book a Facility',
                        onTap: () => onJump(2)),
                    _ActionButton(
                        icon: Icons.analytics_outlined,
                        label: 'Submit Progress',
                        onTap: () => onJump(3)),
                  ],
                ),
              ),
            ),
            _SectionGrid(
              left: _ListPreview(
                  title: 'My Applications',
                  rows: recent,
                  empty: 'No applications found.',
                  titleOf: (row) => row['title']?.toString() ?? 'Application',
                  subtitleOf: (row) => _formatDate(row['submitted_at']),
                  statusOf: (row) => row['status']?.toString()),
              right: _ListPreview(
                  title: 'My Bookings',
                  rows: bookings,
                  empty: 'No upcoming bookings.',
                  titleOf: (row) => row['title']?.toString() ?? 'Booking',
                  subtitleOf: (row) => _formatDate(row['start_at']),
                  statusOf: (row) => row['status']?.toString()),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
            ),
          ],
        );
      },
    );
  }
}

<<<<<<< HEAD
class BookingsPage extends StatelessWidget {
  const BookingsPage({
    super.key,
    required this.api,
    required this.catalog,
    required this.refresh,
    required this.onChanged,
  });

  final LaravelApi api;
  final Map<String, dynamic> catalog;
  final int refresh;
  final VoidCallback onChanged;

  Future<void> _openCreate(BuildContext context) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => BookingDialog(api: api, catalog: catalog),
    );
    if (changed == true) onChanged();
  }

  Future<void> _openEdit(
    BuildContext context,
    Map<String, dynamic> booking,
  ) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => BookingDialog(
        api: api,
        catalog: catalog,
        booking: booking,
      ),
    );
    if (changed == true) onChanged();
  }

  Future<void> _openPay(BuildContext context, Map<String, dynamic> booking) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => PayGcashDialog(api: api, booking: booking),
    );
    if (changed == true) onChanged();
  }

  Future<void> _cancel(BuildContext context, Map<String, dynamic> booking) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel booking'),
        content: Text(
          'Cancel ${_string(booking['reservation_code'])}?',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.event_busy),
            label: const Text('Cancel booking'),
=======
class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage(
      {super.key, required this.api, required this.onChanged});

  final LaravelApi api;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _FuturePane<List<Map<String, dynamic>>>(
      future: api.applications(),
      builder: (rows) => _PageScroll(
        action: FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Submit'),
          onPressed: () => _openApplicationForm(context, api, onChanged),
        ),
        children: [
          _Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: 'My Application', action: 'Annex A'),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  const _EmptyState(
                      icon: Icons.assignment_outlined,
                      text: 'No applications submitted yet.')
                else
                  ...rows.map((row) => _DataTile(
                        icon: Icons.assignment_outlined,
                        title: row['title']?.toString() ?? 'Application',
                        subtitle: row['summary']?.toString() ?? 'No summary',
                        meta: _formatDate(row['submitted_at']),
                        status: row['status']?.toString(),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key, required this.api, required this.onChanged});

  final LaravelApi api;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _FuturePane<List<Map<String, dynamic>>>(
      future: api.bookings(),
      builder: (rows) => _PageScroll(
        action: FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Book'),
          onPressed: () => _openBookingForm(context, api, onChanged),
        ),
        children: [
          _Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: 'My Bookings', action: 'Facilities'),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  const _EmptyState(
                      icon: Icons.calendar_month_outlined,
                      text: 'No facility bookings yet.')
                else
                  ...rows.map((row) {
                    final equipment = row['equipment'] is Map
                        ? Map<String, dynamic>.from(row['equipment'] as Map)
                        : null;
                    return _DataTile(
                      icon: Icons.calendar_month_outlined,
                      title: row['title']?.toString() ?? 'Booking',
                      subtitle: equipment?['name']?.toString() ??
                          row['purpose']?.toString() ??
                          'Facility request',
                      meta:
                          '${_formatDate(row['start_at'])} - ${_formatDate(row['end_at'])}',
                      status: row['status']?.toString(),
                    );
                  }),
              ],
            ),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
          ),
        ],
      ),
    );
<<<<<<< HEAD

    if (ok != true) return;

    try {
      await api.cancelBooking(_asInt(booking['id']));
      onChanged();
    } on LaravelApiException catch (e) {
      if (context.mounted) {
        _showSnack(context, e.message, tone: _danger);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FutureBody<List<Map<String, dynamic>>>(
      future: api.bookings(),
      builder: (context, bookings) {
        return _ScreenScroll(
          header: _ActionHeader(
            title: 'Bookings',
            subtitle: '${bookings.length} court reservation records',
            actionLabel: 'Book court',
            icon: Icons.add,
            onAction: () => _openCreate(context),
          ),
          children: [
            if (bookings.isEmpty)
              const _Panel(child: _EmptyState(text: 'No booking records yet.')),
            ...bookings.map(
              (booking) => BookingCard(
                booking: booking,
                onEdit: _asBool(booking['can_edit'])
                    ? () => _openEdit(context, booking)
                    : null,
                onPay: _needsPayment(booking)
                    ? () => _openPay(context, booking)
                    : null,
                onCancel: _asBool(booking['can_cancel'])
                    ? () => _cancel(context, booking)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({
    super.key,
    required this.api,
    required this.refresh,
    required this.onChanged,
  });

  final LaravelApi api;
  final int refresh;
=======
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key, required this.api, required this.onChanged});

  final LaravelApi api;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return _FutureBody<List<Map<String, dynamic>>>(
      future: api.bookings(),
      builder: (context, bookings) {
        final payable = bookings.where(_needsPayment).toList();
        final pending = bookings
            .where((row) => _string(row['payment_status']) == 'pending_verification')
            .toList();
        return _ScreenScroll(
          header: const _PlainHeader(
            title: 'GCash',
            subtitle: 'Submit payment references for Laravel admin review.',
          ),
          children: [
            _Panel(
              title: 'Payment Queue',
              child: payable.isEmpty
                  ? const _EmptyState(text: 'No unpaid booking is waiting.')
                  : Column(
                      children: payable
                          .map(
                            (booking) => _PaymentRow(
                              booking: booking,
                              onPay: () async {
                                final changed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => PayGcashDialog(
                                    api: api,
                                    booking: booking,
                                  ),
                                );
                                if (changed == true) onChanged();
                              },
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 16),
            _Panel(
              title: 'Waiting For Verification',
              child: pending.isEmpty
                  ? const _EmptyState(text: 'No GCash proof is pending.')
                  : Column(
                      children: pending
                          .map((booking) => _CompactBookingRow(booking: booking))
                          .toList(),
                    ),
            ),
          ],
        );
      },
=======
    return _FuturePane<List<Map<String, dynamic>>>(
      future: api.reports(),
      builder: (rows) => _PageScroll(
        action: FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Report'),
          onPressed: () => _openReportForm(context, api, onChanged),
        ),
        children: [
          _Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                    title: 'Progress & KPIs', action: 'Quarterly'),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  const _EmptyState(
                      icon: Icons.analytics_outlined,
                      text: 'No KPI reports submitted yet.')
                else ...[
                  _KpiBars(metrics: rows.reversed.toList()),
                  const SizedBox(height: 16),
                  ...rows.map((row) => _DataTile(
                        icon: Icons.analytics_outlined,
                        title: row['label']?.toString() ?? 'Progress report',
                        subtitle:
                            'Revenue: ${row['revenue'] ?? 0} | Jobs: ${row['jobs_created'] ?? 0} | Customers: ${row['customers'] ?? 0}',
                        meta: row['notes']?.toString() ??
                            _formatDate(row['created_at']),
                        status: row['status']?.toString(),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    );
  }
}

<<<<<<< HEAD
class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key, required this.api, required this.refresh});

  final LaravelApi api;
  final int refresh;

  @override
  Widget build(BuildContext context) {
    return _FutureBody<List<Map<String, dynamic>>>(
      future: api.receipts(),
      builder: (context, receipts) {
        return _ScreenScroll(
          header: _PlainHeader(
            title: 'Receipts',
            subtitle: '${receipts.length} payment records from MySQL',
          ),
          children: [
            if (receipts.isEmpty)
              const _Panel(child: _EmptyState(text: 'No receipt records yet.')),
            ...receipts.map(
              (receipt) => _ReceiptCard(
                receipt: receipt,
                onOpen: () => showDialog<void>(
                  context: context,
                  builder: (_) => ReceiptDialog(receipt: receipt),
                ),
              ),
            ),
          ],
        );
      },
=======
class MoaPage extends StatelessWidget {
  const MoaPage({super.key, required this.api});

  final LaravelApi api;

  @override
  Widget build(BuildContext context) {
    return _FuturePane<List<Map<String, dynamic>>>(
      future: api.moas(),
      builder: (rows) => _PageScroll(
        children: [
          _Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: 'MOA Status', action: 'Documents'),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  const _EmptyState(
                      icon: Icons.description_outlined,
                      text: 'No MOA documents yet.')
                else
                  ...rows.map((row) => _DataTile(
                        icon: Icons.description_outlined,
                        title:
                            row['reference_code']?.toString() ?? 'MOA document',
                        subtitle: row['scope_purpose']?.toString() ??
                            'Awaiting agreement details',
                        meta:
                            '${row['effective_date'] ?? 'No effectivity date'} to ${row['expiry_date'] ?? 'No expiry date'}',
                        status: row['status']?.toString(),
                      )),
              ],
            ),
          ),
        ],
      ),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    );
  }
}

<<<<<<< HEAD
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.api,
    required this.user,
    required this.onUserChanged,
  });

  final LaravelApi api;
  final Map<String, dynamic> user;
  final ValueChanged<Map<String, dynamic>> onUserChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _first;
  late final TextEditingController _last;
  late final TextEditingController _email;
  late final TextEditingController _mobile;
  late final TextEditingController _contactName;
  late final TextEditingController _contactNumber;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _first = TextEditingController(text: _string(widget.user['first_name']));
    _last = TextEditingController(text: _string(widget.user['last_name']));
    _email = TextEditingController(text: _string(widget.user['email']));
    _mobile = TextEditingController(text: _string(widget.user['mobile_number']));
    _contactName =
        TextEditingController(text: _string(widget.user['emergency_contact_name']));
    _contactNumber = TextEditingController(
      text: _string(widget.user['emergency_contact_number']),
    );
  }
=======
Future<void> _openApplicationForm(
    BuildContext context, LaravelApi api, VoidCallback onChanged) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => _ApplicationDialog(api: api),
  );
  if (result == true) onChanged();
}

Future<void> _openBookingForm(
    BuildContext context, LaravelApi api, VoidCallback onChanged) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => _BookingDialog(api: api),
  );
  if (result == true) onChanged();
}

Future<void> _openReportForm(
    BuildContext context, LaravelApi api, VoidCallback onChanged) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => _ReportDialog(api: api),
  );
  if (result == true) onChanged();
}

class _ApplicationDialog extends StatefulWidget {
  const _ApplicationDialog({required this.api});

  final LaravelApi api;

  @override
  State<_ApplicationDialog> createState() => _ApplicationDialogState();
}

class _ApplicationDialogState extends State<_ApplicationDialog> {
  final _form = GlobalKey<FormState>();
  final _enterprise = TextEditingController();
  final _owner = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _product = TextEditingController();
  final _focus = TextEditingController();
  final _stage = TextEditingController(text: 'Prototype');
  final _summary = TextEditingController();
  final _innovation = TextEditingController();
  final _market = TextEditingController();
  final _technical = TextEditingController();
  final Set<String> _needs = {'Mentoring'};
  bool _busy = false;
  String? _error;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

  @override
  void dispose() {
    for (final controller in [
<<<<<<< HEAD
      _first,
      _last,
      _email,
      _mobile,
      _contactName,
      _contactNumber,
=======
      _enterprise,
      _owner,
      _phone,
      _email,
      _address,
      _product,
      _focus,
      _stage,
      _summary,
      _innovation,
      _market,
      _technical
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

<<<<<<< HEAD
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final user = await widget.api.updateProfile(
        firstName: _first.text.trim(),
        lastName: _last.text.trim(),
        email: _email.text.trim(),
        mobileNumber: _mobile.text.trim(),
        emergencyContactName: _contactName.text.trim(),
        emergencyContactNumber: _contactNumber.text.trim(),
      );
      widget.onUserChanged(user);
      if (mounted) _showSnack(context, 'Profile updated.', tone: _success);
    } on LaravelApiException catch (e) {
      if (mounted) _showSnack(context, e.message, tone: _danger);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ScreenScroll(
      header: const _PlainHeader(
        title: 'Profile',
        subtitle: 'Customer identity and contact details.',
      ),
      children: [
        _Panel(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TwoColumnFields(
                  children: [
                    _LabeledField(
                      label: 'First name',
                      controller: _first,
                      validator: _required,
                    ),
                    _LabeledField(
                      label: 'Last name',
                      controller: _last,
                      validator: _required,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TwoColumnFields(
                  children: [
                    _LabeledField(
                      label: 'Email',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: _required,
                    ),
                    _LabeledField(
                      label: 'Mobile number',
                      controller: _mobile,
                      keyboardType: TextInputType.phone,
                      validator: _required,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TwoColumnFields(
                  children: [
                    _LabeledField(
                      label: 'Emergency contact',
                      controller: _contactName,
                    ),
                    _LabeledField(
                      label: 'Contact number',
                      controller: _contactNumber,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _busy ? null : _save,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save profile'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BookingDialog extends StatefulWidget {
  const BookingDialog({
    super.key,
    required this.api,
    required this.catalog,
    this.booking,
  });

  final LaravelApi api;
  final Map<String, dynamic> catalog;
  final Map<String, dynamic>? booking;

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _date = TextEditingController();
  final _special = TextEditingController();
  final Map<int, int> _equipment = {};
  int? _locationId;
  int? _courtId;
  String _startTime = '08:00';
  String _endTime = '09:00';
  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.booking != null;

  List<Map<String, dynamic>> get _locations => _asList(widget.catalog['locations']);
  List<Map<String, dynamic>> get _courts => _asList(widget.catalog['courts']);
  List<Map<String, dynamic>> get _equipmentRows =>
      _asList(widget.catalog['equipment']);

  @override
  void initState() {
    super.initState();
    final booking = widget.booking;
    _locationId = _asNullableInt(booking?['location_id']) ??
        (_locations.isNotEmpty ? _asInt(_locations.first['id']) : null);
    _courtId = _asNullableInt(booking?['court_id']) ??
        _firstCourtForLocation(_locationId);
    _date.text = _string(booking?['reservation_date']).isNotEmpty
        ? _string(booking?['reservation_date'])
        : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));
    _startTime = _string(booking?['start_time']).isNotEmpty
        ? _string(booking?['start_time'])
        : '08:00';
    _endTime = _string(booking?['end_time']).isNotEmpty
        ? _string(booking?['end_time'])
        : '09:00';
    _special.text = _string(booking?['special_requests']);
  }

  @override
  void dispose() {
    _date.dispose();
    _special.dispose();
    super.dispose();
  }

  int? _firstCourtForLocation(int? locationId) {
    final rows = _courts
        .where((court) => _asInt(court['location_id']) == locationId)
        .toList();
    return rows.isNotEmpty ? _asInt(rows.first['id']) : null;
  }

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_date.text) ??
        DateTime.now().add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      _date.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
=======
  Future<void> _submit() async {
    if (!_form.currentState!.validate() || _needs.isEmpty) return;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    setState(() {
      _busy = true;
      _error = null;
    });
<<<<<<< HEAD

    final payload = {
      'location_id': _locationId,
      'court_id': _courtId,
      'reservation_date': _date.text,
      'start_time': _startTime,
      'end_time': _endTime,
      'special_requests': _special.text.trim(),
      if (!_isEdit)
        'equipment': _equipment.entries
            .where((entry) => entry.value > 0)
            .map((entry) => {
                  'equipment_type_id': entry.key,
                  'quantity': entry.value,
                })
            .toList(),
    };

    try {
      if (_isEdit) {
        await widget.api.updateBooking(_asInt(widget.booking!['id']), payload);
      } else {
        await widget.api.createBooking(payload);
      }
=======
    try {
      await widget.api.createApplication({
        'enterprise_name': _enterprise.text.trim(),
        'owner_name': _owner.text.trim(),
        'phone_number': _phone.text.trim(),
        'email_address': _email.text.trim(),
        'business_address': _address.text.trim(),
        'product_name': _product.text.trim(),
        'primary_focus_area': _focus.text.trim(),
        'current_stage': _stage.text.trim(),
        'project_summary': _summary.text.trim(),
        'innovativeness': _innovation.text.trim(),
        'market_potential': _market.text.trim(),
        'technical_feasibility': _technical.text.trim(),
        'support_needs': _needs.toList(),
      });
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
      if (mounted) Navigator.pop(context, true);
    } on LaravelApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final courts = _courts
        .where((court) => _asInt(court['location_id']) == _locationId)
        .toList();
    final equipment = _equipmentRows
        .where((item) => _asInt(item['location_id']) == _locationId)
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DialogHeader(
                  title: _isEdit ? 'Edit booking' : 'Book court',
                  icon: _isEdit ? Icons.edit_calendar : Icons.add,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  _Notice(text: _error!, tone: _danger),
                ],
                const SizedBox(height: 16),
                _TwoColumnFields(
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _locationId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Location'),
                      items: _locations
                          .map(
                            (location) => DropdownMenuItem<int>(
                              value: _asInt(location['id']),
                              child: Text(
                                _string(location['name']),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      validator: (value) => value == null ? 'Required' : null,
                      onChanged: (value) {
                        setState(() {
                          _locationId = value;
                          _courtId = _firstCourtForLocation(value);
                          _equipment.clear();
                        });
                      },
                    ),
                    DropdownButtonFormField<int>(
                      initialValue: courts.any((court) => _asInt(court['id']) == _courtId)
                          ? _courtId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Court'),
                      items: courts
                          .map(
                            (court) => DropdownMenuItem<int>(
                              value: _asInt(court['id']),
                              child: Text(
                                '${_string(court['court_name'])} - ${_money(court['base_rate'])}/hr',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      validator: (value) => value == null ? 'Required' : null,
                      onChanged: (value) => setState(() => _courtId = value),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TwoColumnFields(
                  children: [
                    TextFormField(
                      controller: _date,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        suffixIcon: IconButton(
                          tooltip: 'Pick date',
                          icon: const Icon(Icons.calendar_month),
                          onPressed: _pickDate,
                        ),
                      ),
                      validator: _required,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _startTime,
                            isExpanded: true,
                            decoration:
                                const InputDecoration(labelText: 'Start'),
                            items: _timeOptions()
                                .map((time) => DropdownMenuItem(
                                      value: time,
                                      child: Text(time),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _startTime = value ?? _startTime),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _endTime,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'End'),
                            items: _timeOptions()
                                .map((time) => DropdownMenuItem(
                                      value: time,
                                      child: Text(time),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _endTime = value ?? _endTime),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Special requests',
                  controller: _special,
                  maxLines: 3,
                ),
                if (!_isEdit && equipment.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Equipment',
                    style: TextStyle(fontWeight: FontWeight.w800, color: _ink),
                  ),
                  const SizedBox(height: 8),
                  ...equipment.map(
                    (item) => _EquipmentStepper(
                      item: item,
                      value: _equipment[_asInt(item['equipment_type_id'])] ?? 0,
                      onChanged: (value) => setState(
                        () => _equipment[_asInt(item['equipment_type_id'])] = value,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _busy ? null : () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _busy ? null : _save,
                      icon: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isEdit ? 'Save changes' : 'Create booking'),
                    ),
                  ],
                ),
              ],
            ),
          ),
=======
    return _FormDialog(
      title: 'Submit Application',
      busy: _busy,
      error: _error,
      onSubmit: _submit,
      child: Form(
        key: _form,
        child: Column(
          children: [
            _Field(
                controller: _enterprise,
                label: 'Enterprise name',
                icon: Icons.storefront_outlined),
            _Field(
                controller: _owner,
                label: 'Owner name',
                icon: Icons.person_outline),
            _Field(
                controller: _phone,
                label: 'Phone number',
                icon: Icons.phone_outlined),
            _Field(
                controller: _email,
                label: 'Email address',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress),
            _Field(
                controller: _address,
                label: 'Business address',
                icon: Icons.location_on_outlined),
            _Field(
                controller: _product,
                label: 'Product name',
                icon: Icons.inventory_2_outlined),
            _Field(
                controller: _focus,
                label: 'Focus area',
                icon: Icons.eco_outlined),
            _Field(
                controller: _stage,
                label: 'Current stage',
                icon: Icons.flag_outlined),
            _Field(
                controller: _summary,
                label: 'Project summary',
                icon: Icons.notes_outlined,
                maxLines: 3),
            _Field(
                controller: _innovation,
                label: 'Innovativeness',
                icon: Icons.lightbulb_outline,
                maxLines: 3),
            _Field(
                controller: _market,
                label: 'Market potential',
                icon: Icons.trending_up,
                maxLines: 2,
                required: false),
            _Field(
                controller: _technical,
                label: 'Technical feasibility',
                icon: Icons.build_outlined,
                maxLines: 2,
                required: false),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  'Mentoring',
                  'Facility access',
                  'Product testing',
                  'Market linkage',
                  'Training'
                ]
                    .map((need) => FilterChip(
                          label: Text(need),
                          selected: _needs.contains(need),
                          onSelected: (selected) => setState(() => selected
                              ? _needs.add(need)
                              : _needs.remove(need)),
                        ))
                    .toList(),
              ),
            ),
          ].expand((widget) sync* {
            yield widget;
            yield const SizedBox(height: 12);
          }).toList(),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class PayGcashDialog extends StatefulWidget {
  const PayGcashDialog({super.key, required this.api, required this.booking});

  final LaravelApi api;
  final Map<String, dynamic> booking;

  @override
  State<PayGcashDialog> createState() => _PayGcashDialogState();
}

class _PayGcashDialogState extends State<PayGcashDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reference = TextEditingController();
  final _sender = TextEditingController();
=======
class _BookingDialog extends StatefulWidget {
  const _BookingDialog({required this.api});

  final LaravelApi api;

  @override
  State<_BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<_BookingDialog> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _purpose = TextEditingController();
  DateTime _start = DateTime.now().add(const Duration(days: 1));
  DateTime _end = DateTime.now().add(const Duration(days: 1, hours: 2));
  int? _equipmentId;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
<<<<<<< HEAD
    _reference.dispose();
    _sender.dispose();
=======
    _title.dispose();
    _purpose.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool start) async {
    final base = start ? _start : _end;
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: base,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(base));
    if (time == null) return;
    setState(() {
      final picked =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (start) {
        _start = picked;
        if (!_end.isAfter(_start)) _end = _start.add(const Duration(hours: 2));
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.api.createBooking({
        'equipment_id': _equipmentId,
        'title': _title.text.trim(),
        'purpose': _purpose.text.trim(),
        'start_at': _start.toIso8601String(),
        'end_at': _end.toIso8601String(),
      });
      if (mounted) Navigator.pop(context, true);
    } on LaravelApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormDialog(
      title: 'Book Facility',
      busy: _busy,
      error: _error,
      onSubmit: _submit,
      child: Form(
        key: _form,
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: widget.api.equipment(),
              builder: (context, snapshot) {
                final rows = snapshot.data ?? <Map<String, dynamic>>[];
                return DropdownButtonFormField<int?>(
                  initialValue: _equipmentId,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.precision_manufacturing_outlined),
                      labelText: 'Equipment'),
                  items: [
                    const DropdownMenuItem<int?>(
                        value: null, child: Text('No specific equipment')),
                    ...rows.map((row) => DropdownMenuItem<int?>(
                          value: row['id'] as int?,
                          child: Text(row['name']?.toString() ?? 'Equipment'),
                        )),
                  ],
                  onChanged: (value) => setState(() => _equipmentId = value),
                );
              },
            ),
            const SizedBox(height: 12),
            _Field(
                controller: _title, label: 'Booking title', icon: Icons.title),
            const SizedBox(height: 12),
            _Field(
                controller: _purpose,
                label: 'Purpose',
                icon: Icons.notes_outlined,
                required: false),
            const SizedBox(height: 12),
            _DateTimeTile(
                label: 'Start',
                value: _start,
                onTap: () => _pickDateTime(true)),
            const SizedBox(height: 12),
            _DateTimeTile(
                label: 'End', value: _end, onTap: () => _pickDateTime(false)),
          ],
        ),
      ),
    );
  }
}

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({required this.api});

  final LaravelApi api;

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final _form = GlobalKey<FormState>();
  final _year = TextEditingController(text: DateTime.now().year.toString());
  final _revenue = TextEditingController();
  final _jobs = TextEditingController();
  final _products = TextEditingController();
  final _trainings = TextEditingController();
  final _customers = TextEditingController();
  final _notes = TextEditingController();
  int _quarter = ((DateTime.now().month - 1) ~/ 3) + 1;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _year,
      _revenue,
      _jobs,
      _products,
      _trainings,
      _customers,
      _notes
    ]) {
      controller.dispose();
    }
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    super.dispose();
  }

  Future<void> _submit() async {
<<<<<<< HEAD
    if (!_formKey.currentState!.validate()) return;
=======
    if (!_form.currentState!.validate()) return;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
<<<<<<< HEAD
      await widget.api.payGcash(
        reservationId: _asInt(widget.booking['id']),
        referenceNumber: _reference.text.trim(),
        senderNumber: _sender.text.trim(),
      );
=======
      await widget.api.createReport({
        'quarter': _quarter,
        'year': int.parse(_year.text),
        'kpi_revenue': double.tryParse(_revenue.text) ?? 0,
        'kpi_jobs_created': int.tryParse(_jobs.text) ?? 0,
        'kpi_products_developed': int.tryParse(_products.text) ?? 0,
        'kpi_trainings_attended': int.tryParse(_trainings.text) ?? 0,
        'kpi_customers': int.tryParse(_customers.text) ?? 0,
        'notes': _notes.text.trim(),
      });
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
      if (mounted) Navigator.pop(context, true);
    } on LaravelApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final amount = _string(widget.booking['grand_total_label']);
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _DialogHeader(title: 'Pay GCash', icon: Icons.payments),
                const SizedBox(height: 12),
                _SoftInfoRow(
                  icon: Icons.confirmation_number,
                  title: _string(widget.booking['reservation_code']),
                  subtitle: '${_string(widget.booking['schedule'])} | $amount',
                ),
                const SizedBox(height: 10),
                _SoftInfoRow(
                  icon: Icons.phone_android,
                  title: 'Send to ${_string(widget.booking['owner_gcash_number']).isEmpty ? '09123456789' : _string(widget.booking['owner_gcash_number'])}',
                  subtitle: 'Amount: $amount',
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  _Notice(text: _error!, tone: _danger),
                ],
                const SizedBox(height: 14),
                _LabeledField(
                  label: 'GCash reference number',
                  controller: _reference,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Sender mobile number',
                  controller: _sender,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _busy ? null : () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _busy ? null : _submit,
                      icon: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.upload_file),
                      label: const Text('Submit proof'),
                    ),
                  ],
                ),
              ],
            ),
          ),
=======
    return _FormDialog(
      title: 'Submit Progress Report',
      busy: _busy,
      error: _error,
      onSubmit: _submit,
      child: Form(
        key: _form,
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              initialValue: _quarter,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_view_month_outlined),
                  labelText: 'Quarter'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Q1')),
                DropdownMenuItem(value: 2, child: Text('Q2')),
                DropdownMenuItem(value: 3, child: Text('Q3')),
                DropdownMenuItem(value: 4, child: Text('Q4')),
              ],
              onChanged: (value) =>
                  setState(() => _quarter = value ?? _quarter),
            ),
            const SizedBox(height: 12),
            _Field(
                controller: _year,
                label: 'Year',
                icon: Icons.date_range,
                keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            _Field(
                controller: _revenue,
                label: 'Revenue',
                icon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                required: false),
            const SizedBox(height: 12),
            _Field(
                controller: _jobs,
                label: 'Jobs created',
                icon: Icons.group_add_outlined,
                keyboardType: TextInputType.number,
                required: false),
            const SizedBox(height: 12),
            _Field(
                controller: _products,
                label: 'Products developed',
                icon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
                required: false),
            const SizedBox(height: 12),
            _Field(
                controller: _trainings,
                label: 'Trainings attended',
                icon: Icons.school_outlined,
                keyboardType: TextInputType.number,
                required: false),
            const SizedBox(height: 12),
            _Field(
                controller: _customers,
                label: 'Customers reached',
                icon: Icons.people_outline,
                keyboardType: TextInputType.number,
                required: false),
            const SizedBox(height: 12),
            _Field(
                controller: _notes,
                label: 'Notes',
                icon: Icons.notes_outlined,
                maxLines: 3,
                required: false),
          ],
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class ReceiptDialog extends StatelessWidget {
  const ReceiptDialog({super.key, required this.receipt});

  final Map<String, dynamic> receipt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _DialogHeader(title: 'Receipt', icon: Icons.receipt_long),
              const SizedBox(height: 16),
              _ReceiptLine('Payment', _string(receipt['payment_reference'])),
              _ReceiptLine('Booking', _string(receipt['reservation_code'])),
              _ReceiptLine('Court', _string(receipt['court'])),
              _ReceiptLine('Schedule', _string(receipt['schedule'])),
              _ReceiptLine('Method', _string(receipt['payment_method']).toUpperCase()),
              _ReceiptLine('GCash ref', _string(receipt['gcash_reference_number'])),
              const Divider(height: 26),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Amount',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    _string(receipt['amount_label']),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: _primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StatusPill(label: _string(receipt['status_label'])),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onEdit,
    this.onPay,
    this.onCancel,
  });

  final Map<String, dynamic> booking;
  final VoidCallback? onEdit;
  final VoidCallback? onPay;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return _Panel(
=======
class _FormDialog extends StatelessWidget {
  const _FormDialog({
    required this.title,
    required this.child,
    required this.busy,
    required this.error,
    required this.onSubmit,
  });

  final String title;
  final Widget child;
  final bool busy;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800))),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    child,
                    if (error != null) _Message(text: error!, color: _danger),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: busy ? null : () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: busy ? null : onSubmit,
                    icon: busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.items,
    required this.selected,
    required this.user,
    required this.onSelected,
    required this.onLogout,
  });

  final List<_NavItem> items;
  final int selected;
  final Map<String, dynamic> user;
  final ValueChanged<int> onSelected;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: _primaryDark,
      padding: const EdgeInsets.all(18),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
<<<<<<< HEAD
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _statusColor(_string(booking['status']))
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.sports_tennis,
                  color: _statusColor(_string(booking['status'])),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _string(booking['reservation_code']),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_string(booking['location_name'])} - ${_string(booking['court_name'])}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _string(booking['schedule']),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusPill(label: _string(booking['status_label'])),
            ],
          ),
          const SizedBox(height: 14),
          _ResponsiveCards(
            minWidth: 140,
            gap: 8,
            children: [
              _MiniStat(label: 'Total', value: _string(booking['grand_total_label'])),
              _MiniStat(
                label: 'Payment',
                value: _string(booking['payment_status']).replaceAll('_', ' '),
              ),
              _MiniStat(
                label: 'Equipment',
                value: '${_asList(booking['equipment']).length} item(s)',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (onPay != null)
                ElevatedButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.payments),
                  label: const Text('Pay GCash'),
                ),
              if (onEdit != null)
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              if (onCancel != null)
                OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.event_busy),
                  label: const Text('Cancel'),
                ),
            ],
=======
            children: [
              _Logo(size: 44),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DSSC',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            letterSpacing: 3)),
                    Text('Agri-Food Innovation',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final active = index == selected;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => onSelected(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? _bg : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon,
                          color: active ? _primaryDark : Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                              color: active ? _text : Colors.white,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          Text(user['name']?.toString() ?? 'Incubatee',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          Text(user['email']?.toString() ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24)),
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt, required this.onOpen});

  final Map<String, dynamic> receipt;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long, color: _primaryDark),
          ),
          const SizedBox(width: 12),
=======
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.user,
    required this.showMenu,
    required this.onLogout,
  });

  final String title;
  final Map<String, dynamic> user;
  final bool showMenu;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _border))),
      child: Row(
        children: [
          if (showMenu) ...[_Logo(size: 36), const SizedBox(width: 10)],
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  _string(receipt['payment_reference']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  _string(receipt['court']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _string(receipt['amount_label']),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          IconButton(
            tooltip: 'Open receipt',
            onPressed: onOpen,
            icon: const Icon(Icons.open_in_new),
          ),
=======
                Text(title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _text)),
                Text('Connected to $kLaravelBaseUrl',
                    style: const TextStyle(fontSize: 12, color: _muted),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (showMenu)
            IconButton(
              tooltip: 'Logout',
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
            )
          else
            Text(user['name']?.toString() ?? '',
                style: const TextStyle(fontWeight: FontWeight.w700)),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.booking, required this.onPay});

  final Map<String, dynamic> booking;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.wallet, color: _warning),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _string(booking['reservation_code']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${_string(booking['schedule'])} | ${_string(booking['grand_total_label'])}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onPay,
            icon: const Icon(Icons.payments),
            label: const Text('Pay'),
          ),
        ],
      ),
    );
  }
}

class _CompactBookingRow extends StatelessWidget {
  const _CompactBookingRow({required this.booking});

  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.event, color: _primaryDark, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _string(booking['reservation_code']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  _string(booking['schedule']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          _StatusPill(label: _string(booking['status_label'])),
        ],
      ),
    );
  }
}

class _HeroStrip extends StatelessWidget {
  const _HeroStrip({required this.api});

  final LaravelApi api;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Image.network(
              api.publicAsset('/images/671478450_122128991829155269_859094970721700938_n.jpg'),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _primaryDark,
                child: const Icon(Icons.sports_tennis,
                    color: Colors.white, size: 64),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Colors.black.withValues(alpha: 0.28)),
            ),
          ),
          const Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Text(
              'Book one of four outdoor courts and send GCash details for admin verification.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenScroll extends StatelessWidget {
  const _ScreenScroll({this.header, required this.children});

  final Widget? header;
  final List<Widget> children;
=======
class _PageScroll extends StatelessWidget {
  const _PageScroll({required this.children, this.action});

  final List<Widget> children;
  final Widget? action;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
<<<<<<< HEAD
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) ...[header!, const SizedBox(height: 16)],
              ...children,
            ],
          ),
=======
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (action != null)
              Align(alignment: Alignment.centerRight, child: action!),
            if (action != null) const SizedBox(height: 14),
            ...children.expand((child) sync* {
              yield child;
              yield const SizedBox(height: 16);
            }),
          ],
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class _ActionHeader extends StatelessWidget {
  const _ActionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.icon,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        _PlainHeader(title: title, subtitle: subtitle),
        ElevatedButton.icon(
          onPressed: onAction,
          icon: Icon(icon),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}

class _PlainHeader extends StatelessWidget {
  const _PlainHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({this.title, this.trailing, required this.child});

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
=======
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.incubatee, required this.deadline});

  final Map<String, dynamic> incubatee;
  final String? deadline;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Logo(size: 58, url: incubatee['logo_url']?.toString()),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(incubatee['business_name']?.toString() ?? 'Your Business',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                    incubatee['business_address']?.toString() ??
                        'Complete your profile through your application.',
                    style: const TextStyle(color: _muted)),
              ],
            ),
          ),
          _StatusPill(
            text: deadline == null ? 'Reports updated' : '$deadline due',
            color: deadline == null ? _success : _warning,
          ),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _ResponsiveCards extends StatelessWidget {
  const _ResponsiveCards({
    required this.children,
    this.minWidth = 180,
    this.gap = 12,
  });

  final List<Widget> children;
  final double minWidth;
  final double gap;
=======
class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({required this.children, required this.minWidth});

  final List<Widget> children;
  final double minWidth;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
<<<<<<< HEAD
        final columns =
            (constraints.maxWidth / minWidth).floor().clamp(1, children.length);
        final width = (constraints.maxWidth - (gap * (columns - 1))) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: width.toDouble(), child: child))
              .toList(),
=======
        final count =
            (constraints.maxWidth / minWidth).floor().clamp(1, 4).toInt();
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: count == 1 ? 3.2 : 1.75,
          children: children,
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        );
      },
    );
  }
}

<<<<<<< HEAD
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _primaryDark),
          ),
=======
class _SectionGrid extends StatelessWidget {
  const _SectionGrid({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(children: [left, const SizedBox(height: 16), right]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ]);
      },
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface(
      {required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F0F172A), blurRadius: 18, offset: Offset(0, 8))
        ],
      ),
      child: child,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label,
      required this.value,
      required this.caption,
      required this.icon,
      required this.color});

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label.toUpperCase(),
                    style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _text)),
                Text(caption,
                    style: const TextStyle(color: _muted, fontSize: 12)),
              ],
            ),
          ),
          _IconBadge(icon: icon, color: color),
        ],
      ),
    );
  }
}

class _ListPreview extends StatelessWidget {
  const _ListPreview({
    required this.title,
    required this.rows,
    required this.empty,
    required this.titleOf,
    required this.subtitleOf,
    required this.statusOf,
  });

  final String title;
  final List<Map<String, dynamic>> rows;
  final String empty;
  final String Function(Map<String, dynamic>) titleOf;
  final String Function(Map<String, dynamic>) subtitleOf;
  final String? Function(Map<String, dynamic>) statusOf;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: title),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            _EmptyState(icon: Icons.inbox_outlined, text: empty)
          else
            ...rows.map((row) => _DataTile(
                  icon: Icons.chevron_right,
                  title: titleOf(row),
                  subtitle: subtitleOf(row),
                  status: statusOf(row),
                )),
        ],
      ),
    );
  }
}

class _DataTile extends StatelessWidget {
  const _DataTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.meta,
      this.status});

  final IconData icon;
  final String title;
  final String subtitle;
  final String? meta;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon, color: _primary, small: true),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
=======
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(color: _muted, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                if (meta != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(meta!,
                          style: const TextStyle(color: _muted, fontSize: 11))),
              ],
            ),
          ),
          if (status != null)
            _StatusPill(text: status!, color: _statusColor(status!)),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _ink, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text('$value%'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value.clamp(0, 100) / 100,
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
            color: _primary,
            backgroundColor: _primary.withValues(alpha: 0.12),
          ),
        ],
      ),
    );
  }
}

class _EquipmentStepper extends StatelessWidget {
  const _EquipmentStepper({
    required this.item,
    required this.value,
    required this.onChanged,
  });

  final Map<String, dynamic> item;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final max = _asInt(item['max']);
    final available = _asInt(item['available']);
    final limit = max < available ? max : available;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _string(item['name']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${_money(item['price'])} each | $available available',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Decrease',
            onPressed: value <= 0 ? null : () => onChanged(value - 1),
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          IconButton(
            tooltip: 'Increase',
            onPressed: value >= limit ? null : () => onChanged(value + 1),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}

class _TwoColumnFields extends StatelessWidget {
  const _TwoColumnFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 580 || children.length < 2) {
          return Column(
            children: children
                .map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: child,
                    ))
                .toList(),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 12),
            Expanded(child: children[1]),
          ],
        );
      },
=======
class _KpiBars extends StatelessWidget {
  const _KpiBars({required this.metrics});

  final List<Map<String, dynamic>> metrics;

  @override
  Widget build(BuildContext context) {
    final maxValue = metrics
        .expand<num>((row) => [
              _num(row['jobs_created']),
              _num(row['products_developed']),
              _num(row['customers']),
            ])
        .fold<num>(1, (max, value) => value > max ? value : max);

    return Column(
      children: metrics.take(6).map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(row['label']?.toString() ?? 'Quarter',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              _MetricLine(
                  label: 'Jobs',
                  value: _num(row['jobs_created']),
                  max: maxValue,
                  color: _success),
              _MetricLine(
                  label: 'Products',
                  value: _num(row['products_developed']),
                  max: maxValue,
                  color: _warning),
              _MetricLine(
                  label: 'Customers',
                  value: _num(row['customers']),
                  max: maxValue,
                  color: _primary),
            ],
          ),
        );
      }).toList(),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
    );
  }
}

<<<<<<< HEAD
class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? _primary.withValues(alpha: 0.12) : Colors.white,
        side: BorderSide(color: selected ? _primary : _line),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _primaryDark),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(label.toLowerCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.isEmpty ? 'Status' : label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.tone});

  final String text;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tone.withValues(alpha: 0.24)),
      ),
      child: Text(
        text,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: tone, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SoftInfoRow extends StatelessWidget {
  const _SoftInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Icon(icon, color: _primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptLine extends StatelessWidget {
  const _ReceiptLine(this.label, this.value);

  final String label;
  final String value;
=======
class _MetricLine extends StatelessWidget {
  const _MetricLine(
      {required this.label,
      required this.value,
      required this.max,
      required this.color});

  final String label;
  final num value;
  final num max;
  final Color color;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

  @override
  Widget build(BuildContext context) {
    return Padding(
<<<<<<< HEAD
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(label, style: const TextStyle(color: _muted)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
=======
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
              width: 72,
              child: Text(label,
                  style: const TextStyle(fontSize: 12, color: _muted))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (value / max).clamp(0, 1).toDouble(),
                minHeight: 8,
                backgroundColor: const Color(0xFFEFF6FF),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          SizedBox(
              width: 42,
              child: Text('$value',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700))),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, color: _muted, size: 42),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
        ],
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading Pickle Ballan ni Juan'),
          ],
        ),
      ),
    );
  }
}

class _FutureBody<T> extends StatelessWidget {
  const _FutureBody({required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
=======
class _FuturePane<T> extends StatelessWidget {
  const _FuturePane({required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(T data) builder;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
<<<<<<< HEAD
          return _ScreenScroll(
            children: [
              _Panel(
                child: _EmptyState(text: snapshot.error.toString()),
=======
          return _PageScroll(
            children: [
              _Surface(
                child: _EmptyState(
                  icon: Icons.cloud_off_outlined,
                  text: snapshot.error.toString(),
                ),
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
              ),
            ],
          );
        }
<<<<<<< HEAD
        return builder(context, snapshot.data as T);
=======
        return builder(snapshot.data as T);
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
      },
    );
  }
}

<<<<<<< HEAD
String? _required(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}

List<Map<String, dynamic>> _asList(Object? value) {
=======
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.required = true,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      keyboardType: keyboardType,
      validator: required
          ? (value) => value == null || value.trim().isEmpty
              ? '$label is required.'
              : null
          : null,
      decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile(
      {required this.label, required this.value, required this.onTap});

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.schedule), labelText: label),
        child: Text(DateFormat('MMM d, yyyy h:mm a').format(value)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800))),
        if (action != null) _StatusPill(text: action!, color: _primary),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            minimumSize: const Size.fromHeight(46)),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge(
      {required this.icon, required this.color, this.small = false});

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 36.0 : 46.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: color, size: small ? 19 : 24),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w800),
          overflow: TextOverflow.ellipsis),
    );
  }
}

class _SoftPill extends StatelessWidget {
  const _SoftPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFCBD5E1), size: 42),
            const SizedBox(height: 8),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted)),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8)),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.size, this.url});

  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
        child: Image.network(
          url ?? '$kLaravelBaseUrl/logo/dssc_logo_circle.png',
          headers: const {'ngrok-skip-browser-warning': 'true'},
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.eco, color: _primary, size: size * 0.55),
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;

  String get shortLabel {
    if (label == 'My Application') return 'Application';
    if (label == 'My Bookings') return 'Bookings';
    if (label == 'Progress & KPIs') return 'KPIs';
    if (label == 'MOA Status') return 'MOA';
    return label;
  }
}

List<Map<String, dynamic>> _asList(dynamic value) {
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
  if (value is List) {
    return value
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
  return <Map<String, dynamic>>[];
}

<<<<<<< HEAD
String _string(Object? value) => value?.toString() ?? '';

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _asNullableInt(Object? value) {
  if (value == null) return null;
  final parsed = _asInt(value);
  return parsed == 0 ? null : parsed;
}

bool _asBool(Object? value) {
  if (value is bool) return value;
  return value?.toString() == 'true' || value?.toString() == '1';
}

bool _needsPayment(Map<String, dynamic> booking) {
  return _string(booking['payment_status']) == 'unpaid' &&
      _string(booking['status']) == 'pending_payment';
}

String _money(Object? value) {
  if (value == null) return 'PHP 0.00';
  final number = value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
  return 'PHP ${NumberFormat('#,##0.00').format(number)}';
}

List<String> _timeOptions() {
  final rows = <String>[];
  for (var hour = 6; hour <= 23; hour++) {
    for (final minute in [0, 30]) {
      if (hour == 23 && minute == 30) continue;
      rows.add('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
    }
  }
  return rows;
}

IconData _metricIcon(String name) {
  return switch (name) {
    'wallet' => Icons.account_balance_wallet,
    'star' => Icons.star,
    'receipt' => Icons.receipt_long,
    _ => Icons.calendar_month,
  };
}

Color _statusColor(String status) {
  final clean = status.toLowerCase();
  if (clean.contains('verified') ||
      clean.contains('paid') ||
      clean.contains('confirmed') ||
      clean.contains('completed')) {
    return _success;
  }
  if (clean.contains('pending') || clean.contains('verification')) {
    return _warning;
  }
  if (clean.contains('cancel') || clean.contains('reject')) {
    return _danger;
  }
  return _primaryDark;
}

void _showSnack(BuildContext context, String message, {Color tone = _primary}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: tone,
      behavior: SnackBarBehavior.floating,
    ),
  );
=======
String _formatDate(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) return 'No date';
  return DateFormat('MMM d, yyyy h:mm a').format(parsed.toLocal());
}

Color _statusColor(String status) {
  final lower = status.toLowerCase();
  if (lower.contains('approved') ||
      lower.contains('accepted') ||
      lower.contains('active')) {
    return _success;
  }
  if (lower.contains('rejected') || lower.contains('denied')) {
    return _danger;
  }
  return _warning;
}

num _num(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../services/laravel_api.dart';

const _primary = Color(0xFF17C1E8);
const _primaryDark = Color(0xFF0F3047);
const _success = Color(0xFF21A67A);
const _warning = Color(0xFFF59E0B);
const _danger = Color(0xFFDC2626);
const _ink = Color(0xFF172033);
const _muted = Color(0xFF667085);
const _line = Color(0xFFE4E7EC);
const _surface = Color(0xFFF7F8FB);

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
      title: 'Pickle Ballan ni Juan',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          primary: _primary,
          secondary: _success,
        ),
        scaffoldBackgroundColor: _surface,
        fontFamily: 'Arial',
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
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
            onUserChanged: (user) => setState(() => _user = user),
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
  const AuthScreen({
    super.key,
    required this.api,
    required this.onAuthenticated,
  });

  final LaravelApi api;
  final ValueChanged<Map<String, dynamic>> onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController(text: 'user@example.com');
  final _mobile = TextEditingController();
  final _password = TextEditingController(text: 'password');
  final _confirm = TextEditingController(text: 'password');
  bool _register = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _firstName,
      _lastName,
      _email,
      _mobile,
      _password,
      _confirm,
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

    try {
      final user = _register
          ? await widget.api.register(
              firstName: _firstName.text.trim(),
              lastName: _lastName.text.trim(),
              email: _email.text.trim(),
              mobileNumber: _mobile.text.trim(),
              password: _password.text,
              passwordConfirmation: _confirm.text,
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
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
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
    required this.onModeChanged,
    required this.onSubmit,
  });

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
  final ValueChanged<bool> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onPressed: busy ? null : onSubmit,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(register ? Icons.person_add_alt_1 : Icons.login),
              label: Text(register ? 'Create account' : 'Login'),
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
    required this.onUserChanged,
    required this.onLogout,
  });

  final LaravelApi api;
  final Map<String, dynamic> user;
  final ValueChanged<Map<String, dynamic>> onUserChanged;
  final Future<void> Function() onLogout;

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  int _index = 0;
  int _refresh = 0;
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
        );
      },
    );
  }
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
  }
}

class DashboardPage extends StatelessWidget {
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
            ),
          ],
        );
      },
    );
  }
}

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
          ),
        ],
      ),
    );

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
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

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
    );
  }
}

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

  @override
  void dispose() {
    for (final controller in [
      _first,
      _last,
      _email,
      _mobile,
      _contactName,
      _contactNumber,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

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
    setState(() {
      _busy = true;
      _error = null;
    });

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
      if (mounted) Navigator.pop(context, true);
    } on LaravelApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}

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
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _reference.dispose();
    _sender.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.api.payGcash(
        reservationId: _asInt(widget.booking['id']),
        referenceNumber: _reference.text.trim(),
        senderNumber: _sender.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } on LaravelApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
        ],
      ),
    );
  }
}

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
        ),
      ),
    );
  }
}

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
        ],
      ),
    );
  }
}

class _ResponsiveCards extends StatelessWidget {
  const _ResponsiveCards({
    required this.children,
    this.minWidth = 180,
    this.gap = 12,
  });

  final List<Widget> children;
  final double minWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            (constraints.maxWidth / minWidth).floor().clamp(1, children.length);
        final width = (constraints.maxWidth - (gap * (columns - 1))) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: width.toDouble(), child: child))
              .toList(),
        );
      },
    );
  }
}

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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ],
      ),
    );
  }
}

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
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ScreenScroll(
            children: [
              _Panel(
                child: _EmptyState(text: snapshot.error.toString()),
              ),
            ],
          );
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}

String? _required(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}

List<Map<String, dynamic>> _asList(Object? value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
  return <Map<String, dynamic>>[];
}

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
}

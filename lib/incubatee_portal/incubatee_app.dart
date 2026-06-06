import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../services/laravel_api.dart';

const _primary = Color(0xFF1F6FBF);
const _primaryDark = Color(0xFF163B67);
const _success = Color(0xFF0FB37B);
const _warning = Color(0xFFF59E0B);
const _danger = Color(0xFFDC2626);
const _bg = Color(0xFFF8FAFC);
const _border = Color(0xFFE2E8F0);
const _text = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);

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
      title: 'DSSC Agri-Food TBI',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _primary),
        scaffoldBackgroundColor: _bg,
        fontFamily: 'Arial',
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _border),
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
  const AuthScreen(
      {super.key, required this.api, required this.onAuthenticated});

  final LaravelApi api;
  final ValueChanged<Map<String, dynamic>> onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _register = false;
  bool _busy = false;
  String? _error;

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
              name: _name.text.trim(),
              email: _email.text.trim(),
              password: _password.text,
              passwordConfirmation: _confirm.text,
              phone: _phone.text.trim(),
              businessName: _business.text.trim(),
              businessAddress: _address.text.trim(),
              focusArea: _focus.text.trim(),
              stage: 'Screening',
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
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
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
    required this.onModeChanged,
    required this.onSubmit,
  });

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
  final ValueChanged<bool> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onPressed: busy ? null : onSubmit,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(register ? Icons.person_add_alt : Icons.login),
              label: Text(register ? 'Create account' : 'Sign in'),
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
    required this.onLogout,
  });

  final LaravelApi api;
  final Map<String, dynamic> user;
  final Future<void> Function() onLogout;

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  int _index = 0;
  int _refresh = 0;

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
        );
      },
    );
  }

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
  }
}

class DashboardPage extends StatelessWidget {
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
            ),
          ],
        );
      },
    );
  }
}

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
          ),
        ],
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key, required this.api, required this.onChanged});

  final LaravelApi api;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

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
    );
  }
}

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

  @override
  void dispose() {
    for (final controller in [
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
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate() || _needs.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
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
        ),
      ),
    );
  }
}

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
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
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
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
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
        ),
      ),
    );
  }
}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
        ],
      ),
    );
  }
}

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ],
      ),
    );
  }
}

class _PageScroll extends StatelessWidget {
  const _PageScroll({required this.children, this.action});

  final List<Widget> children;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
        ),
      ),
    );
  }
}

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
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({required this.children, required this.minWidth});

  final List<Widget> children;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
        );
      },
    );
  }
}

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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ],
      ),
    );
  }
}

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
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ],
      ),
    );
  }
}

class _FuturePane<T> extends StatelessWidget {
  const _FuturePane({required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _PageScroll(
            children: [
              _Surface(
                child: _EmptyState(
                  icon: Icons.cloud_off_outlined,
                  text: snapshot.error.toString(),
                ),
              ),
            ],
          );
        }
        return builder(snapshot.data as T);
      },
    );
  }
}

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
  if (value is List) {
    return value
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
  return <Map<String, dynamic>>[];
}

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
}

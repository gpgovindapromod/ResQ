import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../core/localization/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final sqlInjectionPattern = RegExp(r"['\x22;=]|(--)", caseSensitive: false);
    if (sqlInjectionPattern.hasMatch(value)) {
      return 'Invalid characters detected';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AppColors.getPrimary(context);
    final onPrimaryColor = AppColors.getOnPrimary(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.emergency,
                    color: onPrimaryColor,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).translate('resq'),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 26,
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).translate('access_your_emergency_response'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: primaryColor,
                        unselectedLabelColor: secondaryTextColor,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        indicatorColor: primaryColor,
                        indicatorWeight: 3,
                        dividerColor: borderColor,
                        tabs: [
                          Tab(text: AppLocalizations.of(context).translate('login')),
                          Tab(text: AppLocalizations.of(context).translate('sign_up')),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Form(
                        key: _formKey,
                        child: _tabController.index == 0
                            ? _buildLoginForm(primaryTextColor, secondaryTextColor, borderColor, primaryColor, onPrimaryColor)
                            : _buildSignUpForm(primaryTextColor, secondaryTextColor, borderColor, primaryColor, onPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(Color primaryTextColor, Color secondaryTextColor, Color borderColor, Color primaryColor, Color onPrimaryColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).translate('email_or_phone'),
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            validator: _validateInput,
            style: TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              hintText: 'Enter your email or phone',
              filled: true,
              fillColor: AppColors.getSurface(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).translate('password'),
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            obscureText: _obscurePassword,
            validator: _validateInput,
            style: TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              filled: true,
              fillColor: AppColors.getSurface(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: secondaryTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                final emailController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.getSurface(context),
                    title: Text(AppLocalizations.of(context).translate('reset_password'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context).translate('enter_your_registered_email_or'), style: TextStyle(fontSize: 13, color: secondaryTextColor)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: emailController,
                          style: TextStyle(color: primaryTextColor),
                          decoration: InputDecoration(
                            hintText: 'Email or Phone',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            hintStyle: TextStyle(color: secondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context).translate('cancel'), style: TextStyle(color: secondaryTextColor)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).translate('password_reset_instructions_se')),
                              backgroundColor: primaryColor,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: onPrimaryColor,
                        ),
                        child: Text(AppLocalizations.of(context).translate('send_link')),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(AppLocalizations.of(context).translate('forgot_password'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.pushReplacementNamed(context, AppRouter.home);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: onPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).translate('sign_in'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18, color: onPrimaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(Color primaryTextColor, Color secondaryTextColor, Color borderColor, Color primaryColor, Color onPrimaryColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).translate('full_name'),
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              filled: true,
              fillColor: AppColors.getSurface(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).translate('email_address'),
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            style: TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              filled: true,
              fillColor: AppColors.getSurface(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).translate('password'),
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            obscureText: _obscurePassword,
            style: TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              hintText: 'Create a password',
              filled: true,
              fillColor: AppColors.getSurface(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor),
              ),
              hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: secondaryTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.pushReplacementNamed(context, AppRouter.home);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: onPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).translate('sign_up'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18, color: onPrimaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


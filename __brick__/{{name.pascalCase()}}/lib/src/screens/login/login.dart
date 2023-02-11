import 'package:apex_api/apex_api.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app.dart';
import '../../../generated/app_localizations.dart';

import '../../../res/r.dart';
import '../../components/buttons/loading_button.dart';
import 'widgets/otp_field.dart';
import 'widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _otpController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(28),
              child: TooltipVisibility(
                visible: false,
                child: PopupMenuButton<Locale>(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FeatherIcons.globe),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(App.of(context)!.locale.languageCode == 'fa'
                            ? 'پارسی'
                            : 'English')
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    App.of(context)!.setLocale(value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: Locale('en', ''),
                      child: Text('English'),
                    ),
                    const PopupMenuItem(
                      value: Locale('fa', ''),
                      child: Text('پارسی'),
                    ),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // LOGO
                        Hero(
                          tag: 'logo-hero',
                          placeholderBuilder: (_, __, child) =>
                              Opacity(opacity: 0.2, child: child),
                          transitionOnUserGestures: true,
                          flightShuttleBuilder: (flightContext, animation,
                              flightDirection, fromHeroContext, toHeroContext) {
                            final toHero = fromHeroContext.widget;
                            return RotationTransition(
                              turns: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                child: (toHero as Hero).child,
                              ),
                            );
                          },
                          child: Image.asset(
                            R.images.logo,
                            width: 45,
                            height: 45,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // LOGIN BUILDER
                        LoginBuilder(
                          showRetry: true,
                          builder: (context,
                              step,
                              isLoading,
                              onDetectUserStatus,
                              onLogin,
                              onForgotPassword,
                              onVerify,
                              {updateStep}) {
                            if (step == LoginStep.showUpgrade) {
                              return const Text('Upgrade');
                            }
                            return AutofillGroup(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Card(
                                    child: TextFormField(
                                      controller: _usernameController,
                                      readOnly: isLoading ||
                                          step != LoginStep.showUsername,
                                      onFieldSubmitted: (value) {
                                        _submitForm(
                                            step,
                                            onDetectUserStatus,
                                            onLogin,
                                            onVerify,
                                            onForgotPassword);
                                      },
                                      autofillHints: const [
                                        AutofillHints.username,
                                        AutofillHints.telephoneNumber
                                      ],
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      maxLength: 11,
                                      buildCounter: (context,
                                              {required currentLength,
                                              required isFocused,
                                              maxLength}) =>
                                          null,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 16),
                                        hintText: S.of(context).phoneNumber,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(8)),
                                            child: const Text('+98'),
                                          ),
                                        ),
                                        prefixIconConstraints:
                                            const BoxConstraints
                                                .tightForFinite(),
                                      ),
                                    ),
                                  ),
                                  if (step == LoginStep.showPassword ||
                                      step == LoginStep.showOtp) ...[
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Card(
                                      child: PasswordField(
                                        controller: _passwordController,
                                        hintText: S.of(context).password,
                                        onSubmitted: (value) {
                                          _submitForm(
                                              step,
                                              onDetectUserStatus,
                                              onLogin,
                                              onVerify,
                                              onForgotPassword);
                                        },
                                        readOnly: isLoading,
                                        autoFillHints: const [
                                          AutofillHints.password
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (step == LoginStep.showOtp) ...[
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Card(
                                      child: PasswordField(
                                        controller: _confirmPasswordController,
                                        readOnly: isLoading,
                                        hintText: S.of(context).confirmPassword,
                                        autoFillHints: const [
                                          AutofillHints.newPassword
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Card(
                                      child: OtpField(
                                        controller: _otpController,
                                        hintText: S.of(context).otp,
                                        readOnly: isLoading,
                                        resendText: S.of(context).resend,
                                        onSubmitted: (_) {
                                          _submitForm(
                                              step,
                                              onDetectUserStatus,
                                              onLogin,
                                              onVerify,
                                              onForgotPassword);
                                        },
                                        onResend: isLoading
                                            ? null
                                            : () async {
                                                _submitForm(
                                                    LoginStep.showUsername,
                                                    onDetectUserStatus,
                                                    onLogin,
                                                    onVerify,
                                                    onForgotPassword);
                                                return true;
                                              },
                                        resendDuration:
                                            const Duration(seconds: 120),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (step == LoginStep.showPassword)
                                        TextButton(
                                            onPressed: () {
                                              onForgotPassword(
                                                  _usernameController.text,
                                                  countryCode: '98');
                                            },
                                            child:
                                                const Text('Forgot Password'))
                                      else
                                        const SizedBox.shrink(),
                                      MultiChangeNotifierBuilder(
                                        builder: (context) => LoadingButton(
                                          onPressed:
                                              _checkStepValidation(step) != null
                                                  ? null
                                                  : () {
                                                      _submitForm(
                                                          step,
                                                          onDetectUserStatus,
                                                          onLogin,
                                                          onVerify,
                                                          onForgotPassword);
                                                    },
                                          isLoading: isLoading,
                                          text: step == LoginStep.showPassword
                                              ? S.of(context).login
                                              : (step == LoginStep.showOtp
                                                  ? S.of(context).register
                                                  : S
                                                      .of(context)
                                                      .loginOrRegister),
                                          loadingText: S.of(context).loading,
                                        ),
                                        notifiers: [
                                          _usernameController,
                                          _passwordController,
                                          _confirmPasswordController,
                                          _otpController,
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          listener: (step) {
                            // print(step);
                          },
                          showProgress: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _checkStepValidation(LoginStep step, {String errorText = ''}) {
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (step == LoginStep.showUsername) {
      // 09199388405 and 9199388405 are valid
      if ((username.length == 10 && username.startsWith('9')) ||
          (username.length == 11 && username.startsWith('09'))) {
        return null;
      } else {
        errorText += '* ${S.of(context).inputErrorUsername}\r\n';
        return errorText;
      }
    } else if (step == LoginStep.showPassword) {
      if (_checkStepValidation(LoginStep.showUsername, errorText: errorText) ==
              null &&
          password.length >= 8 &&
          password.length <= 32) {
        return null;
      } else {
        errorText += '* ${S.of(context).inputErrorPassword}\r\n';
        return errorText;
      }
    } else if (step == LoginStep.showOtp) {
      if (_checkStepValidation(LoginStep.showUsername, errorText: errorText) ==
              null &&
          _passwordController.text == _confirmPasswordController.text &&
          _otpController.text.length == 6) {
        return null;
      } else {
        errorText += '* ${S.of(context).inputErrorConfirmPassword}\r\n';
        return errorText;
      }
    }

    return null;
  }

  void _submitForm(
      LoginStep step,
      Future<BaseResponse> Function(String username, {String? countryCode})
          onDetectUserStatus,
      Future<BaseResponse> Function(String username, String password,
              {String? countryCode})
          onLogin,
      Future<BaseResponse> Function(
              String username, String password, String otp,
              {String? countryCode})
          onVerify,
      Future<BaseResponse> Function(String username, {String? countryCode})
          onForgotPassword) async {
    final isInputsValid = _checkStepValidation(step);
    if (isInputsValid == null) {
      if (step == LoginStep.showUsername) {
        await onDetectUserStatus(
          _usernameController.text,
          countryCode: '98',
        );
      } else if (step == LoginStep.showPassword) {
        final response = await onLogin(
            _usernameController.text, _passwordController.text,
            countryCode: '98');
        if (response.isSuccessful) {
          _navigateToDashboard();
        }
      } else if (step == LoginStep.showOtp) {
        final response = await onVerify(_usernameController.text,
            _passwordController.text, _otpController.text,
            countryCode: '98');
        if (response.isSuccessful) {
          _navigateToDashboard();
        }
      }
    } else {
      // TODO : manage input validation
      // DialogUtil.showErrorNotification(isInputsValid);
    }
  }

  void _navigateToDashboard() {
    // TODO : navigate to Dashboard Screen if user authentication is verified
    // context.router.replace(const DashboardRoute());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_form.dart';

/// Виджет экрана входа в систему.
///    Содержит виджет формы LoginForm, которая заполняется для входа в систему.
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        title: Text(AppLocalizations.of(context).title),
        elevation: 4,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        color: Colors.blue,
        child: SizedBox(height: 48),
      ),
      body: LoginForm(),
    );
  }
}

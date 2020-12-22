import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/kanban/kanban.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/login_bloc.dart';

/// Виджет формы входа в систему.
///   Виджет содержит:
///   - текстовое поле ввода username;
///   - текстовое поле ввода password;
///   - кнопку для отправки данных полей.
///
/// Проверка количества символов для полей username и password осуществлятся,
/// непосредственно внтури виджета Form. При невалидных значениях кнопка
/// отправки неактивна.
///
/// При нажатии кнопки отправки вызывается событие LoginRequested.
///
/// Состояние виджета управляется BLoC-ом LoginBloc:
///   - в состоянии LoginLoad, кнопка отправки заменена индикатором загрузки;
///   - при смене состояния на LoginDone, открывается KanbanScreen;
///   - при смене состояния на LoginFail, появляется диалог с сообщением.
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool usernameValid = false;
  bool passwordValid = false;
  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: usernameTextController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).usernameHint,
              hintStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: '   ${AppLocalizations.of(context).username}:',
              labelStyle: TextStyle(
                letterSpacing: 3,
                color: Colors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
            textAlign: TextAlign.center,
            validator: (value) {
              if (value.length < 4 && value.isNotEmpty) {
                return '  ${AppLocalizations.of(context).usernameValidation}';
              }
              return null;
            },
            onChanged: (text) {
              text.length < 4
                  ? setState(() => usernameValid = false)
                  : setState(() => usernameValid = true);
            },
          ),
          TextFormField(
            controller: passwordTextController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).passwordHint,
              hintStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: '   ${AppLocalizations.of(context).password}:',
              labelStyle: TextStyle(
                letterSpacing: 3,
                color: Colors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
            textAlign: TextAlign.center,
            validator: (value) {
              if (value.isNotEmpty && value.length < 8) {
                return '  ${AppLocalizations.of(context).passwordValidation}';
              }
              return null;
            },
            onChanged: (text) {
              text.length < 8
                  ? setState(() => passwordValid = false)
                  : setState(() => passwordValid = true);
            },
          ),
          SizedBox(height: 12),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginDone) {
                Navigator.pop(context);
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => KanbanScreen()),
                );
              }
              if (state is LoginFail) {
                String alertText = state.errorMessage;
                if (state.errorMessage == '1') {
                  alertText = AppLocalizations.of(context).wrongLogInData;
                }
                if (state.errorMessage == '2') {
                  alertText = AppLocalizations.of(context).noInternet;
                }
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(alertText),
                    contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.done, color: Colors.green, size: 32),
                        onPressed: () {
                          passwordTextController.text='';
                          setState(() => passwordValid = false);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LoginLoad) return CircularProgressIndicator();
              return ElevatedButton(
                onPressed: usernameValid && passwordValid
                    ? () {
                        context.read<LoginBloc>().add(
                              LoginRequested(
                                username: usernameTextController.text,
                                password: passwordTextController.text,
                              ),
                            );
                      }
                    : null,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(child: Text(AppLocalizations.of(context).logIn)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

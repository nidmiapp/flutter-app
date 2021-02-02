import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import 'package:nidmi/widget/logoScreenBckgrnd.dart';

import '../../entity/User.dart';
import 'signin.dart';
import '../../service/authSvc.dart';
import '../../util/validate.dart';
import '../../xinternal/AppGlobal.dart';

class Reset extends StatelessWidget {
  const Reset();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Reset Password"),
      ),
      body: const TextFormFieldReset(),
    );
  }
}

class TextFormFieldReset extends StatefulWidget {
  const TextFormFieldReset({Key key}) : super(key: key);

  @override
  TextFormFieldResetState createState() => TextFormFieldResetState();
}

class ResetData {
  String verifyCode = '';
  String email = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKeyReset,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKeyReset;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKeyReset,
      obscureText: _obscureText,
      maxLength: 24,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? "Show" : "Hide",
          ),
        ),
      ),
    );
  }
}

class TextFormFieldResetState extends State<TextFormFieldReset> {
  ResetData person = ResetData();

  bool isLoading = false;
  ValidateField _validateField  = new ValidateField();
  AuthService authService = new AuthService();
  AppGlobal appGlobal = new AppGlobal();
  var logger = Logger(printer: PrettyPrinter(),);
  User user = AppGlobal().user;


  void showInSnackBarReset(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKeyReset = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

  void _handleSubmittedReset() {
    final formRe = _formKeyReset.currentState;
    if (!formRe.validate()) {
      _autoValidateMode = AutovalidateMode.always; // Start validating on every change.
      showInSnackBarReset("One or more fields is not valid!",);
    } else {
      formRe.save();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      user.hash = person.password;
      user.email = person.email;
      _reset();
    }
  }

  _reset() async {

    setState(() {isLoading = true;});

    logger.i('  verify_code:===>>>'+user.verify_code +'  email:===>>>'+user.email );
    await authService.httpPost(user, "/accounts/reset-password")
        .then((result) async {
      if (result != null)  {
        setState(() {isLoading = false;});
        logger.i('  statusCode:====>>>' + result.statusCode +
            '\n  statusMessage:=>>>' + result.statusMessage );
        logger.i('  email:====>>>' + result.email +
            '\n  hash:=>>>' + result.hash );

        if(result.statusCode.startsWith('2')) { // 200, 201, ...
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          Navigator.pushReplacement(context,
              MaterialPageRoute( builder: (context) => SignIn()));
        }
      } else {
        setState(() {isLoading = true;});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 10);

    return Scaffold(
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          :
      Form(
        key: _formKeyReset,
        autovalidateMode: _autoValidateMode,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LogoScreenBckgrnd(220, 220),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Verification code has been sent to your email",
                      style: TextStyle(
                        //  color: Colors.deepOrange[500],
                          fontWeight: FontWeight.normal,
                          fontSize: 13),
                    ),
                  ],
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Enter verify code",
                    labelText: "verify code",
                  ),
                  onSaved: (value) {
                    person.verifyCode = value;
                  },
                  validator: _validateField.validateVerify,
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Enter valid email address",
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    person.email = value;
                  },
                  validator: _validateField.validateEmail,
                ),
                sizedBoxSpace,
                PasswordField(
                  fieldKeyReset: _passwordFieldKey,
                  labelText:
                  "Enter password",
                  validator: _validateField.validatePassword,
                  onSaved: (value) {
                    person.password = value;
                  },
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text("  Reset  "),
                    onPressed: _handleSubmittedReset,
                  ),
                ),
                sizedBoxSpace,
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

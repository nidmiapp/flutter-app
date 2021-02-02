import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import 'package:nidmi/widget/logoScreenBckgrnd.dart';

import '../../entity/User.dart';
import '../../util/validate.dart';
import 'signin.dart';
import '../../service/authSvc.dart';
import '../../xinternal/AppGlobal.dart';
import 'confirm.dart';

class SignUp extends StatelessWidget {
  const SignUp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign Up"),
      ),
      body: const TextFormFieldSignup(),
    );
  }
}

class TextFormFieldSignup extends StatefulWidget {
  const TextFormFieldSignup({Key key}) : super(key: key);

  @override
  TextFormFieldSignupState createState() => TextFormFieldSignupState();
}

class Data {
  String name = '';
  String email = '';
  String password = '';
//  String password2 = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKeySignUp,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKeySignUp;
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
      key: widget.fieldKeySignUp,
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

class TextFormFieldSignupState extends State<TextFormFieldSignup> {
  Data person = Data();

  void _setState(bool b) {
    setState(() { isLoading = b; });
  }
  void _setStateSnack(){
    setState(() { isLoading = false; });
    showInSnackBarSignUp("Connection error!");
  }

  void showInSnackBarSignUp(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKeySignUp = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

  void _handleSubmittedSignUp() {
    final formUp = _formKeySignUp.currentState;
    if (!formUp.validate()) {
      _autoValidateMode = AutovalidateMode.always; // Start validating on every change.
      showInSnackBarSignUp("One or more fields is not valid!",);
    } else {
      formUp.save();
      User user = new User();
      user.email = person.email;
      user.hash = person.password;
      appGlobal.user = user;
      _signUp();
    }
  }

  bool isLoading = false;
  ValidateField _validateField = new ValidateField();
  AuthService authService = new AuthService();
  AppGlobal appGlobal = AppGlobal.single_instance;
  var logger = Logger(printer: PrettyPrinter(),);

  _signUp() async {

    appGlobal.userEmail = person.email;

    _setState(true);

    User usr = new User(email: person.email, name: person.name, hash: person.password);
    await authService.httpPost(usr, "/accounts/register")
        .then((result) async {
      if (result != null)  {
        logger.i('  statusCode:====>>>' + result.statusCode +
            '\n  statusMessage:=>>>' + result.statusMessage );

        if(result.statusCode.startsWith('2')) { // 200, 201, ...
          User user = new User();
          user.name = result.name;
          user.verify_code = result.verify_code;
          user.email = result.email;
          AppGlobal.single_instance.user = user;
          await authService.httpPost(user, "/accounts/send-register")
              .then((sendRes) async {
            if (sendRes != null) {
              _setState(false);
              logger.i('sendRes  statusCode:====>>>' + sendRes.statusCode +
                  '\nsendRes  statusMessage:=>>>' + sendRes.statusMessage);

              if (sendRes.statusCode.startsWith('2')) { // 200, 201, ...
                _setState(false);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Confirm()));
              } else {
                _setStateSnack();
              }
            } else {
              _setStateSnack();
            }
          });
        } else {
          _setStateSnack();
        }
      } else {
        _setStateSnack();
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
        key: _formKeySignUp,
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
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Enter Username",
                    labelText: "Username",
                  ),
                  onSaved: (value) {
                    person.name = value;
                  },
                  validator: _validateField.validateName,
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
                  fieldKeySignUp: _passwordFieldKey,
                  labelText: "Enter password",
                  validator: _validateField.validatePassword,
                  onSaved: (value) {
                    person.password = value;
                  },
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text("  Register  "),
                    onPressed: _handleSubmittedSignUp,
                  ),
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( "Have an account? ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text( "Sign In",
                        style: TextStyle(
                            color: Colors.indigo[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
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

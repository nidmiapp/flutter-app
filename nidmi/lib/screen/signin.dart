import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:nidmi/screen/register.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';


class SignIn extends StatelessWidget {
  const SignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign In"),
      ),
      body: const TextFormFieldSignin(),
    );
  }
}

class TextFormFieldSignin extends StatefulWidget {
  const TextFormFieldSignin({Key key}) : super(key: key);

  @override
  TextFormFieldSigninState createState() => TextFormFieldSigninState();
}

class SigninData {
  String email = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKeySignIn,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKeySignIn;
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
      key: widget.fieldKeySignIn,
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
            // ? GalleryLocalizations.of(context)
            // .demoTextFieldShowPasswordLabel
            // : GalleryLocalizations.of(context)
            // .demoTextFieldHidePasswordLabel,
          ),
        ),
      ),
    );
  }
}

class TextFormFieldSigninState extends State<TextFormFieldSignin> {
  SigninData person = SigninData();

  void showInSnackBarSignIn(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

  void _handleSubmittedSignIn() {
    final formIn = _formKeySignIn.currentState;
    if (!formIn.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBarSignIn(
        "One or more fields is not valid!",
      );
    } else {
      formIn.save();
      showInSnackBarSignIn(
          person.email+' '+person.password
      );
    }
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Email is empty!";
    }
    final mailExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!mailExp.hasMatch(value)) {
      return "Not a valid email!";
    }
    return null;
  }

  String _validatePassword(String value) {
    final passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return "Password is empty!";
    }
    if (passwordField.value.length < 6) {
      return "Password is too short at least(6 character)!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 10);

    return Scaffold(
      body:
      Form(
        key: _formKeySignIn,
        autovalidateMode: _autoValidateMode,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: EdgeInsets.symmetric(horizontal: 16),
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.green, width: 1.5),
            //     borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
                      Image.asset("assets/images/NidmiLogoSign2Circle150X150.png"),
                    ]
                ),
                // Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    // icon: const Icon(Icons.email),
                    hintText: "Enter valid email address",
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    person.email = value;
                  },
                  validator: _validateEmail,
                ),
                sizedBoxSpace,
                PasswordField(
                  fieldKeySignIn: _passwordFieldKey,
                  // helperText:
                  // "Password",
                  labelText:
                  "Enter password",
                  onFieldSubmitted: (value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                  validator: _validatePassword,
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Text(
                    //   "Have not an account? ",
                    //   style: TextStyle(decorationColor: Colors.deepOrange, color: Colors.black, fontSize: 16),
                    // ),
                    GestureDetector(
                      onTap: () {
//                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Forgot()));
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text(
                        "  Sign In  "),
                    onPressed: _handleSubmittedSignIn,
                  ),
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have not an account? ",
                      style: TextStyle(decorationColor: Colors.deepOrange, color: Colors.black, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "ًRegister",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
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

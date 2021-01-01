
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:nidmi/screen/signin.dart';

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

class TextFormFieldResetState extends State<TextFormFieldReset> {
  ResetData person = ResetData();

  void showInSnackBarReset(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKeyReset = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _verifyFieldKey =
  GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();
  // final _UsNumberTextInputFormatter _phoneNumberFormatter =
  // _UsNumberTextInputFormatter();

  void _handleSubmittedReset() {
    final formRe = _formKeyReset.currentState;
    if (!formRe.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBarReset(
        "One or more fields is not valid!",
      );
    } else {
      formRe.save();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
      // showInSnackBarReset(
      //     person.verify+'  '+person.email+'  '+person.password
      //);
    }
  }

  String _validateVerify(String value) {
    final verifyField = _verifyFieldKey.currentState;
    if (verifyField.value == null || verifyField.value.isEmpty) {
      return "Code is empty!";
    }

    if (int.tryParse(verifyField.value)==null) {
      return "Not a valid! or Should be 6 digits!";
    }

    if (verifyField.value.length != 6 ) {
      return "Code Should be 6 digits!";
    }
    return null;
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
    if (passwordField.value != value) {
      return "Password is not match!";
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
        key: _formKeyReset,
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
                      Image.asset("assets/images/NidmiLogoSign2Circle100X100.png",),
                    ]
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Verification code has been sent to your email",
                      style: TextStyle(
                          color: Colors.deepOrange[500],
                          fontWeight: FontWeight.normal,
                          fontSize: 13),
                    ),
                  ],
                ),
                sizedBoxSpace,
                TextFormField(
                  //textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    filled: true,
                    // icon: const Icon(Icons.person),
                    hintText: "Enter verify code",
                    labelText:
                    "verify code",
                  ),
                  onSaved: (value) {
                    person.verifyCode = value;
                  },
                  validator: _validateVerify,
                ),
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
                  fieldKeyReset: _passwordFieldKey,
                  // helperText:
                  // "Password",
                  labelText:
                  "Enter password",
                  onFieldSubmitted: (value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Re-Enter Password",
                  ),
                  maxLength: 24,
                  obscureText: true,
                  validator: _validatePassword,
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text(
                        "  Reset  "),
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

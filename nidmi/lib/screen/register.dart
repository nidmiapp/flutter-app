// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

//import 'package:gallery/l10n/gallery_localizations.dart';


class TextFieldSignup extends StatelessWidget {
  const TextFieldSignup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Signup"),
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

class PersonData {
  String name = '';
  //String phoneNumber = '';
  String email = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
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
      key: widget.fieldKey,
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

class TextFormFieldSignupState extends State<TextFormFieldSignup> {
  PersonData person = PersonData();

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();
  // final _UsNumberTextInputFormatter _phoneNumberFormatter =
  // _UsNumberTextInputFormatter();

  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBar(
        "One or more fields is not valid!",
      );
    } else {
      form.save();
      showInSnackBar(
          person.name+'  '+person.email+'  '+person.password
      );
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "Username is empty!";
    }
    final nameExp = RegExp(r'^[A-Za-z][A-Za-z0-9 _-]+$');
    if (!nameExp.hasMatch(value)) {
      return "Invalid character used!";
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

  //
  // String _validatePhoneNumber(String value) {
  //   final phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
  //   if (!phoneExp.hasMatch(value)) {
  //     return "GalleryLocalizations.of(context).demoTextFieldEnterUSPhoneNumber";
  //   }
  //   return null;
  // }

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
        key: _formKey,
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
              Image.asset("assets/images/large-group-people-background-vector-illustration.jpg",),
              sizedBoxSpace,
              TextFormField(
                //textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  // icon: const Icon(Icons.person),
                  hintText: "Enter Username",
                  labelText:
                  "Username",
                ),
                onSaved: (value) {
                  person.name = value;
                },
                validator: _validateName,
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
                fieldKey: _passwordFieldKey,
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
                      "  Register  "),
                  onPressed: _handleSubmitted,
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
/*
/// Format incoming numeric text to fit the format of (###) ###-#### ##
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
*/

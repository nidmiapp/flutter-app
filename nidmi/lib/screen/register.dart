
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import 'package:nidmi/entity/User.dart';

import 'package:nidmi/screen/signin.dart';
import 'package:nidmi/service/authSvc.dart';

import 'confirm.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';


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

class SignupData {
  String name = '';
  String email = '';
  String password = '';
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
  SignupData person = SignupData();

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
  // final _UsNumberTextInputFormatter _phoneNumberFormatter =
  // _UsNumberTextInputFormatter();

  void _handleSubmittedSignUp() {
    final formUp = _formKeySignUp.currentState;
    if (!formUp.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBarSignUp(
        "One or more fields is not valid!",
      );
    } else {
      formUp.save();
      _SignUp();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Confirm()));
      // showInSnackBarSignUp(
      //     person.name+'  '+person.email+'  '+person.password
      //);
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
    person.password = value;
    return null;
  }

  AuthService authService = new AuthService();

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  bool isLoading = false;

  _SignUp() async {
    setState(() {
      isLoading = true;
    });

    logger.i('  email:===>>>'+person.name +'  email:===>>>'+person.email +'  pass:===>>>'+ person.password);
    await authService.register(person.name, person.email, person.password)
        .then((result) async {
      if (result != null)  {
        setState(() {
          isLoading = false;
          //show snackbar
        });

        logger.i(
            '\n  response:=>>>'+result.response+
                '\n  code:=====>>>'+result.code+
                // '\n  email:====>>>'+result.email+
                '\n  status:===>>>'+result.status
            // +
                // '\n  name:=>>>'+result.name+
                // '\n  hash:>>>'+result.hash+
                // '\n  verify_code:=>>>'+result.verify_code+
                // '\n  created_ts:===>>>'+result.created_ts.toString()+
                // '\n  user_id:===>>>'+result.user_id.toString()
        );

        // if(result.code.compareTo('200') == 0) {
        //   AppGlobal().saveUserAccessSharedPreference(result.access_token);
        //   AppGlobal().saveUserRefreshSharedPreference(result.refresh_token);
        //   AppGlobal().saveUserNameSharedPreference(result.display_name);
        //   AppGlobal().saveUserEmailSharedPreference(result.email);
        //   AppGlobal().saveUserExpiredSharedPreference(result.expires_at.toString());
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Confirm()));
        // } else {
        //   logger.i('  LoginResponse:=>>>'+result.response +
        //       '\n  code:==========>>>'+ result.code +
        //       '\n  status:========>>>'+ result.status);
        //   AppGlobal().saveUserAccessSharedPreference('');
        //   AppGlobal().saveUserRefreshSharedPreference('');
        //   AppGlobal().saveUserNameSharedPreference('');
        //   AppGlobal().saveUserEmailSharedPreference('');
        //   AppGlobal().saveUserExpiredSharedPreference('');
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash()));
        //   // var sheetController = showModalBottomSheet(
        //   //     context: context,
        //   //     builder: (context) => BottomSheetWidget());
        //   // sheetController.then((value) {});
        // }
        //
        // logger.i(
        //     '\n  getUserNameSharedPreference:====>>>'+ await AppGlobal().getUserNameSharedPreference()+
        //         '\n  getUserEmailSharedPreference:===>>>'+ await AppGlobal().getUserEmailSharedPreference()+
        //         '\n  getUserAccessSharedPreference:==>>>'+ await AppGlobal().getUserAccessSharedPreference()+
        //         '\n  getUserRefreshSharedPreference:=>>>'+ await AppGlobal().getUserRefreshSharedPreference()+
        //         '\n  getUserExpiredSharedPreference:=>>>'+ await AppGlobal().getUserExpiredSharedPreference()+
        //         '\n  isUserExpiredSharedPreference:==>>>'+ await AppGlobal().isUserExpiredSharedPreference().toString()
        // );

      } else {
        setState(() {
          isLoading = true;
          //show snackbar
        });
      }
    });
    //}
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
                      //Image.asset("assets/images/NidmiLogoSign-109X150-blend.png"),
                    ]
                ),
                // Image.asset("assets/images/BlkWt-large-group-of-people-1300X1300.png",),
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
                  fieldKeySignUp: _passwordFieldKey,
                  // helperText:
                  // "Password",
                  labelText:
                  "Enter password",
                  onFieldSubmitted: (value) {
                    setState(() {
                    });
                  },
                  onSaved: (value) {
                    person.password = value;
                    print('person.password:' + person.password);
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
                    onPressed: _handleSubmittedSignUp,
                  ),
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account? ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                        "Sign In",
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

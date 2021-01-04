
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import 'package:nidmi/entity/User.dart';

import '../screen/signin.dart';
import '../service/authSvc.dart';
import '../xinternal/AppGlobal.dart';

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

    AppGlobal appGlobal = AppGlobal.single_instance;

    appGlobal.userEmail = person.email;

    setState(() {
      isLoading = true;
    });

    logger.i('  email:===>>>'+person.name +'  email:===>>>'+person.email +'  pass:===>>>'+ person.password);
    await authService.register(person.name, person.email, person.password)
        .then((result) async {
      if (result != null)  {
        logger.i('  statusCode:====>>>' + result.statusCode +
            '\n  statusMessage:=>>>' + result.statusMessage );

        User user = new User();
        user.name = result.name;
        user.verify_code = result.verify_code;
        user.email = result.email;
//        user.user_id = result.user_id;
//        user.confirmed = result.confirmed;
        AppGlobal.single_instance.user = user;
        if(result.statusCode.startsWith('2')) { // 200, 201, ...
          await authService.sendRegister(user)
              .then((sendRes) async {
            if (sendRes != null) {
              setState(() {
                isLoading = false;
                //show snackbar
              });
              logger.i('\n  sendRes:<<<=>>>' + sendRes.toString());
              logger.i('sendRes  statusCode:====>>>' + sendRes.statusCode +
                  '\nsendRes  statusMessage:=>>>' + sendRes.statusMessage);

              if (sendRes.statusCode.startsWith('2')) { // 200, 201, ...
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Confirm()));
              }
            } else {
              setState(() {
                isLoading = true;
                //show snackbar
              });
            }
          });
        }
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

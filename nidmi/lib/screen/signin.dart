import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import 'package:nidmi/entity/Device.dart';
import 'package:nidmi/service/deviceSvc.dart';

import '../screen/forgot.dart';
import '../screen/register.dart';
import '../screen/splash.dart';
import '../service/authSvc.dart';
import '../util/validate.dart';
import '../xinternal/AppGlobal.dart';

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
      _autoValidateMode = AutovalidateMode.always; // Start validating on every change.
      showInSnackBarSignIn("One or more fields is not valid!",);
    } else {
      formIn.save();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      _signIn();
    }
  }

  bool isLoading = false;
  ValidateField _validateField = new ValidateField();
  AuthService authService = new AuthService();
  DeviceService deviceService = new DeviceService();
  var logger = Logger(printer: PrettyPrinter(),);

  _signIn() async {

    setState(() {isLoading = true;});

    logger.i('  email:===>>>'+person.email +'  pass:===>>>'+ person.password);
    await authService.login(person.email, person.password)
        .then((result) async {
      if (result != null)  {
        setState(() {isLoading = false;});

        if(result.code.compareTo('200') == 0) {
          Device dvc = new Device();
          dvc.owner_id = result.user_id;
          dvc.device_unique_id = await AppGlobal.getDeviceUUID();
          dvc.device_type = await AppGlobal.getDeviceType();
          dvc.token = result.refresh_token;
          dvc.activated = true;
          logger.i(
              '\n  response:=>>>'+result.response+
                  '\n  code:=====>>>'+result.code+
                  '\n  email:====>>>'+result.email+
                  '\n  status:===>>>'+result.status+
                  '\n  display_name:=>>>'+result.display_name+
                  '\n  refresh_token:>>>'+result.refresh_token+
                  '\n  access_token:=>>>'+result.access_token+
                  '\n  expires_at:===>>>'+result.expires_at+
                  '\n  user_id:===>>>'+result.user_id.toString()+
                  '\n  device_unique_id:===>>>'+dvc.device_unique_id+
                  '\n  token:===>>>'+dvc.token+
                  '\n  device_type:===>>>'+dvc.device_type
          );
          await AppGlobal.saveUserAccessSharedPreference(result.access_token);
          await AppGlobal.saveUserRefreshSharedPreference(result.refresh_token);
          await AppGlobal.saveUserNameSharedPreference(result.display_name);
          await AppGlobal.saveUserEmailSharedPreference(result.email);
          await AppGlobal.saveUserExpiredSharedPreference(result.expires_at.toString());
          print('############### dvc.toString() ###########'+dvc.toString());
          await deviceService.httpPost(dvc, "/device")
              .then((rslt) async {
            if (rslt != null) {
              setState(() {
                isLoading = false;
              });
              if (rslt.statusCode.startsWith('2')) { // 200, 201, ...
                logger.i('  device_unique_id:=>>>'+rslt.device_unique_id +
                    '\n  device_type:==========>>>'+ rslt.device_type +
                    '\n  status:========>>>'+ rslt.statusCode);
                AppGlobal.saveDeviceUUidSharedPreference(rslt.device_unique_id);
                AppGlobal.saveDeviceTypeSharedPreference(rslt.device_type);
              }
            } else {
              showInSnackBarSignIn("Login succeeded, but device not registered!");
              print('==============device info service failed=============');
              setState(() {isLoading = false;});
            }
          });
        } else {
          showInSnackBarSignIn("Login failed, Try again!");
          logger.i('  LoginResponse:=>>>'+result.response +
              '\n  code:==========>>>'+ result.code +
              '\n  status:========>>>'+ result.status);
          AppGlobal.saveUserAccessSharedPreference('');
          AppGlobal.saveUserRefreshSharedPreference('');
          AppGlobal.saveUserNameSharedPreference('');
          AppGlobal.saveUserEmailSharedPreference('');
          AppGlobal.saveUserExpiredSharedPreference('');
          AppGlobal.saveDeviceUUidSharedPreference('');
          AppGlobal.saveDeviceTypeSharedPreference('');
        }

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash(context)));

        logger.i(
            '\n  getUserNameSharedPreference:====>>>'+ await AppGlobal.getUserNameSharedPreference()+
                '\n  getUserEmailSharedPreference:===>>>'+ await AppGlobal.getUserEmailSharedPreference()+
                '\n  getUserAccessSharedPreference:==>>>'+ await AppGlobal.getUserAccessSharedPreference()+
                '\n  getUserRefreshSharedPreference:=>>>'+ await AppGlobal.getUserRefreshSharedPreference()+
                '\n  getUserExpiredSharedPreference:=>>>'+ await AppGlobal.getUserExpiredSharedPreference()+
                '\n  getDeviceUUidSharedPreference:=>>>'+ await AppGlobal.getDeviceUUidSharedPreference()+
                '\n  getDeviceTypeSharedPreference:=>>>'+ await AppGlobal.getDeviceTypeSharedPreference()+
                '\n  isUserExpiredSharedPreference:==>>>'+ AppGlobal.isUserExpiredSharedPreference().toString()
        );
      } else {
        showInSnackBarSignIn("Login failed, Try again!");
        print('==============login failed=============');
        setState(() {isLoading = false;});
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
        key: _formKeySignIn,
        autovalidateMode: _autoValidateMode,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                  fieldKeySignIn: _passwordFieldKey,
                  labelText: "Enter password",
                  onSaved: (value) {
                    person.password = value;
                  },
                  validator: _validateField.validatePassword,
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Forgot()));
                      },
                      child: Text("Forgot Password",
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
                    child: Text("  Sign In  "),
                    onPressed: _handleSubmittedSignIn,
                  ),
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have not an account? ",
                      style: TextStyle(decorationColor: Colors.deepOrange, color: Colors.black, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text("ًRegister",
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

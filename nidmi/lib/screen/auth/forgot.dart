import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import '../../entity/User.dart';
import 'reset.dart';
import '../../service/authSvc.dart';
import '../../util/validate.dart';
import '../../xinternal/AppGlobal.dart';

class Forgot extends StatelessWidget {
  const Forgot();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Forgot"),
      ),
      body: const TextFormFieldForgot(),
    );
  }
}

class TextFormFieldForgot extends StatefulWidget {
  const TextFormFieldForgot({Key key}) : super(key: key);

  @override
  TextFormFieldForgotState createState() => TextFormFieldForgotState();
}

class ForgotField extends StatefulWidget {
  const ForgotField({
    this.fieldKeyForgot,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKeyForgot;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _ForgotFieldState createState() => _ForgotFieldState();
}

class _ForgotFieldState extends State<ForgotField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKeyForgot,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
      ),
    );
  }
}

class TextFormFieldForgotState extends State<TextFormFieldForgot> {

  void showInSnackBarForgot(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKeyForgot = GlobalKey<FormState>();

  void _handleSubmittedForgot() {
    final formIn = _formKeyForgot.currentState;
    if (!formIn.validate()) {
      _autoValidateMode = AutovalidateMode.always; // Start validating on every change.
      showInSnackBarForgot("One or more fields is not valid!",);
    } else {
      formIn.save();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      _forgot();
    }
  }

  bool isLoading = false;
  ValidateField _validateField  = new ValidateField();
  AuthService authService = new AuthService();
  AppGlobal appGlobal = new AppGlobal();
  var logger = Logger(printer: PrettyPrinter(),);
  User user = AppGlobal().user;

  _forgot() async {
    setState(() { isLoading = true; });

    logger.i('  email:===>>>'+user.email );
    await authService.httpPost(user, "/accounts/forgot-password")
        .then((result) async {
      if (result != null)  {
        if(result.statusCode.startsWith('2')) { // 200, 201, ...
          logger.i('  statusCode:====>>>' + result.statusCode +
              '\n  statusMessage:=>>>' + result.statusMessage );
          User user = new User();
          user.name = result.name;
          user.verify_code = result.verify_code;
          user.email = result.email;
          AppGlobal.single_instance.user = user;
          await authService.httpPost(user, "/accounts/send-forgot")
              .then((sendRes) async {
            if (sendRes != null) {
              setState(() {isLoading = false;});
              logger.i('sendRes  statusCode:====>>>' + sendRes.statusCode +
                  '\nsendRes  statusMessage:=>>>' + sendRes.statusMessage);

              if (sendRes.statusCode.startsWith('2')) { // 200, 201, ...
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.pushReplacement( context,
                    MaterialPageRoute( builder: (context) => Reset()));
              } else {
                showInSnackBarForgot("Sending verify code not succeeded!");
              }
            } else {
              setState(() {isLoading = true;});
            }
          });
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
        key: _formKeyForgot,
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
                      Image.asset("assets/images/NidmiLogoSign2Circle900X900.png",width: 200, height: 200,),
                    ]
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Confirm email for resetting password",
                      style: TextStyle(
                       //   color: Colors.deepOrange[500],
                          fontWeight: FontWeight.normal,
                          fontSize: 13),
                    ),
                  ],
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Enter valid email address",
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: AppGlobal().userEmail ?? '',
                  onSaved: (value) {
                    user.email = value;
                  },
                  validator: _validateField.validateEmail,
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text("  Forgot  "),
                    onPressed: _handleSubmittedForgot,
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

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

class Confirm extends StatelessWidget {
  const Confirm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Confirm"),
      ),
      body: const TextFormFieldConfirm(),
    );
  }
}

class TextFormFieldConfirm extends StatefulWidget {
  const TextFormFieldConfirm({Key key}) : super(key: key);

  @override
  TextFormFieldConfirmState createState() => TextFormFieldConfirmState();
}

class ConfirmField extends StatefulWidget {
  const ConfirmField({
    this.fieldKeyConfirm,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKeyConfirm;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _ConfirmFieldState createState() => _ConfirmFieldState();
}

class _ConfirmFieldState extends State<ConfirmField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKeyConfirm,
      maxLength: 6,
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

class TextFormFieldConfirmState extends State<TextFormFieldConfirm> {

  void showInSnackBarConfirm(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKeyConfirm = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _verifyFieldKey =
  GlobalKey<FormFieldState<String>>();

  void _handleSubmittedConfirm() {
    final formIn = _formKeyConfirm.currentState;
    if (!formIn.validate()) {
      _autoValidateMode =  AutovalidateMode.always; // Start validating on every change.
      showInSnackBarConfirm("One or more fields is not valid!",);
    } else {
      formIn.save();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      _confirm();
    }
  }

  bool isLoading = false;
  ValidateField _validateField = new ValidateField();
  AuthService authService = new AuthService();
  AppGlobal appGlobal = new AppGlobal();
  var logger = Logger(printer: PrettyPrinter(),);
  User user  = AppGlobal().user;

  _confirm() async {

    setState(() {isLoading = true;});
    appGlobal.userEmail = user.email;

    logger.i('  verify_code:===>>>'+user.verify_code +'  email:===>>>'+user.email );
    await authService.httpPost(user,"/accounts/confirm")
        .then((result) async {
      if (result != null)  {
        setState(() {isLoading = false; });
        logger.i('  statusCode:====>>>' + result.statusCode +
            '\n  statusMessage:=>>>' + result.statusMessage );

        if(result.statusCode.startsWith('2')) { // 200, 201, ...
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SignIn()));
        } else {
          showInSnackBarConfirm("Not valid!");
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
        key: _formKeyConfirm,
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
                    hintText: "Enter valid email address",
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: appGlobal.userEmail,
                  onSaved: (value) {
                    user.email = value;
                  },
                  validator: _validateField.validateEmail,
                ),
                sizedBoxSpace,
                ConfirmField(
                  fieldKeyConfirm: _verifyFieldKey,
                  labelText: "Enter verify",
                  onFieldSubmitted: (value) {
                    setState(() {
                      user.verify_code = value;
                    });
                  },
                  validator: _validateField.validateVerify,
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text("  Confirm  "),
                    onPressed: _handleSubmittedConfirm,
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

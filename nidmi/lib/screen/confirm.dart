import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:logger/logger.dart';
import 'package:nidmi/entity/User.dart';
import 'package:nidmi/screen/signin.dart';
import 'package:nidmi/service/authSvc.dart';
import 'package:nidmi/xinternal/AppGlobal.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';


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
//  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKeyConfirm,
//      obscureText: _obscureText,
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
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBarConfirm(
        "One or more fields is not valid!",
      );
    } else {
      formIn.save();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      _Confirm();
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


  AuthService authService = new AuthService();

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  bool isLoading = false;

  AppGlobal appGlobal = new AppGlobal();

  User user = AppGlobal().user;

  _Confirm() async {


    setState(() {
      isLoading = true;
    });

    logger.i('  verify_code:===>>>'+user.verify_code +'  email:===>>>'+user.email );
    await authService.confirm(user)
        .then((result) async {
      if (result != null)  {
        setState(() {
          isLoading = false;
          //show snackbar
        });
        logger.i('  statusCode:====>>>' + result.statusCode +
            '\n  statusMessage:=>>>' + result.statusMessage );

        if(result.statusCode.startsWith('2')) { // 200, 201, ...
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SignIn()));
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
      body:
      Form(
        key: _formKeyConfirm,
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
                  decoration: InputDecoration(
                    filled: true,
                    // icon: const Icon(Icons.email),
                    hintText: "Enter valid email address",
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: AppGlobal().userEmail,
                  onSaved: (value) {
                    user.email = value;
                  },
                  validator: _validateEmail,
                ),
                sizedBoxSpace,
                ConfirmField(
                  fieldKeyConfirm: _verifyFieldKey,
                  // helperText:
                  // "Verify",
                  labelText:
                  "Enter verify",
                  onFieldSubmitted: (value) {
                    setState(() {
                      user.verify_code = value;
                    });
                  },
                  validator: _validateVerify,
                ),
                sizedBoxSpace,
                Center(
                  child: ElevatedButton(
                    child: Text(
                        "  Confirm  "),
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

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final _fomrKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            textColor: Colors.white,
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if(model.isLoading) return Center(child: CircularProgressIndicator(),);
          return Form(
            key: _fomrKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@"))
                      return "E-mail Inválido!";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(hintText: "Senha"),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return "Senha Inválida";
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      if(_emailController.text.isEmpty){
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Insira o e-mail para recuperação"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 3),)
                        );
                      } else {
                        model.recoverPass(_emailController.text);
                         _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Confira seu e-mail"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 3),));
                      }
                    },
                    child: Text(
                      "Esqueci a Senha",
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    elevation: 4,
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_fomrKey.currentState.validate()) {}
                      model.signIn(
                        email: _emailController.text,
                        pass: _senhaController.text,
                        onSuccess: _onSuccess,
                        onFail:  _onFail,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
   Navigator.of(context).pop();
  }

  void _onFail() {
   _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar o Usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}


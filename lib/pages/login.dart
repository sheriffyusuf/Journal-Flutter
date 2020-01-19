/*
//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:journal/authentication_bloc/bloc.dart';
//import 'package:journal/login/create_account_button.dart';
//import 'package:journal/login/login_button.dart';
//import 'package:journal/login/login_form.dart';
//import 'package:journal/login_bloc/bloc.dart';
//import '../user_repository.dart';
//import 'package:journal/user_repository.dart';
//
//class Login extends StatelessWidget {
//  final UserRepository _userRepository;
//
//  Login({Key key, @required UserRepository userRepository})
//      : assert(userRepository != null),
//        _userRepository = userRepository,
//        super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text('Login')),
//      body: BlocProvider<LoginBloc>(
//        builder: (context) => LoginBloc(userRepository: _userRepository),
//        child: LoginForm(userRepository: _userRepository),
//      ),
//    );
//  }
//}
*/

import 'package:flutter/material.dart';
import 'package:journal/blocs/login_bloc.dart';
import 'package:journal/services/authentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Icon(
            Icons.account_circle,
            size: 88.0,
            color: Colors.white,
          ),
          preferredSize: Size.fromHeight(40.0),
        ),
      ),
      //  backgroundColor: Colors.cyan,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: _loginBloc.email,
                builder: (context, snapshot) {
                  return TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email Address",
                        icon: Icon(Icons.mail_outline),
                        errorText: snapshot.error),
                    onChanged: _loginBloc.emailChanged.add,
                  );
                },
              ),
              StreamBuilder(
                stream: _loginBloc.password,
                builder: (context, snapshot) {
                  return TextField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        icon: Icon(Icons.security),
                        errorText: snapshot.error),
                    onChanged: _loginBloc.passwordChanged.add,
                  );
                },
              ),
              SizedBox(
                height: 48.0,
              ),
              _buildLoginAndCreateButtons()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }
        return null;
      }),
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              RaisedButton(
            elevation: 16.0,
            child: Text('Login'),
            color: Colors.lightGreen.shade200,
            disabledColor: Colors.grey.shade100,
            onPressed: snapshot.data
                ? () => _loginBloc.loginOrCreateChanged.add('Login')
                : null,
          ),
        ),
        FlatButton(
          child: Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        )
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              RaisedButton(
                  elevation: 16.0,
                  child: Text('Create Account'),
                  color: Colors.lightGreen.shade200,
                  disabledColor: Colors.grey.shade100,
                  onPressed: snapshot.data
                      ? () =>
                          _loginBloc.loginOrCreateChanged.add('Create Account')
                      : null),
        ),
        FlatButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        )
      ],
    );
  }
}

/*
class Login extends StatefulWidget {
  final UserRepository _userRepository;

  const Login({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
 final TextEditingController _emailController= TextEditingController();
 final TextEditingController _passwordController= TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) => state.isFormValid && isPopulated && !state.isSubmitting;


  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Icon(
              Icons.account_circle,
              size: 88.0,
              color: Colors.white,
            ),
            preferredSize: Size.fromHeight(40.0)),
      ),
      body: BlocProvider<LoginBloc>(
        child: BlocListener<LoginBloc,LoginState>(
          listener: (context, state){
            if (state.isFailure) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Login Failure'), Icon(Icons.error)],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
            if (state.isSubmitting) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Logging In...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
            }
            if (state.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder:(context, state){
              return SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    icon: Icon(Icons.mail_outline),),
                                controller: _emailController,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_){
                        return !state.isEmailValid ? 'Invalid Email' : null;

                      },
                              ),
                                TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.security), ),
                                controller: _passwordController,
                                autovalidate: true,
                                  autocorrect: false,
                                  validator: (_){
                                    return !state.isPasswordValid ? 'Invalid Password' : null;
                                  },
                                ),

                        SizedBox(height: 48.0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                          ),
                          CreateAccountButton(userRepository: _userRepository),
                        ],
                      ),
                       // _buildLoginAndCreateButtons(),
                    )],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

 */
/* Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          // ignore: missing_return
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          // ignore: missing_return
          return _buttonsCreateAccount();
        }
        return null;
      }),
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              RaisedButton(
            elevation: 16.0,
            child: Text('Login'),
            color: Colors.lightGreen.shade200,
            disabledColor: Colors.grey.shade100,
            onPressed: snapshot.data
                ? () => _loginBloc.loginOrCreateChanged.add('Login')
                : null,
          ),
        ),
        FlatButton(
          child: Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        )
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              RaisedButton(
                  elevation: 16.0,
                  child: Text('Create Account'),
                  color: Colors.lightGreen.shade200,
                  disabledColor: Colors.grey.shade100,
                  onPressed: snapshot.data
                      ? () =>
                          _loginBloc.loginOrCreateChanged.add('Create Account')
                      : null),
        ),
        FlatButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        )
      ],
    );
  }*/ /*


 void _onEmailChanged() {
   _loginBloc.dispatch(
     EmailChanged(email: _emailController.text),
   );
 }

 void _onPasswordChanged() {
   _loginBloc.dispatch(
     PasswordChanged(password: _passwordController.text),
   );
 }

 void _onFormSubmitted() {
   _loginBloc.dispatch(
     LoginWithCredentialsPressed(
       email: _emailController.text,
       password: _passwordController.text,
     ),
   );
 }
}
*/

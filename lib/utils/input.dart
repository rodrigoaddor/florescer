final _emailRegex = RegExp(
  r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);

String validateRequired(String value) => value.length > 0 ? null : 'Campo obrigatório';
String validateEmail(String value) => validateRequired(value) ?? (_emailRegex.hasMatch(value) ? null : 'Email inválido');

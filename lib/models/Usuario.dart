class Usuario {
  String _name = '';
  String _app_pat = '';
  String _app_mat = '';
  String _email = '';
  String _password = '';  
  String _type_user = '';
  DateTime _fecha_nacimiento;
  int _telefono = 0;
 
  Usuario({
    required name,
    required app_pat,
    required app_mat,
    required email,
    required password,
    required type_user,
    required fecha_nacimiento,
    required telefono,
  }): _name = name,
      _app_pat = app_pat,
      _app_mat = app_mat,
      _email = email,
      _password = password,
      _type_user = type_user,
      _fecha_nacimiento = fecha_nacimiento,
      _telefono = telefono;

// Getters 
String get name => _name;
String get app_pat => _app_pat;
String get app_mat => _app_mat;
String get email => _email;
String get password => _password;  
String get type_user => _type_user;
DateTime get fecha_nacimiento => _fecha_nacimiento;
int get telefono => _telefono;
// Setters 
set name(String value) => _name = value;
set app_pat(String value) => _app_pat = value;
set app_mat(String value) => _app_mat = value;
set email(String value) => _email = value;
set password(String value) => _password = value;
set type_user(String value) => _type_user = value;
set fecha_nacimiento(DateTime value) => _fecha_nacimiento = value;
set telefono(int value) => _telefono = value;

  /* ╭───── JSON ─────╮ */
  factory Usuario.fromJson(Map<String, dynamic> j) => Usuario(
    name: j['n']?.toString() ?? '',          
    app_pat: j['ap']?.toString() ?? '',          
    app_mat: j['am']?.toString() ?? '',          
    email: j['e']?.toString() ?? '',
    password: j['p']?.toString() ?? '',
    type_user: j['ty']?.toString() ?? '',
    fecha_nacimiento: DateTime.tryParse(j['f']?.toString() ?? '') ?? DateTime(0),
    telefono: (j['t'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'n': _name,
    'ap': _app_pat,
    'am': _app_mat,
    'e': _email,
    'p': _password,
    'ty': _type_user,
    'f': _fecha_nacimiento.toIso8601String(),
    't': _telefono,   
  };


}
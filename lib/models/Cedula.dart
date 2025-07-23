class Cedula {
  // Variables privadas
  String _institucion;
  String _numero;
  String _profesion;
  String _tipo;
  int _yearExpedicion; 

  // Constructor con parámetros requeridos
  Cedula({
    required String institucion,
    required String numero,
    required String profesion,
    required String tipo,
    required int yearExpedicion,
  })  : _institucion = institucion,
        _numero = numero,
        _profesion = profesion,
        _tipo = tipo,
        _yearExpedicion = yearExpedicion;

  // Getters 
    String get institucion => _institucion;
    String get numero => _numero;
    String get profesion => _profesion;
    String get tipo => _tipo;
      int get yearExpedicion => _yearExpedicion;
  //setters 
  set institucion(String value) => _institucion = value;
  set numero(String value) =>  _numero = value;
  set profesion(String value) =>  _profesion = value;
  set tipo(String value) => _tipo = value;
  set yearExpedicion(int value) =>_yearExpedicion = value;
  

  
  /* ╭───── JSON ─────╮ */
  factory Cedula.fromJson(Map<String, dynamic> j) => Cedula(
        institucion: j['i']?.toString() ?? '',
        numero: j['n']?.toString() ?? '',
        profesion: j['p']?.toString() ?? '',
        tipo: j['t']?.toString() ?? '',
        yearExpedicion: (j['y'] as num?)?.toInt() ?? 0,
      );


  Map<String, dynamic> toJson() => {
        'i': _institucion,
        'n': _numero,
        'p': _profesion,
        't': _tipo,
        'y': _yearExpedicion,
      };

  // Método toString para representación en cadena
  @override
  String toString() {
    return 'Cédula: $_numero ($_tipo)\n'
           'Profesión: $_profesion\n'
           'Institución: $_institucion\n'
           'Expedición: $_yearExpedicion\n';
  }

}




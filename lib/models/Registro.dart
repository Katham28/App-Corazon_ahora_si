class Registro {
  // Variables privadas
  DateTime _dateTime = DateTime.now();
  List<double> _aux_raw = [];
  List<double> _aux_time = [];
  List<double> _bmp_time = [];
  List<double> _bmp_raw = [];
  List<double> _egc_time = [];
  List<double> _egc_raw = [];
  List<double> _ppg_time = [];
  List<double> _ppg_raw = [];

  // Getters
  DateTime get dateTime => _dateTime;
  List<double> get auxRaw => _aux_raw;
  List<double> get auxTime => _aux_time;
  List<double> get bmpTime => _bmp_time;
  List<double> get bmpRaw => _bmp_raw;
  List<double> get egcTime => _egc_time;
  List<double> get egcRaw => _egc_raw;
  List<double> get ppgTime => _ppg_time;
  List<double> get ppgRaw => _ppg_raw;

  // Setters
  set dateTime(DateTime value) => _dateTime = value;
  set auxRaw(List<double> value) => _aux_raw = value;
  set auxTime(List<double> value) => _aux_time = value;
  set bmpTime(List<double> value) => _bmp_time = value;
  set bmpRaw(List<double> value) => _bmp_raw = value;
  set egcTime(List<double> value) => _egc_time = value;
  set egcRaw(List<double> value) => _egc_raw = value;
  set ppgTime(List<double> value) => _ppg_time = value;
  set ppgRaw(List<double> value) => _ppg_raw = value;

  // Métodos para agregar valores
  void addAuxRaw(double value) => _aux_raw.add(value);
  void addAuxTime(double value) => _aux_time.add(value);
  void addBmpTime(double value) => _bmp_time.add(value);
  void addBmpRaw(double value) => _bmp_raw.add(value);
  void addEgcTime(double value) => _egc_time.add(value);
  void addEgcRaw(double value) => _egc_raw.add(value);
  void addPpgTime(double value) => _ppg_time.add(value);
  void addPpgRaw(double value) => _ppg_raw.add(value);

  void addAll(List<double> values) {
    if (values.length != 8) throw ArgumentError('La lista debe contener exactamente 8 valores');
    addAuxRaw(values[0]); 
    addAuxTime(values[1]);
    addBmpTime(values[2]);
    addBmpRaw(values[3]);
    addEgcTime(values[4]);
    addEgcRaw(values[5]);
    addPpgTime(values[6]);
    addPpgRaw(values[7]);
  }

  // Constructor
  Registro({
    required DateTime dateTime,
    required List<double> aux_raw,
    required List<double> aux_time,
    required List<double> bmp_time,
    required List<double> bmp_raw,
    required List<double> egc_time,
    required List<double> egc_raw,
    required List<double> ppg_time,
    required List<double> ppg_raw,
  })  : _dateTime = dateTime,
        _aux_raw = aux_raw,
        _aux_time = aux_time,
        _bmp_time = bmp_time,
        _bmp_raw = bmp_raw,
        _egc_time = egc_time,
        _egc_raw = egc_raw,
        _ppg_time = ppg_time,
        _ppg_raw = ppg_raw;

// Factory para JSON - Versión corregida
factory Registro.fromJson(Map<String, dynamic> json) {
    List<double> convertList(dynamic list) {
      if (list == null) return [];
      return (list as List).map<double>((e) => (e as num).toDouble()).toList();
    }

    return Registro(
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toString()),
      aux_raw: convertList(json['aux_raw']),
      aux_time: convertList(json['aux_time']),
      bmp_time: convertList(json['bmp_time']),
      bmp_raw: convertList(json['bmp_raw']),
      egc_time: convertList(json['egc_time']),
      egc_raw: convertList(json['egc_raw']),
      ppg_time: convertList(json['ppg_time']),
      ppg_raw: convertList(json['ppg_raw']),
    );
  }

  Map<String, dynamic> toJson() => {
    'dateTime': _dateTime.toIso8601String(),
    'aux_raw': _aux_raw,
    'aux_time': _aux_time,
    'bmp_time': _bmp_time,
    'bmp_raw': _bmp_raw,
    'egc_time': _egc_time,
    'egc_raw': _egc_raw,
    'ppg_time': _ppg_time,
    'ppg_raw': _ppg_raw,
  };
}
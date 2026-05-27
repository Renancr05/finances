import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static final BancoHelper _instancia = BancoHelper._interno();

  factory BancoHelper() => _instancia;

  BancoHelper._interno();

  static Database? _banco;

  Future<Database> get banco async {
    if (_banco != null) {
      return _banco!;
    }

    _banco = await _iniciarBanco();
    return _banco!;
  }

  Future<Database> _iniciarBanco() async {
    final caminhoBanco = await getDatabasesPath();
    final caminho = join(caminhoBanco, 'banco_digital.db');

    return await openDatabase(caminho, version: 1, onCreate: _criarBanco);
  }

  Future<void> _criarBanco(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transferencias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeDestino TEXT,
        contaDestino TEXT,
        valor REAL,
        data TEXT
      )
    ''');
  }

  Future<int> inserirTransferencia(Map<String, dynamic> dados) async {
    final db = await banco;

    return await db.insert('transferencias', dados);
  }

  Future<List<Map<String, dynamic>>> listarTransferencias() async {
    final db = await banco;

    return await db.query('transferencias', orderBy: 'id DESC');
  }

  Future<int> excluirTransferencia(int id) async {
    final db = await banco;

    return await db.delete('transferencias', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> limparTransferencias() async {
    final db = await banco;

    return await db.delete('transferencias');
  }
}

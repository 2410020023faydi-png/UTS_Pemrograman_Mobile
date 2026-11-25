import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Emulator Android: 10.0.2.2 = laptop kamu.
// HP asli: ganti jadi IP laptop, contoh http://192.168.1.10:8000/api
//const String baseUrl = 'http://10.0.2.2:8000/api';//
const String baseUrl = 'http://127.0.0.1:8000/api';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodifikasi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

// Definisi satu kolom form
class Fld {
  final String key;
  final String label;
  final bool required;
  const Fld(this.key, this.label, {this.required = false});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kodifikasi Klinis'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
              Tab(icon: Icon(Icons.person), text: 'User'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CrudPage(
              endpoint: 'admin',
              idKey: 'id_admin',
              titleKey: 'nama_admin',
              subtitleKey: 'email_admin',
              fields: [
                Fld('nama_admin', 'Nama Admin', required: true),
                Fld('jenis_admin', 'Jenis Admin'),
                Fld('email_admin', 'Email', required: true),
                Fld('password_admin', 'Password', required: true),
                Fld('nomer_telepon_admin', 'Nomor Telepon'),
                Fld('tanggal_lahir_admin', 'Tanggal Lahir (YYYY-MM-DD)'),
                Fld('alamat_admin', 'Alamat'),
                Fld('jenis_kelamin_admin', 'Jenis Kelamin (L/P)'),
              ],
            ),
            CrudPage(
              endpoint: 'user',
              idKey: 'id_user',
              titleKey: 'nama_user',
              subtitleKey: 'email_user',
              fields: [
                Fld('nama_user', 'Nama User', required: true),
                Fld('email_user', 'Email', required: true),
                Fld('jenis_kelamin_user', 'Jenis Kelamin (L/P)'),
                Fld('no_telp_user', 'No. Telepon'),
                Fld('profesi_user', 'Profesi'),
                Fld('intansi_pekerjaan_user', 'Instansi Pekerjaan'),
                Fld('username_user', 'Username', required: true),
                Fld('password_user', 'Password', required: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CrudPage extends StatefulWidget {
  final String endpoint;
  final String idKey;
  final String titleKey;
  final String subtitleKey;
  final List<Fld> fields;

  const CrudPage({
    super.key,
    required this.endpoint,
    required this.idKey,
    required this.titleKey,
    required this.subtitleKey,
    required this.fields,
  });

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage>
    with AutomaticKeepAliveClientMixin {
  static const headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  List<dynamic> items = [];
  bool loading = true;
  String? error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // GET semua data
  Future<void> loadData() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/${widget.endpoint}'), headers: headers);
      if (res.statusCode == 200) {
        items = jsonDecode(res.body);
      } else {
        error = 'Gagal memuat data (${res.statusCode})';
      }
    } catch (e) {
      error = 'Tidak bisa terhubung ke server.\n'
          'Pastikan "php artisan serve" menyala.\n$e';
    }
    if (mounted) setState(() => loading = false);
  }

  // POST (tambah) atau PUT (ubah)
  Future<bool> saveData(Map<String, dynamic> data, {dynamic id}) async {
    try {
      final http.Response res;
      if (id == null) {
        res = await http.post(Uri.parse('$baseUrl/${widget.endpoint}'),
            headers: headers, body: jsonEncode(data));
      } else {
        res = await http.put(Uri.parse('$baseUrl/${widget.endpoint}/$id'),
            headers: headers, body: jsonEncode(data));
      }
      if (res.statusCode == 200 || res.statusCode == 201) {
        toast(jsonDecode(res.body)['message'] ?? 'Berhasil');
        return true;
      }
      // Pesan error validasi dari Laravel (422)
      final body = jsonDecode(res.body);
      if (body['errors'] != null) {
        final msgs = (body['errors'] as Map)
            .values
            .expand((e) => e as List)
            .join('\n');
        toast(msgs);
      } else {
        toast(body['message'] ?? 'Gagal menyimpan (${res.statusCode})');
      }
    } catch (e) {
      toast('Error: $e');
    }
    return false;
  }

  // DELETE
  Future<void> deleteData(dynamic id) async {
    try {
      final res = await http.delete(
          Uri.parse('$baseUrl/${widget.endpoint}/$id'),
          headers: headers);
      if (res.statusCode == 200) {
        toast('Data berhasil dihapus');
        loadData();
      } else {
        toast('Gagal menghapus (${res.statusCode})');
      }
    } catch (e) {
      toast('Error: $e');
    }
  }

  void confirmDelete(Map item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus data?'),
        content: Text('${item[widget.titleKey]} akan dihapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              deleteData(item[widget.idKey]);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Dialog form tambah / ubah
  void showForm({Map? item}) {
    final ctrls = {
      for (final f in widget.fields)
        f.key: TextEditingController(text: item?[f.key]?.toString() ?? '')
    };

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? 'Tambah ${widget.endpoint}' : 'Ubah ${widget.endpoint}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final f in widget.fields)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: ctrls[f.key],
                    decoration: InputDecoration(
                      labelText: f.required ? '${f.label} *' : f.label,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              for (final f in widget.fields) {
                if (f.required && ctrls[f.key]!.text.trim().isEmpty) {
                  toast('${f.label} wajib diisi');
                  return;
                }
              }
              final data = {
                for (final f in widget.fields) f.key: ctrls[f.key]!.text.trim()
              };
              final ok = await saveData(data, id: item?[widget.idKey]);
              if (ok && ctx.mounted) {
                Navigator.pop(ctx);
                loadData();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                            onPressed: loadData,
                            child: const Text('Coba lagi')),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadData,
                  child: items.isEmpty
                      ? ListView(children: const [
                          SizedBox(height: 200),
                          Center(child: Text('Belum ada data')),
                        ])
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (ctx, i) {
                            final item = items[i] as Map;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                    child: Text('${item[widget.idKey]}')),
                                title: Text('${item[widget.titleKey]}'),
                                subtitle: Text('${item[widget.subtitleKey]}'),
                                onTap: () => showForm(item: item),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => confirmDelete(item),
                                ),
                              ),
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
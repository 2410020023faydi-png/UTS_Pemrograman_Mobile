<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use App\Models\UserApp;

class UserController extends Controller
{
    // Tampil semua
    public function index()
    {
        return response()->json(UserApp::all(), 200);
    }

    // Tambah data
    public function store(Request $request)
    {
        $data = $request->validate([
            'nama_user' => 'required|string|max:100',
            'email_user' => 'required|email|max:100|unique:tabel_user,email_user',
            'jenis_kelamin_user' => 'nullable|string|max:20',
            'no_telp_user' => 'nullable|string|max:20',
            'profesi_user' => 'nullable|string|max:50',
            'intansi_pekerjaan_user' => 'nullable|string|max:100',
            'username_user' => 'required|string|max:50|unique:tabel_user,username_user',
            'password_user' => 'required|string|max:255',
        ]);

        $user = UserApp::create($data);
        return response()->json(['message' => 'User berhasil ditambahkan', 'data' => $user], 201);
    }

    // Tampil berdasarkan ID
    public function show($id)
    {
        $user = UserApp::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }
        return response()->json($user, 200);
    }

    // Update data
    public function update(Request $request, $id)
    {
        $user = UserApp::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        $data = $request->validate([
            'nama_user' => 'sometimes|string|max:100',
            'email_user' => ['sometimes', 'email', 'max:100', Rule::unique('tabel_user', 'email_user')->ignore($id, 'id_user')],
            'jenis_kelamin_user' => 'nullable|string|max:20',
            'no_telp_user' => 'nullable|string|max:20',
            'profesi_user' => 'nullable|string|max:50',
            'intansi_pekerjaan_user' => 'nullable|string|max:100',
            'username_user' => ['sometimes', 'string', 'max:50', Rule::unique('tabel_user', 'username_user')->ignore($id, 'id_user')],
            'password_user' => 'sometimes|string|max:255',
        ]);

        $user->update($data);
        return response()->json(['message' => 'User berhasil diubah', 'data' => $user], 200);
    }

    // Hapus data
    public function destroy($id)
    {
        $user = UserApp::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        $user->delete();
        return response()->json(['message' => 'User berhasil dihapus'], 200);
    }
}
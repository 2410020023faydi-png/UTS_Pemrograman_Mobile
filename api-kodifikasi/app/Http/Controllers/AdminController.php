<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Admin;

class AdminController extends Controller
{
    // Tampil semua
    public function index()
    {
        return response()->json(Admin::all(), 200);
    }

    // Tambah data
    public function store(Request $request)
    {
        $data = $request->validate([
            'nama_admin' => 'required|string|max:100',
            'jenis_admin' => 'nullable|string|max:50',
            'email_admin' => 'required|email|max:100',
            'password_admin' => 'required|string|max:255',
            'nomer_telepon_admin' => 'nullable|string|max:20',
            'tanggal_lahir_admin' => 'nullable|date',
            'alamat_admin' => 'nullable|string',
            'jenis_kelamin_admin' => 'nullable|string|max:20',
        ]);

        $admin = Admin::create($data);
        return response()->json(['message' => 'Admin berhasil ditambahkan', 'data' => $admin], 201);
    }

    // Tampil berdasarkan ID
    public function show($id)
    {
        $admin = Admin::find($id);
        if (!$admin) {
            return response()->json(['message' => 'Admin tidak ditemukan'], 404);
        }
        return response()->json($admin, 200);
    }

    // Update data
    public function update(Request $request, $id)
    {
        $admin = Admin::find($id);
        if (!$admin) {
            return response()->json(['message' => 'Admin tidak ditemukan'], 404);
        }

        $data = $request->validate([
            'nama_admin' => 'sometimes|string|max:100',
            'jenis_admin' => 'nullable|string|max:50',
            'email_admin' => 'sometimes|email|max:100',
            'password_admin' => 'sometimes|string|max:255',
            'nomer_telepon_admin' => 'nullable|string|max:20',
            'tanggal_lahir_admin' => 'nullable|date',
            'alamat_admin' => 'nullable|string',
            'jenis_kelamin_admin' => 'nullable|string|max:20',
        ]);

        $admin->update($data);
        return response()->json(['message' => 'Admin berhasil diubah', 'data' => $admin], 200);
    }

    // Hapus data
    public function destroy($id)
    {
        $admin = Admin::find($id);
        if (!$admin) {
            return response()->json(['message' => 'Admin tidak ditemukan'], 404);
        }

        $admin->delete();
        return response()->json(['message' => 'Admin berhasil dihapus'], 200);
    }
}
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    use HasFactory;

    protected $table = 'tabel_admin';
    protected $primaryKey = 'id_admin';

    protected $fillable = [
        'nama_admin',
        'jenis_admin',
        'email_admin',
        'password_admin',
        'nomer_telepon_admin',
        'tanggal_lahir_admin',
        'alamat_admin',
        'jenis_kelamin_admin',
    ];
}
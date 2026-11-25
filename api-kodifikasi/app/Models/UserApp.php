<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserApp extends Model
{
    use HasFactory;

    protected $table = 'tabel_user';
    protected $primaryKey = 'id_user';

    protected $fillable = [
        'nama_user',
        'email_user',
        'jenis_kelamin_user',
        'no_telp_user',
        'profesi_user',
        'intansi_pekerjaan_user',
        'username_user',
        'password_user',
    ];

    protected $hidden = ['password_user'];
}
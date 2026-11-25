<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tabel_user', function (Blueprint $table) {
            $table->id('id_user'); // Primary Key
            $table->string('nama_user', 100);
            $table->string('email_user', 100)->unique();
            $table->string('jenis_kelamin_user', 20)->nullable();
            $table->string('no_telp_user', 20)->nullable();
            $table->string('profesi_user', 50)->nullable();
            $table->string('intansi_pekerjaan_user', 100)->nullable();
            $table->string('username_user', 50)->unique();
            $table->string('password_user', 255);
            $table->timestamps(); // created_at & updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tabel_user');
    }
};

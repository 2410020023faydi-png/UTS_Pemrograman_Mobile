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
        Schema::create('tabel_admin', function (Blueprint $table) {
            $table->id('id_admin'); // Primary Key (sesuaikan jika namanya id atau id_admin)
            $table->string('nama_admin', 100);
            $table->string('email_admin', 100)->unique();
            $table->string('username_admin', 50)->unique();
            $table->string('password_admin', 255);
            $table->timestamps(); // created_at & updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tabel_admin');
    }
};
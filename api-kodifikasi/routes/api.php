<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\UserController;

Route::apiResource('admin', AdminController::class);
Route::apiResource('user', UserController::class);
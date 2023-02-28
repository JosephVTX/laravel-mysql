<?php

use App\Http\Controllers\Api\ProductController;
use Illuminate\Support\Facades\Route;


Route::resource('products', ProductController::class);


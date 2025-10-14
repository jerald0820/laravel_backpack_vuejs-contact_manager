<?php

use Illuminate\Http\Request;
use Modules\ContactManager\Http\Controllers\Api\ContactController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/contactmanager', function (Request $request) {
    return $request->user();
});

Route::prefix('contacts')->group(function(){
    Route::get('/', [ContactController::class,'index']);
    Route::post('/', [ContactController::class,'store']);
    Route::get('{id}', [ContactController::class,'show']);
    Route::delete('{id}', [ContactController::class,'destroy']);
});
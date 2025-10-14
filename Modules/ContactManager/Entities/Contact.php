<?php

namespace Modules\ContactManager\Entities;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Contact extends Model
{
    use HasFactory;

    protected $table = 'contacts';
    protected $fillable = ['name','email','image_path'];
    
    protected static function newFactory()
    {
        return \Modules\ContactManager\Database\factories\ContactFactory::new();
    }
}

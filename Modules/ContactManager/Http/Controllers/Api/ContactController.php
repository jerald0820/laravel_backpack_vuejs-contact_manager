<?php

namespace Modules\ContactManager\Http\Controllers\Api;

use Illuminate\Contracts\Support\Renderable;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Http\Resources\Json\JsonResource;
use Modules\ContactManager\Entities\Contact;
use Illuminate\Support\Facades\Storage;

class ContactResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id'=>$this->id,
            'name'=>$this->name,
            'email'=>$this->email,
            'image_url'=> $this->image_path ? Storage::url($this->image_path) : null,
            'created_at'=>$this->created_at,
        ];
    }
}

class ContactController extends Controller
{
    public function index()
    {
        return ContactResource::collection(Contact::orderBy('created_at','desc')->get());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'=>'required|string|max:255',
            'email'=>'required|email|unique:contacts,email',
            'image'=>'nullable|image|max:2048',
        ]);

        if($request->hasFile('image')){
            $path = $request->file('image')->store('contacts','public');
            $data['image_path'] = $path;
        }

        $contact = Contact::create($data);
        return new ContactResource($contact);
    }

    public function show($id)
    {
        return new ContactResource(Contact::findOrFail($id));
    }

    public function destroy($id)
    {
        $contact = Contact::findOrFail($id);
        if($contact->image_path){
            Storage::disk('public')->delete($contact->image_path);
        }
        $contact->delete();
        return response()->noContent();
    }
}

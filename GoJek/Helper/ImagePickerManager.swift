//
//  ImagePickerManager.swift
//  Yanik
//
//  Created by Ram Niwas on 4/5/19.
//  Copyright © 2019 Apptology. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((Any, String) -> ())?;
    
    
    private let imageView = UIImageView()
    
    private var image: UIImage?
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0


    override init(){
        super.init()
    }
    
   func pickImage(_ viewController: UIViewController,_ cameraType : NSInteger, _ callback: @escaping ((Any, String) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        picker.delegate = self
        var cameraAction : UIAlertAction!
        var gallaryAction : UIAlertAction!
        if UIImagePickerController.isSourceTypeAvailable(.camera){
             cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                self.openCamera(cameraType)
            }
            alert.addAction(cameraAction)
            self.openCamera(cameraType)
        }
        else{
             gallaryAction = UIAlertAction(title: "Gallary", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            alert.addAction(gallaryAction)
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        
        alert.addAction(cancelAction)
    }
    
    
    func openCamera(_ type : NSInteger){
        
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            
            if type == 1{// open video mode
                picker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            }
            self.viewController!.present(picker, animated: true, completion: nil)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType  == "public.image" {
                guard let selectedImage = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
                pickImageCallback!(selectedImage,"")
            }
            
            if mediaType == "public.movie" {
                if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    pickImageCallback!(url,"")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
        
    }
}

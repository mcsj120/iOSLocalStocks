//
//  CameraViewController.swift
//  StockApp
//
//  Created by mcstonge on 11/14/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//

import UIKit
import CoreData

class CameraViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let picker = UIImagePickerController()
    var email: String?
    
    @IBOutlet weak var image: UIImageView!{
        didSet {
            image.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var message: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func picture(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.cameraCaptureMode = .photo
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker,animated: true,completion: nil)
        }
        else{
            
            self.message.text = "Camera unavailible"
            
        }
    }
    
    @IBAction func library(_ sender: Any)
    {
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.picker.modalPresentationStyle = .popover
        self.present(self.picker, animated: true, completion: nil)
    }

    @IBAction func searchSeg(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toSearchFromCamera", sender: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker .dismiss(animated: true, completion: nil)
        image.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    

    @IBAction func `return`(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toHomeFromCamera", sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let x:searchViewController = segue.destination as? searchViewController
        {
            x.email = email
            if(!(message.text?.isEmpty)!)
            {
                x.mapparam = message.text
            }
        }
        else if let x:ProfileViewController = segue.destination as? ProfileViewController
        {
            x.email = email
        }
    }
    
}

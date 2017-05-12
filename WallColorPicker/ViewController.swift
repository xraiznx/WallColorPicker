//
//  ViewController.swift
//  WallColor
//
//  Created by Israel Hammon on 2/24/17.
//  Copyright © 2017 Israel Hammon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate
{
    var tempImage: UIImage? // Variable for image
    
    @IBOutlet weak var ImageView: UIImageView! // Outlet for image to be displayed
    let picker = UIImagePickerController()
    
    // When next is pressed perform segue
    @IBAction func NextScreen(_ sender: UIBarButtonItem) { performSegue(withIdentifier: "DisplayImage", sender: nil) }
    
    // When take picture button is pressed
    @IBAction func TakePicture(_ sender: UIButton)
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
    }
    
    // When use existing button is pressed
    @IBAction func UseExisting(_ sender: UIButton)
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    // Image picker controller stuff
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated:true, completion: nil)
        self.performSegue(withIdentifier: "DisplayImage", sender: nil)
    }
    
    // If cancel button is pressed dismiss picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){ dismiss(animated: true, completion: nil) }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "DisplayImage"
        {
            let controller = segue.destination as! ImageDisplayViewController
            controller.image = tempImage! // Send image to ImageDisplayViewController
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker.delegate = self
    }
}

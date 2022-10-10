//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 05/10/2022.
//

import UIKit
import CoreData

class NewRestaurantController: UITableViewController {

    var restaurant: Restaurant!
    
    @IBOutlet var photoImageView: UIImageView!{
        didSet{
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var nameTextField: UITextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: UITextField!{
        didSet{
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: UITextField!{
        didSet{
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: UITextField!{
        didSet{
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView!{
        didSet{
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 10
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    func displayAlert(){
        let alertController = UIAlertController(title: "Ooops",
                                                message: "We can't proceed because one of the fields is blank. Please note that all fields are requaierd.",
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertAction.Style.default,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(){
        
        if nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            displayAlert()
            return
        }
        if typeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            displayAlert()
            return
        }
        if addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            displayAlert()
            return
        }
        if phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            displayAlert()
            return
        }
        if descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            displayAlert()
            return
        }
        
        print("Name: " + nameTextField.text!)
        print("Type: " + typeTextField.text!)
        print("Address: " + addressTextField.text!)
        print("Phone: " + phoneTextField.text!)
        print("Description: " + descriptionTextView.text!)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            restaurant = Restaurant(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text!
            restaurant.type = typeTextField.text!
            restaurant.location = addressTextField.text!
            restaurant.phone = phoneTextField.text!
            restaurant.summary = descriptionTextView.text
            restaurant.isFavorite = false

            if let imageData = photoImageView.image?.pngData(){
                restaurant.image = imageData
            }

            print("Saving data to context... ")
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the navigation bar appearance
        if let appearance = navigationController?.navigationBar.standardAppearance{
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0){
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor:UIColor(named: "NavigationBarTitle")!, .font:customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
        }
        
        // constraints for imageView
        // get the superview's layout
        let margins = photoImageView.superview!.layoutMarginsGuide
        
        // Disable auto resizing mask to use auto layout programmatically
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Pin the leading edge of the image view to the margin's leading edge
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        // Pin the trailing edge of the image view to the margin's trailing edge
        photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        // Pin the top edge of the image view to the margin's top edge
        photoImageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // Pin the bottom edge of the image view to the margin's bottom edge
        photoImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        // allow to hide keyboard when lank area is tapped
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }

    //
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if
                    UIImagePickerController.isSourceTypeAvailable(.camera){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if
                    UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
                
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            //for iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
            
        }
    }

}

extension NewRestaurantController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1){
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
}

extension NewRestaurantController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

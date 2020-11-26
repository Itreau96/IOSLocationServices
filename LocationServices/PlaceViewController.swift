//
//  ViewController.swift
//  LocationServices
//
//  Created by  on 10/17/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit
import os.log

class PlaceViewController: UIViewController, UITextFieldDelegate {

    var place : PlaceDescription?
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var addrTitleTextField: UITextField!
    @IBOutlet var addrStreetTextField: UITextField!
    @IBOutlet var elevationTextField: UITextField!
    @IBOutlet var latTextField: UITextField!
    @IBOutlet var longTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        
        if let place = place {
            setPlace(place: place)
        }
        
        updateSaveButtonState()
    }
    
    func setPlace(place: PlaceDescription) {
        nameTextField.text = place.name
        descriptionTextField.text = place.description
        categoryTextField.text = place.category
        addrTitleTextField.text = place.addrTitle
        addrStreetTextField.text = place.addrStreet
        elevationTextField.text = String(place.elevation)
        latTextField.text = String(place.latitude)
        longTextField.text = String(place.longitude)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveBtn.isEnabled = !text.isEmpty
    }
    
    //MARK: Controller Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let inAddMode = presentingViewController is UINavigationController
    
        if inAddMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PlaceViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveBtn else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let category = descriptionTextField.text ?? ""
        let addrTitle = addrTitleTextField.text ?? ""
        let addrStreet = addrStreetTextField.text ?? ""
        let elevation = Float(elevationTextField.text!) ?? 0.0
        let latitude = Float(elevationTextField.text!) ?? 0.0
        let longitude = Float(elevationTextField.text!) ?? 0.0

        if (name == "") {
            let alert = UIAlertController(title: "Invalid Place", message: "Name field is required.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        place = PlaceDescription(name: name, description: description, category:  category, addrTitle: addrTitle, addrStreet: addrStreet, elevation:  elevation, latitude: latitude, longitude:  longitude)
    }
}


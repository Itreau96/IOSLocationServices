//
//  ViewController.swift
//  LocationServices
//
//  Created by  on 10/17/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var model = PlaceDescription()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var addrTitleTextField: UITextField!
    @IBOutlet var addrStreetTextField: UITextField!
    @IBOutlet var elevationTextField: UITextField!
    @IBOutlet var latTextField: UITextField!
    @IBOutlet var longTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func createClicked(_ sender: UIButton) {
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
        
        model = PlaceDescription(name: name, description: description, category:  category, addrTitle: addrTitle, addrStreet: addrStreet, elevation:  elevation, latitude: latitude, longitude:  longitude)
    }
    
}


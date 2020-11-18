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
        let name = nameTextField.text
        let 
    }
    
}


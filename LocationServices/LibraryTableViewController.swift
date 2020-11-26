/*
    Copyright 2020 Itreau Bigsby

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

@author   Itreau Bigsby    mailto:ibigsby@asu.edu
@version 2.0 Nov 17, 2020
 */

import UIKit
import os.log

class LibraryTableViewController: UITableViewController {

    var urlString:String = "http://localhost:8181"
    var placeNames:[String]=[String]()
    //var placeLib = PlaceLibrary(url: u)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        urlString = setURL()
        
        callGetNamesNUpdateStudentsPicker()
        
        //placeLib = PlaceLibrary(url: urlString)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func callGetNamesNUpdateStudentsPicker() {
        let aConnect:PlaceLibrary = PlaceLibrary(url: urlString)
        let _:Bool = aConnect.getNames(callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            } else {
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        self.placeNames = (dict!["result"] as? [String])!
                        self.placeNames = Array(self.placeNames).sorted()
                        // self.studentPicker.reloadAllComponents() maybe reload at this point?
                        //if self.students.count > 0 {
                        //    self.callGetNPopulatUIFields(self.students[0])
                        //}
                        self.tableView.reloadData()
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })  // end of method call to getNames
    }
    
    func callGetNPopulatUIFields(_ name: String, controller: PlaceViewController) {
        let aConnect:PlaceLibrary = PlaceLibrary(url: urlString)
        let _:Bool = aConnect.get(name: name, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            } else {
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        //let dataStr = String(decoding: data, as: UTF8.self)
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as? [String:AnyObject]
                        let aDict:[String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        let placeDescription = PlaceDescription(dict: aDict)
                        controller.setPlace(place: placeDescription)
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
        })
    }

    func setURL () -> String {
        var serverhost:String = "localhost"
        var jsonrpcport:String = "8080"
        var serverprotocol:String = "http"
        // access and log all of the app settings from the settings bundle resource
        if let path = Bundle.main.path(forResource: "ServerInfo", ofType: "plist"){
            // defaults
            if let dict = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                serverhost = (dict["serverHost"] as? String)!
                jsonrpcport = (dict["serverPort"] as? String)!
                serverprotocol = (dict["serverProtocol"] as? String)!
            }
        }
        print("setURL returning: \(serverprotocol)://\(serverhost):\(jsonrpcport)")
        return "\(serverprotocol)://\(serverhost):\(jsonrpcport)"
    }

    //MARK: Controller Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    
        switch(segue.identifier ?? "") {
            
            case "AddPlace":
                os_log("Adding a new place.", log: OSLog.default, type: .debug)
            
            case "ShowPlace":
                guard let placeViewController = segue.destination as? PlaceViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPlaceCell = sender as? PlaceTableviewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPlaceCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            //let selectedPlace = placeLib.places[indexPath.row]
                callGetNPopulatUIFields(placeNames[indexPath.row], controller: placeViewController)
            
            
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToPlaceList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PlaceViewController, let place = sourceViewController.place {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing place.
                //placeLib.places[selectedIndexPath.row] = place
                //tableView.reloadRows(at: [selectedIndexPath], with: .none)
                let aConnect:PlaceLibrary = PlaceLibrary(url: self.urlString)
                let _:Bool = aConnect.add(place: place,callback: { _,_  in
                    print("\(place.name) added as: \(place.toJsonString())")
                    self.callGetNamesNUpdateStudentsPicker()})
                tableView.reloadData()
            } else {
                // Add a new place.
                //let newIndexPath = IndexPath(row: placeNames.count, section: 0)
                //placeLib.places.append(place)
                let aConnect:PlaceLibrary = PlaceLibrary(url: self.urlString)
                let _:Bool = aConnect.add(place: place,callback: { _,_  in
                    print("\(place.name) added as: \(place.toJsonString())")
                //self.callGetNPopulatUIFields(self.studLabel.text!)})
                    self.callGetNamesNUpdateStudentsPicker()})
                //tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    }

    //MARK: Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "PlaceCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PlaceTableviewCell  else {
                fatalError("The dequeued cell is not an instance of PlaceTableViewCell.")
        }
        let place = placeNames[indexPath.row]//placeLib.places[indexPath.row]
        cell.label?.text = place

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //placeLib.places.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let aConnect:PlaceLibrary = PlaceLibrary(url: urlString)
            let _:Bool = aConnect.remove(placeName: placeNames[indexPath.row],callback: { _,_  in
                self.callGetNamesNUpdateStudentsPicker()
                })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}

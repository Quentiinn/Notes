//
//  AddEditNoteTableViewController.swift
//  Notes
//
//  Created by quentin courvoisier on 23/11/2017.
//  Copyright © 2017 IUT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AddEditNoteTableViewController: UITableViewController, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    var latitude: Float?
    var longitude: Float?
    var id: Int!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titre: UITextField!
    @IBOutlet weak var notes: UITextField!
    let position = CLLocationManager ()
    

    @IBOutlet weak var BtSave: UIBarButtonItem!
    @IBAction func testTitleChanged(_ sender: UITextField) {
        if (!(sender.text?.isEmpty)! && !(notes.text?.isEmpty)!){
            BtSave.isEnabled = true
        }
    }
    
    
    @IBAction func testNotesChanged(_ sender: UITextField) {
        if (!(sender.text?.isEmpty)! && !(titre.text?.isEmpty)!){
            BtSave.isEnabled = true
        }
    }
    
    @IBAction func BtLocalisation(_ sender: Any) {
        print("clique clique")
        determineMyCurrentLocation()
    }
    
    


    
    var note: Notes?
    //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        if let note = note {//edit mode
             titre.text = note.title
            notes.text = note.content
            latitude = note.latitude
            longitude = note.longitude
            id = Int(note.id)
            
            if let latitude = latitude {
                determineMyCurrentLocation()
            }
        }else{
            var data = [Note]()
            do{
                data = try context.fetch(Note.fetchRequest())
                var ids = data.count + 1
                print("id ajout \(ids)")
                id = ids
            }catch{
                print("no")
            }
            //print(longitude)
            
        }
        if (!((titre.text?.isEmpty)!) && !((notes.text?.isEmpty)!)){
            BtSave.isEnabled = true;
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        
        
        map.setRegion(coordinateRegion, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveUnwind"{
            //print(id)
            if  let latitude = latitude{
                note = Notes(id: (Int16(id)), title: titre.text!, date:Date() , content: notes.text!, latitude: Float(latitude), longitude: Float(longitude!))

            }else{
                note = Notes(id: (Int16(id)), title: titre.text!, date:Date() , content: notes.text!)

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let annotation = MKPointAnnotation()
        let initialLocation = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        var initi:CLLocation
        if latitude != nil && longitude != nil {
            initi = CLLocation(latitude : Double(latitude!), longitude : Double(longitude!))
        }else{
            initi = CLLocation(latitude : userLocation.coordinate.latitude, longitude : userLocation.coordinate.longitude)
        }

        
        print("Latitude \(userLocation.coordinate.latitude)")
        annotation.coordinate = initialLocation
        annotation.title = "ICI"
        annotation.subtitle = "Vous êtes ici"
        map.addAnnotation(annotation);
        centerMapOnLocation(location: initi)
        
        
        latitude = Float(userLocation.coordinate.latitude)
        longitude = Float(userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    
 

}

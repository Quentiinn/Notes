//
//  NotesTableViewController.swift
//  Notes
//
//  Created by quentin courvoisier on 23/11/2017.
//  Copyright © 2017 IUT. All rights reserved.
//

import UIKit
import CoreData


class NotesTableViewController: UITableViewController {
    /*var notes: [Notes] = [
        Notes(title:"Test",date:Date(),content:"content test", latitude:45.4, longitude:7),
        Notes(title:"Test numero 2",date:Date(),content:"content test testtest", latitude:45.4, longitude:7)
    ]*/
    var notes: [Notes] = []

    
    override func viewDidLoad() {
        //permet de recuperer les données
        var data = [Note]()
        do{
            data = try context.fetch(Note.fetchRequest())
            
            for each in data {
                let n: Notes = Notes(id: each.id, title: each.title!, date: each.date!, content: each.content!, latitude: each.latitude, longitude: each.longitude)
                notes.append(n)
            }
        }catch{
            
        }

        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = editButtonItem

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let myString = formatter.string(from: note.date)
        cell.detailTextLabel?.text = myString
        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteNote(forRowAt: indexPath)
            
           
            
            /*do{
                data = try context.fetch(Note.fetchRequest())
                for each in data {
                    for i in 0 ... notes.count-1 {
                        print(notes[i].id)
                        if notes[i].id == each.id{
                            let valeur = notes[indexPath.row]
                            context.deletedObjects(valeur )
    
                            appDelegate.saveContext()
                            notes.remove(at: i)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            break
                        }
                    }
                    /*if each.id == notes.index(after: indexPath.row){
                     
                    }*/
                }
            }catch{
                
            }*/
            //context.delete(notes[indexPath.row])
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedNote = notes.remove(at: fromIndexPath.row)
        notes.insert(movedNote, at: to.row)
        tableView.reloadData()
    }
    
    
    func deleteNote(forRowAt index: IndexPath){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                    if data.value(forKey: "id") as! Int == notes[index.row].id{
                        
                        notes.remove(at: index.row)
                        tableView.deleteRows(at: [index], with: .fade)
                        context.delete(data)
                        appDelegate.saveContext()
                        tableView.reloadData()
                        return
                    }
            }
        } catch {
            print("Failed")
        }
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditNote"{
            let addEditNoteTableViewController = segue.destination as! AddEditNoteTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let notes = self.notes[indexPath.row]
            addEditNoteTableViewController.note = notes
        }
    }
    
    
    @IBAction func unwindFromAddEditNoteController(segue: UIStoryboardSegue){
        if segue.identifier == "saveUnwind"{
            let sourceTableViewController = segue.source as! AddEditNoteTableViewController
            if let notes = sourceTableViewController.note{
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    // si clique sur un champ
                    self.notes[selectedIndexPath.row] = notes
                    tableView.reloadData()
                }else{
                    //clique sur +
                    
                    self.notes.append(notes)
                    //print(notes.title)
                    //Ajout de note dans la bdd
                    let note = Note(context: context)
                    note.id = notes.id
                    note.title = notes.title
                    note.content = notes.content
                    note.date = Date()
                    if let latitude = sourceTableViewController.latitude{
                        note.latitude = latitude
                    }
                    
                    if let longitude = sourceTableViewController.longitude{
                        note.longitude = longitude
                    }
                    
                    appDelegate.saveContext()
                    
                    //let newIndexPath = IndexPath(row: self.notes.count, section: 0)
                    //tableView.insertRows(at: [newIndexPath], with: .automatic)
                    tableView.reloadData()
                }
            }
        }
    }
}

//
//  MasterViewController.swift
//  MesNotes
//
//  Created by Maxime Britto on 24/11/2016.
//  Copyright © 2016 mbritto. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {
    let _subjectManager:SubjectManager = SubjectManager(withRealm:try! Realm())
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(askUserForSubjectName))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func askUserForSubjectName() {
        let alertController = UIAlertController(title: "Nouvelle matière", message: "Entrez le nom de la matière", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: "Créer", style: UIAlertActionStyle.destructive, handler: {(_) -> Void in
            if let newTitle = alertController.textFields?.first?.text {
                self.insertNewSubject(withTitle: newTitle)
            }
        })
        alertController.addAction(createAction)
        
        let cancelActionb = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alertController.addAction(cancelActionb)
        
        alertController.addTextField(configurationHandler: nil)
        
        present(alertController, animated: true, completion: nil)
    }

    func insertNewSubject(withTitle title:String) {
        if let newSubject = _subjectManager.addSubject(withTitle: title) {
            let indexPath = IndexPath(row: _subjectManager.getIndex(forSubject: newSubject)!, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = _subjectManager.getSubject(atIndex: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _subjectManager.getSubjectCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.showsReorderControl = true
        let object = _subjectManager.getSubject(atIndex: indexPath.row)!
        cell.textLabel!.text = object.getTitle()
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _subjectManager.deleteSubject(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


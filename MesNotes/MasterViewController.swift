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
    private static let SERVER_IP = "192.168.1.42:9080"
    var _subjectManager:SubjectManager = SubjectManager(withRealm:try! Realm())
    var detailViewController: DetailViewController? = nil
    var _notificationToken:NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareRealm()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(askUserForSubjectName))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func realmConnected(withUser user:SyncUser) {
        // can now open a synchronized Realm with this user
        let syncServerURL = URL(string: "realm://\(MasterViewController.SERVER_IP)/~/julRealm")!
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
        
        // Open the remote Realm
        let realm = try! Realm(configuration: config)
        _subjectManager = SubjectManager(withRealm: realm)
        // Observe Results Notifications
        _notificationToken = _subjectManager.subjectList.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }

    }
    
    func prepareRealm() {
        let serverUrl = URL(string: "http://\(MasterViewController.SERVER_IP)")
        let credentials = SyncCredentials.usernamePassword(username: "julien3b@gmail.com", password: "toto")
        SyncUser.logIn(with: credentials, server: serverUrl!) {
            user, error in
            if let user = user {
                DispatchQueue.main.async {
                    self.realmConnected(withUser: user)
                }
                
                
            } else if let error = error {
                // handle error
                print("REALM : error \(error)")
            }
            
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
        _ = _subjectManager.addSubject(withTitle: title)
        
        
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 1 {
            return IndexPath(row: 6, section: 0)
        } else if proposedDestinationIndexPath.row == 6 {
            return IndexPath(row: 1, section: 0)
        }else {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _subjectManager.deleteSubject(atIndex: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


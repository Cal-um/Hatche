//
//  entryTableViewController.swift
//  Gert
//
//  Created by Calum Harris on 04/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class entryTableViewController: UITableViewController {
  
  var fetchedResultsController: NSFetchedResultsController!
  var managedObjectContext: NSManagedObjectContext!
  
  var profiles = [Profile]()
  
  func fetchAllProfiles() {
     
    
    
    let fetchRequest = NSFetchRequest(entityName: "Profile")
    
    do {
      if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Profile] {
        profiles = results
      }
    } catch {
      fatalError("There was an error fetching the list of devices!")
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
    //  fetchAllProfiles()

      if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
       managedObjectContext = appDelegate.managedObjectContext
       
  }
      
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchAllProfiles()
    tableView.reloadData()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profiles.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell: UITableViewCell
      
      
      cell = tableView.dequeueReusableCellWithIdentifier("lizardList", forIndexPath: indexPath)
      if let newCell  = cell as? CustomCell {
        let profile = profiles[indexPath.row]
        let age = Time()
        
        let dateOfHatch = profile.dob
        
        
        newCell.nameLabel.text = profile.name
        newCell.speciesLabel.text = profile.species
        
        /*func shortDate() -> String {
          let cat = profile.dob
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateFormat = "dd-MM-yyyy"
          return dateFormatter.stringFromDate(cat!)
        }*/
        newCell.dohLabel.text = age.difference(dateOfHatch!)
        
      }

        return cell
    }

  override func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "addGecko") {
    let destination = segue.destinationViewController as! AddRepViewController
    destination.managedObjectContext = managedObjectContext
    }
    
    if segue.identifier == "ProfileTab" {
      let tabBarController = segue.destinationViewController as! UITabBarController
      let nav = tabBarController.viewControllers![0] as! UINavigationController
      let destinationController = nav.topViewController as! TabBarProfileViewController
      destinationController.managedObjectContext = managedObjectContext
      
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        let selectedProfile = profiles[selectedIndexPath.row]
        destinationController.selectedProfile = selectedProfile
      }
    }
  
  }
  
  @IBAction func cancelTabView(segue:UIStoryboardSegue) {
    
  }

}

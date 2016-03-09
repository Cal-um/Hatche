//
//  entryTableViewController.swift
//  Gert
//
//  Created by Calum Harris on 04/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//
//test
import UIKit
import CoreData

class entryTableViewController: UITableViewController {
  
  var fetchedResultsController: NSFetchedResultsController!
  var managedObjectContext: NSManagedObjectContext!
  
  var profiles = [Profile]()
  let defaultProfilePic = UIImage(named: "egg")
  
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
    saveContext()
    
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
        newCell.dohLabel.text = age.difference(dateOfHatch)
        
        if profile.photoImage != nil {
          newCell.profilePic.image = profile.photoImage
        } else {
          newCell.profilePic.image = defaultProfilePic
        }
        
        newCell.profilePic.layer.borderWidth = 1.0
        newCell.profilePic.layer.masksToBounds = false
        newCell.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        newCell.profilePic.layer.cornerRadius = 13
        newCell.profilePic.layer.cornerRadius = newCell.profilePic.frame.size.height/2
        newCell.profilePic.clipsToBounds = true

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
      let destinationController = tabBarController as! TabBarViewController
      
      destinationController.managedObjectContext = managedObjectContext
      
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        let selectedProfile = profiles[selectedIndexPath.row]
        destinationController.selectedProfile = selectedProfile
      }
    }
  
  }
  
  @IBAction func cancelTabView(segue:UIStoryboardSegue) {
    
  }
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  
  }


}

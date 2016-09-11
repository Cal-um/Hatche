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
  let searchController = UISearchController(searchResultsController: nil)
  let defaultProfilePic = UIImage(named: "egg")
  var profiles = [Profile]()
  var preProfilesSortToAlphabetical = [Profile]() {
    didSet {
      profiles = preProfilesSortToAlphabetical.sort{$0.name.lowercaseString < $1.name.lowercaseString}
    }
  }
  var filteredProfiles = [Profile]()
  
 
  

  override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()

    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
      managedObjectContext = appDelegate.managedObjectContext
    }
    
    //configure search bar
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchAllProfiles()
    tableView.reloadData()
    saveContext()
    
  }
  
  func fetchAllProfiles() {
    
    let fetchRequest = NSFetchRequest(entityName: "Profile")
    
    do {
      if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Profile] {
        preProfilesSortToAlphabetical = results
      }
    } catch {
      fatalError("There was an error fetching the list of devices!")
    }
  }
  
  func filterContentForSearch(searchText: String) {
    filteredProfiles = profiles.filter { profile in profile.name.lowercaseString.containsString(searchText.lowercaseString) || profile.species.lowercaseString.containsString(searchText.lowercaseString)}
    tableView.reloadData()
  }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if searchController.active && searchController.searchBar.text != "" {
        return filteredProfiles.count
      }
        return profiles.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell: UITableViewCell
      
      cell = tableView.dequeueReusableCellWithIdentifier("lizardList", forIndexPath: indexPath)
      
      if let newCell  = cell as? CustomCell {
        let profile: Profile
          
        if searchController.active && searchController.searchBar.text != "" {
          profile = filteredProfiles[indexPath.row]
        } else {
         profile = profiles[indexPath.row]
        }
        
        newCell.nameLabel.text = profile.name
        newCell.speciesLabel.text = profile.species
        
        if profile.photoImage != nil {
          newCell.profilePic.image = profile.photoImage
        } else {
          newCell.profilePic.image = defaultProfilePic
        }
   
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
        let selectedProfile: Profile
        if searchController.active && searchController.searchBar.text != "" {
          selectedProfile = filteredProfiles[selectedIndexPath.row]
        } else {
          selectedProfile = profiles[selectedIndexPath.row]
        }
        destinationController.selectedProfile = selectedProfile
        destinationController.allProfiles = profiles
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

extension entryTableViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearch(searchController.searchBar.text!)
  }
}

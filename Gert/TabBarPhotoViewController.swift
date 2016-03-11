//
//  TabBarPhotoViewController.swift
//  Gert
//
//  Created by Calum Harris on 13/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData
import Social

class TabBarPhotoViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var managedObjectContext: NSManagedObjectContext!
  var sorted: [Photos] = []

  var selectedProfile: Profile! {
    didSet {
     navigationItem.title = selectedProfile.name + "'s photos"
    }
  }
  
  var image: UIImage?
  var picture: Photos!
  var profileImages: Photos?
  var sam: [Photos] = [] {
    didSet {
      sorted = sam.sort({ Int($0.photoID) > Int($1.photoID) })
    }
  }
  
  
  var sharing: Bool = false {
    didSet {
      collectionView?.allowsMultipleSelection = sharing
      collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
      
      sharing ? (navigationItem.title = "Choose Photos") : (navigationItem.title = "\(selectedProfile.name)'s Photos")
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tbvc = self.tabBarController  as! TabBarViewController
    selectedProfile = tbvc.selectedProfile!
    managedObjectContext = tbvc.managedObjectContext!
    
    collectionViewInitialView()
    inputSam()
    
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    inputSam()
    
  }
 
  func inputSam() {
    
    sam = fetchPhotos(selectedProfile)

  }
  
  func fetchPhotos(into: Profile) -> [Photos] {
    var convert: [Photos]
    convert = into.photo!.allObjects as! [Photos]
    
    return convert
  }
  
  
  func returnUIImage(indexPath: NSIndexPath) -> UIImage? {
     picture = sorted[indexPath.row]
    let selectPhoto = picture.photoImage
    return selectPhoto
  }
  
  func collectionViewInitialView() -> UICollectionViewFlowLayout {
    let width = CGRectGetWidth(collectionView!.frame) / 3
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: width)
    
    layout.scrollDirection = .Vertical
    collectionView!.pagingEnabled = false
    navigationController?.hidesBarsOnTap = false
    
    if sharing == true {
      navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "setLayoutForFacebookShare"), animated: true)
      self.navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "facebookShare")], animated: true)
    } else {
      let backImage = UIImage(named: "entryViewIcon")
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style:  UIBarButtonItemStyle.Plain, target: self, action: "unwindToEntryTable")
      self.navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "addPicture"), UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "showShareOptions")], animated: true)
    }
  
    return layout
  }

  func unwindToEntryTable(){
    self.performSegueWithIdentifier("unwindToEntryTable", sender: self)
  }
  
  func collectionViewSingleImageScroll() -> UICollectionViewFlowLayout {
    
    let width = CGRectGetWidth(collectionView!.frame)//320
    let height = CGRectGetHeight(collectionView!.frame)//548
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: (height + 20))
    layout.scrollDirection = .Horizontal
    collectionView!.pagingEnabled = true
    
    navigationController?.hidesBarsOnTap = true
    
    
    let backImage = UIImage(named: "backButton")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style:  UIBarButtonItemStyle.Plain, target: self, action: "fadeBack")
    navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deletePhoto")],animated: true)
    
    
    
    return layout
  }
  
  func deletePhoto() {
    
    let index = self.collectionView!.indexPathsForVisibleItems()
    let selectedPhotoIndexPath = index[0]
    picture = sorted[selectedPhotoIndexPath.row]
    let title = "WARNING"
    let message = "This Action Will Delete The Selected Photo"
    let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    ac.addAction(cancelAction)
    
    let deletePhoto = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
     
      self.picture.removePhotoFile()
      if let picture = self.picture {
      self.managedObjectContext.deleteObject(picture)
      }
      self.saveContext()
      self.inputSam()
      self.collectionView!.deleteItemsAtIndexPaths(index)
      
      if self.sorted.count == 0 {
        self.fadeBack()
      }
    })
    
    ac.addAction(deletePhoto)
    presentViewController(ac, animated: true, completion: nil)
  }
  
  func fadeBack() {
    collectionView!.setCollectionViewLayout(self.collectionViewInitialView(), animated:true)
  }
  
  
  // MARK: - Collection View Data Source
 
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if sorted.count == 0 {
      let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
      emptyLabel.text = "No Photos Added :("
      emptyLabel.textAlignment = NSTextAlignment.Center
      emptyLabel.textColor = UIColor.lightGrayColor()
      collectionView.backgroundView = emptyLabel
      return 0
    } else {
      collectionView.backgroundView = nil
    return sorted.count
    }
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    
    let identifier = "picture"
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CollectionViewCell
    let selectPhoto = returnUIImage(indexPath)
    if let selectPhoto = selectPhoto {
      
      if cell.frame.width == cell.frame.height {
        cell.PhotoImageView.contentMode = UIViewContentMode.ScaleAspectFill
      } else {
        cell.PhotoImageView.contentMode = UIViewContentMode.ScaleAspectFit
      }
    cell.sharing = sharing
    cell.PhotoImageView.image = selectPhoto
    }
    return cell
  }

  

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
   
    if sharing == true {
    //var selectedPhotoArray = collectionView.indexPathsForSelectedItems()
    //selectedPhotos.append(returnUIImage(indexPath)!)
    //print(selectedPhotos)
    } else  if sharing == false {
      collectionView.reloadData()
      collectionView.setCollectionViewLayout(collectionViewSingleImageScroll(), animated:true)
      collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .CenteredHorizontally)
      }
    }
  
  // MARK: - Camera and Saving Photo
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
        print("save Successful")
      } catch {
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }

  
  func savePhoto() {
  profileImages = NSEntityDescription.insertNewObjectForEntityForName("Photos",inManagedObjectContext: managedObjectContext) as? Photos
    
    if let  profileImages = profileImages, owner = selectedProfile  {
  
  
      profileImages.photoID = Photos.nextPhotoID()
  
      profileImages.owner = owner
      print(applicationDocumentsDirectory)
    
    
    if let image = image {
        if let data = UIImageJPEGRepresentation(image, 0.5) {
        
      do {
        try data.writeToFile(profileImages.photoPath, options: .DataWritingAtomic)
      } catch {
        print("Error Writing File: \(error)")
      }
      }
  
      

      do {
        try managedObjectContext.save()
        print(profileImages)
      } catch {
      fatalError("Failure to save context: \(error)")
      }
      }else {
      print("error enter all info")
      }
    }
      }
  
  
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .Camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = false
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    dismissViewControllerAnimated(true, completion: nil)
    
    image = info[UIImagePickerControllerOriginalImage] as? UIImage
    savePhoto()
    saveContext()
    inputSam()
    
    
    var paths = [NSIndexPath]()
    paths.append(NSIndexPath(forRow: 0, inSection: 0))
    delay(0.5){
      UIView.animateWithDuration(1.0, animations: { () -> Void in self.collectionView!.insertItemsAtIndexPaths(paths) }, completion: nil)
    }
    
   
    }
  
  func delay(delay: Double, closure: ()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(),
      closure
    )
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
      dismissViewControllerAnimated(true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = false
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func showPhotoMenu() {
    let alertController = UIAlertController(title: nil, message: nil,
    preferredStyle: .ActionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
      let takePhotoAction = UIAlertAction(title: "Take Photo",style: .Default, handler: { _ in self.takePhotoWithCamera()})
    alertController.addAction(takePhotoAction)
      let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: {_ in self.choosePhotoFromLibrary()})
    alertController.addAction(chooseFromLibraryAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  
  func pickPhoto() {
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      showPhotoMenu()
    } else {
      choosePhotoFromLibrary()
    }
  }
  
  func addPicture () {
    
    pickPhoto()
  }
  
  
  
  //Share Images on Social
  
  func showAlertMessage(message: String!) {
    let alertController = UIAlertController(title: "Hatche", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  
  
  
  
   func showShareOptions() {
    
    let ac = UIAlertController(title: "", message: "Share Photos", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    
    // Configure a new action to share on Facebook.
    
    let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      self.setLayoutForFacebookShare()
      
    }
    
    
    let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      
    }
    
    
    ac.addAction(facebookPostAction)
    ac.addAction(dismissAction)
    
    presentViewController(ac, animated: true, completion: nil)
    
  }
  
  func facebookShare() {
    
   
    
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
      let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
      
      facebookComposeVC.setInitialText(self.selectedProfile.name + " via Hatche for iPhone")
      
 

      
      let arrayPhotos = collectionView!.indexPathsForSelectedItems()! as [NSIndexPath]
      
      
      for i in arrayPhotos {
        let photo = returnUIImage(i)
        facebookComposeVC.addImage(photo)
      }
      setLayoutForFacebookShare()
     
      self.presentViewController(facebookComposeVC, animated: true, completion: nil)
    }
    else {
      self.showAlertMessage("Device not connected to a Facebook account")
    }
  }
  
  func setLayoutForFacebookShare() {
   sharing = !sharing
   self.collectionView!.reloadData()
   collectionViewInitialView()
  }
  
  

}
  
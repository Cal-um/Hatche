//
//  TabBarPhotoViewController.swift
//  Gert
//
//  Created by Calum Harris on 13/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class TabBarPhotoViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var managedObjectContext: NSManagedObjectContext!
  
  var selectedProfile: Profile!
  var image: UIImage?
  var profileImages: Photos?
   var sam: [Photos] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tbvc = self.tabBarController  as! TabBarViewController
    selectedProfile = tbvc.selectedProfile!
    managedObjectContext = tbvc.managedObjectContext!
    
    
    let width = CGRectGetWidth(collectionView!.frame) / 3
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: width)
    
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    
    sam = fetchPhotos(selectedProfile)
    print(sam.count)
    collectionView?.reloadData()
  }
 
 
  func fetchPhotos(into: Profile) -> [Photos] {
    var convert: [Photos]
    convert = into.photo!.allObjects as! [Photos]
    
    return convert
  }


  
  // MARK: - Collection View Data Source
 
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sam.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let identifier = "picture"
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CollectionViewCell
    let picture = sam[indexPath.row]
    let selectPhoto = picture.photoImage
    if let selectPhoto = selectPhoto {
    
    cell.PhotoImageView.image = selectPhoto
    }
    
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "photoView" {
      if let selectedIndexPath = collectionView!.indexPathsForSelectedItems()?.first {
        let picture = sam[selectedIndexPath.row]
        let selectPhoto = picture.photoImage
        let destinationVC =  segue.destinationViewController as! PhotoView
        destinationVC.selectPhoto = selectPhoto
      }
    
    }
  }

  
  
  // MARK: - Camera and Saving Photo
  
  
  
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
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    dismissViewControllerAnimated(true, completion: nil)
    
     image = info[UIImagePickerControllerEditedImage] as? UIImage
     savePhoto()
    }
  
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
      dismissViewControllerAnimated(true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
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
  
  @IBAction func addPicture (sender: UIBarButtonItem) {
    
    pickPhoto()
    
    
  }

  

  

}
  
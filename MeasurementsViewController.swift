//
//  MeasurementsViewController.swift
//  Gert
//
//  Created by Calum Harris on 29/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import Charts
import UIKit
import CoreData

class MeasurementsViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  var selectedProfile: Profile! {
    didSet {
      navigationItem.title = selectedProfile.name + "'s Weight"
    }
  }

  var managedObjectContext: NSManagedObjectContext!
  var weightClass: [Weight]!
  var preSort: [Weight]! {
    didSet {
      weightClass = preSort.sort({ $0.wDate.compare($1.wDate) == .OrderedAscending })
    }
  }
  var weight: [Double]!
  var months: [String]!
  
  
  
    @IBOutlet weak var lineChartView: LineChartView!
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let backImage = UIImage(named: "entryViewIcon")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style:  UIBarButtonItemStyle.Plain, target: self, action: "unwindToEntryTable")
    
    weightTableView.delegate = self
    weightTableView.dataSource = self
    
    //Load selectedProfile data from TabBarViewController
    let tbvc = self.tabBarController  as! TabBarViewController
    selectedProfile = tbvc.selectedProfile!
    managedObjectContext = tbvc.managedObjectContext!

  }
  
  
  //Set chart Data
  
  override func viewDidAppear(animated: Bool) {
    lineChartView.delegate = self
    lineChartView.descriptionTextColor = UIColor.whiteColor()
    self.lineChartView.setVisibleXRangeMaximum(5.0)

    self.lineChartView.moveViewToX(months.count - 6)
  }
  
   override func viewWillAppear(animated: Bool) {
    
    preSort = fetchWeights(selectedProfile)
    months = weighInDateArray(weightClass)
    weight = setWeightArray(weightClass)
    setChart(months, values: weight)
    weightTableView.reloadData()
    
  }
  
  
  func fetchWeights(into: Profile) -> [Weight] {
    var convert: [Weight]
    convert = into.profileWeight!.allObjects as! [Weight]
    
    return convert
  }
  
  
  
  
  func setChart(dataPoints: [String], values: [Double]) {
   
    //remove duplicate months
    let duplicateIndex = recordDuplicates(dataPoints)
    let monthArray: [String] = deleteDuplicateMonths(dataPoints, toDelete: duplicateIndex)
    let weightArray: [Double] = deleteDuplicateWeights(values, toDelete: duplicateIndex)
    
    //configure graph
    lineChartView.noDataText = "More Data Required"
    lineChartView.noDataTextDescription = "Minimum Two Month Input Required For Chart Population"
    
    var yVals1: [ChartDataEntry] = [ChartDataEntry]()
    for i in 0..<monthArray.count {
        yVals1.append(ChartDataEntry(value: weightArray[i], xIndex: i))
      
      let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "grams")
      set1.axisDependency = .Left
      set1.setColor(UIColor(red: 0, green: 122, blue: 255, alpha: 1))
      set1.setCircleColor(UIColor.blueColor())
      set1.fillAlpha = 65/255.0
      set1.fillColor = UIColor.blueColor()
      set1.highlightColor = UIColor.blueColor()
      set1.drawCircleHoleEnabled = true
      
      var dataSets: [LineChartDataSet] = [LineChartDataSet]()
      dataSets.append(set1)
      
      let data: LineChartData = LineChartData(xVals: monthArray, dataSets: dataSets)
      data.setValueTextColor(UIColor.whiteColor())
      
      lineChartView.data = data
    }
  }
  
  
  func recordDuplicates(array: [String]) -> [Int] {
    var encountered = Set<String>()
    var toDeleteIndex: [Int] = []
    var index = 0
    for value in array {
      if encountered.contains(value) {
        toDeleteIndex.append(index)
        index += 1
      }
      else {
        encountered.insert(value)
        index += 1
      }
    }
    return toDeleteIndex
  }
  
  func deleteDuplicateMonths(inputArray: [String], toDelete: [Int]) -> [String] {
    var outputArray = inputArray
    var r = 0
    for i in toDelete {
      outputArray.removeAtIndex((i - r))
      while r < 2 {
        r += 1
      }
    }
    return outputArray
    
  }
  
  func deleteDuplicateWeights(inputArray: [Double], toDelete: [Int]) -> [Double] {
    var outputArray = inputArray
    var r = 0
    for i in toDelete {
      outputArray.removeAtIndex((i - r))
      while r < 2 {
        r += 1
      }
    }
    return outputArray
    
  }

  //tableView data source
  
  
  @IBOutlet weak var weightTableView: UITableView!
  
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return weightClass.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Weight : Date"
  }
  
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("weights", forIndexPath: indexPath)
    
    let items = tableViewStrings(weightClass, setWeightArray: weight)
    
    let item = items[indexPath.row]
    print(item)
    print(weight.count)
    cell.textLabel!.text = item
    
    return cell
  }
  
  
  
  func setWeightArray(input: [Weight]) -> [Double] {
    var holder: [Double] = []
    for i in input {
      let convWeight = Double(round(100 * Double((i.recodedWeight))) / 100)
      holder.append(convWeight)
    }
    return holder
  }
  
  func weighInDateArray(input: [Weight]) -> [String] {
    
    var holder: [String] = []
    let monthYearFormatter = NSDateFormatter()
    monthYearFormatter.dateFormat = "MMM, YY"
    for i in input {
      let dateString = monthYearFormatter.stringFromDate(i.wDate)
      holder.append(dateString)
    }
    return holder
  }
  
  func tableViewStrings(weightClass: [Weight], setWeightArray: [Double]) -> [String] {
    var stringHolder: [String] = []
    let dateToStringFormatter = NSDateFormatter()
    dateToStringFormatter.dateStyle = .ShortStyle
    
    for i in 0..<weightClass.count {
      let date = weightClass[i]
      let dateString = dateToStringFormatter.stringFromDate(date.wDate)
      let weight = setWeightArray[i]
      let weightString = String(weight)
    
      stringHolder.append(weightString + "g" + " : " + dateString)
    }
  return stringHolder.reverse()
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "addItem") {
      if let dest = segue.destinationViewController as? WeightDetailViewController {
        dest.managedObjectContext = managedObjectContext
        dest.selectedProfile = selectedProfile
        dest.editWeight = false
      }
    }
    if (segue.identifier == "editItem") {
      if let dest = segue.destinationViewController as? WeightDetailViewController {
        dest.managedObjectContext = managedObjectContext
        dest.selectedProfile = selectedProfile
        dest.editWeight = true
    }
  }
    
  }
  
  
  override func viewWillDisappear(animated: Bool) {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }
  
  func unwindToEntryTable(){
    self.performSegueWithIdentifier("unwindToEntryTable", sender: self)
  }
  
  
  
  
}
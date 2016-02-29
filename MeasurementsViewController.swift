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
  
  
  var months: [String]!
  let weight = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, 8.0, 9.0]
  
  
  
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
    
    
    //Set chart Data
    
    lineChartView.delegate = self
    lineChartView.descriptionTextColor = UIColor.whiteColor()
    
    months = ["Jan, 05", "Feb, 05", "Mar 05", "Apr 05", "May 05", "Jun 05", "Jul 05", "Aug 05", "Sep, 05", "Oct, 05", "Nov 05", "Dec 05", "Jan 06", "Feb, 06,"]
    
    setChart(months, values: weight)
    
    self.lineChartView.setVisibleXRangeMaximum(5.0)
    
    print(months.count)
  }
  
  override func viewDidAppear(animated: Bool) {
    //Set starting view for graph
    self.lineChartView.moveViewToX(months.count - 6)
  }
  
  
  func setChart(dataPoints: [String], values: [Double]) {
    lineChartView.noDataText = "More Data Required"
    lineChartView.noDataTextDescription = "Minimum Two Month Input Required For Chart Population"
    
    var yVals1: [ChartDataEntry] = [ChartDataEntry]()
    for i in 0..<months.count {
        yVals1.append(ChartDataEntry(value: weight[i], xIndex: i))
      
      let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Weight in Grams")
      set1.axisDependency = .Left
      set1.setColor(UIColor(red: 0, green: 122, blue: 255, alpha: 1))
      set1.setCircleColor(UIColor.blueColor())
      set1.fillAlpha = 65/255.0
      set1.fillColor = UIColor.blueColor()
      set1.highlightColor = UIColor.blueColor()
      set1.drawCircleHoleEnabled = true
      
      
      
      var dataSets: [LineChartDataSet] = [LineChartDataSet]()
      dataSets.append(set1)
      
      let data: LineChartData = LineChartData(xVals: dataPoints, dataSets: dataSets)
      data.setValueTextColor(UIColor.whiteColor())
      
      lineChartView.data = data
    }
  }
  
  
  //tableView data source
  
  
  @IBOutlet weak var weightTableView: UITableView!
  
  
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 1
  }
  
  
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    
    cell = tableView.dequeueReusableCellWithIdentifier("weights", forIndexPath: indexPath)
        return cell
  }
  
  
  func unwindToEntryTable(){
    self.performSegueWithIdentifier("unwindToEntryTable", sender: self)
  }
  
  
  
  
}
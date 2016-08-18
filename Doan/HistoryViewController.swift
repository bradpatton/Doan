//
//  HistoryViewController.swift
//  Doan
//
//  Created by Bradley Patton on 7/30/16.
//  Copyright © 2016 EtherLabs. All rights reserved.
//

import UIKit
import CoreData


class HistoryViewController: UITableViewController {
    
    
    var meditations = [NSManagedObject]()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillload")
        
        
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequestMeditations = NSFetchRequest(entityName: "Meditation")
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequestMeditations.sortDescriptors = [sort]
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequestMeditations)
            meditations = results as! [NSManagedObject]
            var totalTime: Int = 0
            for i in meditations {
                let meditationTime = i.valueForKey("totalTime") as! Int
                totalTime += meditationTime
                let (h,m,s) = secondsToHoursMinutesSeconds(totalTime)
                
                let timeLabelText = String(format: "%02d", h) + " : " + String(format: "%02d", m) + " : " + String(format: "%02d", s)
                
                navigationBar.topItem!.title = "Total :  \(timeLabelText)"
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() { super.viewDidLoad() }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return meditations.count
        
    }
    
    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        let meditation = meditations[indexPath.row]
        
        cell.backgroundLabel.text = meditation.valueForKey("backgroundSound") as? String
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        if meditation.valueForKey("date") != nil {
            
            let dateString = formatter.stringFromDate(meditation.valueForKey("date") as! NSDate)
            cell.dateLabel.text = dateString
            
        }
        
        
        let (h,m,s) = secondsToHoursMinutesSeconds(meditation.valueForKey("totalTime") as! Int)
        
        let timeLabelText = String(format: "%02d", h) + " : " + String(format: "%02d", m) + " : " + String(format: "%02d", s)

        
        cell.timeLabel.text = timeLabelText
        return cell
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}

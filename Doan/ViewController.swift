//
//  ViewController.swift
//  Doan
//
//  Created by Joshua X on 2/20/16.
//  Copyright © 2016 Bradley Patton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var timePickerView: AKPickerView!
    
    let titles = ["Rain", "Fire", "Forest", "Ocean", "Silent"]
    var time = [String]()
    var scene = String()
    var totalSeconds = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        timeArray(120)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.maskDisabled = false
        
        self.pickerView.reloadData()
        self.pickerView.selectItem(2, animated: false)
        
        self.timePickerView.delegate = self
        self.timePickerView.dataSource = self
        
        self.timePickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.timePickerView.highlightedFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.timePickerView.pickerViewStyle = .Wheel
        self.timePickerView.maskDisabled = false
        
        self.timePickerView.reloadData()
        self.timePickerView.selectItem(2, animated: false)
    
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        
        if(pickerView.tag == 2){
            return self.titles.count
        }else{
            return self.time.count
        }
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        
        if(pickerView.tag == 2){
            
            scene = self.titles[item]
            return self.titles[item]
            
        }else {
            
            self.totalSeconds = itemToSeconds(self.time[item])
            return self.time[item]
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toMeditate"){
            
            let DestinationViewController: MeditateView = segue.destinationViewController as! MeditateView
        
            DestinationViewController.scene = scene
            DestinationViewController.totalSeconds = totalSeconds
            
        }
    }
    
    func itemToSeconds(str: String) -> Int {
        
        let index = str.endIndex.advancedBy(-4)
        
        let subStr = str.substringToIndex(index)
        
        return (Int(subStr)! * 60)
        
    }
    
    func timeArray(numberOfMinutes: Int) {
        
        for var index = 5;index < numberOfMinutes+1; index = index + 5 {
            
            time.append(String(index) + " min")
            
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}


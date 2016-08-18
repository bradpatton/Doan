//
//  MeditateView.swift
//  Doan
//
//  Created by Joshua X on 2/20/16.
//  Copyright © 2016 Bradley Patton. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData
import Social

class MeditateView: UIViewController {
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var ScenceImage: UIImageView!
    @IBOutlet weak var clockLabel: UILabel!
    
    var scene = String()
    
    var totalSeconds = Int()
    var masterTime = Int()
    var length = Int()
    
    var backgroundMusic : AVAudioPlayer?
    var finishedSound : AVAudioPlayer?
    
    var timer = NSTimer()
    
    var session = AVAudioSession()
    
    var pause = false
    
    var meditation = NSManagedObject()
    
    
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
        } catch {
            
            print("Session Failed")
            
        }
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
            
        } catch {
            
            print("Player not available")
            
        }
        
        return audioPlayer
        
    }
   
    override func viewDidLoad() {
        
        masterTime = totalSeconds
        
        switch self.scene {
        
        case "Fire":
            if let backgroundMusic = self.setupAudioPlayerWithFile("fire", type:"wav") {
                self.backgroundMusic = backgroundMusic
            }
        case "Rain":
                if let backgroundMusic = self.setupAudioPlayerWithFile("rain", type:"wav") {
                    self.backgroundMusic = backgroundMusic
                }
        case "Ocean":
            if let backgroundMusic = self.setupAudioPlayerWithFile("ocean", type:"wav") {
                self.backgroundMusic = backgroundMusic
            }

        case "Forest":
            if let backgroundMusic = self.setupAudioPlayerWithFile("forrest", type:"wav") {
                self.backgroundMusic = backgroundMusic
            }
        default: break
            
        }
        
        if let finishedSound = self.setupAudioPlayerWithFile("Temple-bell", type:"wav") {
            self.finishedSound = finishedSound
        }
        
        backgroundMusic?.numberOfLoops = -1
        
        setupTime()
        
        clockLabel.hidden = false
        
        backgroundMusic?.play()
        finishedSound?.play()
        
    }
    
    func setupTime() {
        
        length = totalSeconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MeditateView.clock), userInfo: nil, repeats: true)
        
    }
    
    func clock() {
        if pause == false {
      
            let (h,m,s) = secondsToHoursMinutesSeconds(totalSeconds)
        
            clockLabel.text = String(format: "%02d", h) + " : " + String(format: "%02d", m) + " : " + String(format: "%02d", s)
        
            if(totalSeconds == 0 ){
                
                timer.invalidate()
                finishedSound?.play()
            
            }
        
            totalSeconds = totalSeconds - 1
        }
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        masterTime = masterTime - totalSeconds
        saveSession()
        backgroundMusic?.stop()

    }
    
    func facebookPost(){
        
        let smController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        smController.setInitialText("#DoanMeditationTimer")
        smController.addURL(NSURL(string: "https://goo.gl/6iqPt7"))
        smController.completionHandler = { result -> Void in
            self.performSegueWithIdentifier("unwindToMenu", sender: self)
        }
        self.presentViewController(smController, animated: true, completion: nil)
    
    }
    
    func twitterPost(){
        
        let smController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        smController.setInitialText("I just finished meditating with Doan Meditation Timer! #DoanTime https://goo.gl/6iqPt7")
        smController.completionHandler = { result -> Void in
            self.performSegueWithIdentifier("unwindToMenu", sender: self)
        }
        self.presentViewController(smController, animated: true, completion: nil)

        
    }
    
    func saveSession() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
    
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Meditation", inManagedObjectContext:managedContext)
     
        let meditation = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        meditation.setValue(scene, forKey: "backgroundSound")
        let currentDate = NSDate()
        meditation.setValue(currentDate, forKey: "date")
   
        meditation.setValue(masterTime, forKey: "totalTime")
        
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func back(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Doan", message: "Would you like to end your session?", preferredStyle: .ActionSheet)
        //alertController.popoverPresentationController!.sourceView = self.view;
        //alertController.popoverPresentationController!.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0 - 105, self.view.bounds.size.height / 2.0 + 70, 1.0, 1.0);
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender as! UIView
            popoverController.sourceRect = sender.bounds
        }
        alertController.addAction(UIAlertAction(title: "Facebook Post", style: UIAlertActionStyle.Default){UIAlertAction in self.facebookPost()})
        alertController.addAction(UIAlertAction(title: "Twitter Post", style: UIAlertActionStyle.Default){UIAlertAction in self.twitterPost()})
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default){UIAlertAction in self.performSegueWithIdentifier("unwindToMenu", sender: self)})
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func pause(sender: UIButton!) {
        
        if pause {
            let attrStr = NSAttributedString(string: "Pause")
            sender.setAttributedTitle(attrStr, forState: .Normal)
            pause = false
            
           
        }else {
            
            let attrStr = NSAttributedString(string: "Resume")
            sender.setAttributedTitle(attrStr, forState: .Normal)
            pause = true
            
        }
    }
    
    @IBAction func unwindToMeditate(segue: UIStoryboardSegue) {}
    
}
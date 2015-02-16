//
//  ExcerciseRepsViewController.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/9/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion

class ExcerciseRepsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var repsTableView: UITableView!
    
    var targetReps : [Int] = [2, 1, 3]
    
    var completedReps : [Int] = [0, 0, 0]
    
    var paused : Bool = false
    
    var initialAction : Bool = false
    
    var motionManager : CMMotionManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        repsTableView.layer.borderWidth = 2.0
        
        var gesture = UITapGestureRecognizer(target: self, action: "didDoubleClickTable")
        gesture.numberOfTapsRequired = 2
        
        repsTableView.addGestureRecognizer(gesture)
        
        motionManager = CMMotionManager()
        
        motionManager!.deviceMotionUpdateInterval = 0.2
        
        motionManager!.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXArbitraryCorrectedZVertical)
        
        sleep(1)
    }
    
    override func viewDidAppear(animated: Bool) {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("checkRep"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetReps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = repsTableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if(targetReps[indexPath.row] <= completedReps[indexPath.row]){
            cell.textLabel?.text = "\(targetReps[indexPath.row])\t(\(targetReps[indexPath.row]) completed)"
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.textLabel?.text = "\(targetReps[indexPath.row])\t(\(completedReps[indexPath.row]) completed)"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showEditRepsDialog(indexPath.row)
    }
    
    func showEditRepsDialog(row: Int) {
        let alertController = UIAlertController(title: "Edit number of Reps", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = "\(self.targetReps[row])"
            textField.placeholder = "Number of Reps"
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
        }
        let defaultAction = UIAlertAction(title: "Update", style: .Default) {
            (action) -> Void in
            let repsTextField = alertController.textFields![0] as UITextField
            
            let reps = repsTextField.text.toInt()
            
            if reps != nil {
                self.targetReps[row] = reps!
            }
            
            self.repsTableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func checkRep(){
        if paused{
            return
        }
        
        var accel = motionManager!.deviceMotion.userAcceleration
        
        let target = 0.3
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        let horizontal = (orientation == .LandscapeLeft || orientation == .LandscapeRight) ? true : false
        
        if horizontal {
            if initialAction {
                if accel.x < -1 * target{
                    doRep(self)
                    initialAction = false
                }
            } else {
                if accel.x > target {
                    initialAction = true
                }
            }
        } else {
            if initialAction {
                if accel.y > target {
                    doRep(self)
                    initialAction = false
                }
            } else {
                if accel.y < -1 * target{
                    initialAction = true
                }
            }
        }
    }

    @IBAction func doRep(sender: AnyObject) {
        var i = 0
        
        while i < self.targetReps.count{
            self.completedReps[i]++

            self.repsTableView.reloadData()
            
            if self.targetReps[i] > self.completedReps[i]{
                return
            } else if self.targetReps[i] == self.completedReps[i]{
                playSound()
                displayBreakDialog(i)
                return
            }
            
            i++
        }
    }
    
    func displayBreakDialog(set: Int){
        self.paused = true
        var message = "Break Time!"
        if set+1 == self.targetReps.count{
            message = "You Finished All of the Reps!"
        }
        let alertController = UIAlertController(title: "Completed set \(set+1)", message: message, preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "Done", style: .Default) {
            (action) -> Void in
            self.paused = false
        }
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func playSound(){
        var soundID: SystemSoundID = 0
        var mainBundle: CFBundleRef = CFBundleGetMainBundle()
        if let ref: CFURLRef = CFBundleCopyResourceURL(mainBundle, "beep-03", "wav", nil) {
            AudioServicesCreateSystemSoundID(ref, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    @IBAction func pressedResetButton(sender: AnyObject) {
        resetReps()
    }
    
    func resetReps(){
        self.targetReps = [5, 5, 5]
        self.completedReps = [0, 0, 0]
        self.repsTableView.reloadData()
    }
    
    func didDoubleClickTable(){
        self.targetReps.append(5)
        self.completedReps.append(0)
        self.repsTableView.reloadData()
    }
}

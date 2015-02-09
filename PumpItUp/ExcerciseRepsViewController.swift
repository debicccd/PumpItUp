//
//  ExcerciseRepsViewController.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/9/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit

class ExcerciseRepsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var repsTableView: UITableView!
    
    var targetReps : [Int] = [20, 10, 20]
    
    var completedReps : [Int] = [0, 0, 0]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repsTableView.layer.borderWidth = 2.0

        // Do any additional setup after loading the view.
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
        
        cell.textLabel?.text = "\(targetReps[indexPath.row])"
        
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
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
        }
        let defaultAction = UIAlertAction(title: "Update", style: .Default) {
            (action) -> Void in
            let repsTextField = alertController.textFields![0] as UITextField
            
            let reps = repsTextField.text.toInt()
            
            self.targetReps[row] = reps!
            
            self.repsTableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    
}

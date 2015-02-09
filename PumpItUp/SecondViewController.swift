//
//  SecondViewController.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/9/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var pumpSpeedCostLabel: UILabel!
    @IBOutlet weak var pumpAmmountCostLabel: UILabel!
    @IBOutlet weak var pumpStorageCostLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedPumpSpeedUpgrade(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        var pumpIncome = delegate.pumpIncome
        
        let before = pumpIncome!.powerFluidRate
        let currentLevel = pumpIncome!.rateLevel
        pumpIncome!.levelUpRateLevel()
        let after = pumpIncome!.powerFluidRate

        let message = "Level \(currentLevel) -> \(currentLevel + 1)\n\n" +
            "Increases from \(before) to \(after)\n\n" +
        "Costs \(100 * (currentLevel + 1))ml"
        
        let alertController = UIAlertController(title: "Pump Speed", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
            println("You pressed Cancel")
        }
        let defaultAction = UIAlertAction(title: "Update", style: .Default) {
            (action) -> Void in
            println("You pressed Create Quote")
            
            delegate.pumpIncome = pumpIncome
            self.updateViews()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func updateViews(){
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        var pumpIncome = delegate.pumpIncome
        
        
        
        pumpSpeedCostLabel.text = "Cost: \(100 * (pumpIncome!.rateLevel + 1))ml"
        pumpAmmountCostLabel.text = "Cost: \(100 * (pumpIncome!.ammountLevel + 1))ml"
        pumpStorageCostLabel.text = "Cost: \(100 * (pumpIncome!.storageLevel + 1))ml"
    }


}


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
        let after = pumpIncome!.nextLevelPowerFluidRate
        let cost = (10 * (currentLevel + 1))

        let message = "Level \(currentLevel) -> \(currentLevel + 1)\n\n" +
            "Increases from \(before) to \(after)\n\n" +
        "Costs \(cost)ml"
        
        let alertController = UIAlertController(title: "Pump Speed", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
        }
        let defaultAction = UIAlertAction(title: "Upgrade", style: .Default) {
            (action) -> Void in
            
            if(pumpIncome!.canAfford(cost)){
                pumpIncome!.subtractPowerFluid(cost)
                pumpIncome!.levelUpRateLevel()
                self.updateViews()
            } else {
                self.showErrorDialog()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func pressedPumpAmmountUpgrade(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        var pumpIncome = delegate.pumpIncome
        
        let before = pumpIncome!.powerFluidAmmountString
        let currentLevel = pumpIncome!.ammountLevel
        let after = pumpIncome!.nextLevelPowerFluidAmmountString
        let cost = (10 * (currentLevel + 1))
        
        let message = "Level \(currentLevel) -> \(currentLevel + 1)\n\n" +
            "Increases from \(before)ml to \(after)ml\n\n" +
        "Costs \(cost)ml"
        
        let alertController = UIAlertController(title: "Pump Ammount", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
        }
        let defaultAction = UIAlertAction(title: "Upgrade", style: .Default) {
            (action) -> Void in
            
            if(pumpIncome!.canAfford(cost)){
                pumpIncome!.subtractPowerFluid(cost)
                pumpIncome!.levelUpAmmount()
                self.updateViews()
            } else {
                self.showErrorDialog()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func pressedPumpStorageAmmountUpgrade(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        var pumpIncome = delegate.pumpIncome
        
        let before = pumpIncome!.powerFluidStorageString
        let currentLevel = pumpIncome!.storageLevel
        let after = pumpIncome!.nextLevelMaxPowerFluidStorageString
        let cost = (10 * (currentLevel + 1))
        
        let message = "Level \(currentLevel) -> \(currentLevel + 1)\n\n" +
            "Increases from \(before)ml to \(after)ml\n\n" +
        "Costs \(cost)ml"
        
        let alertController = UIAlertController(title: "Pump Storage", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) -> Void in
        }
        let defaultAction = UIAlertAction(title: "Upgrade", style: .Default) {
            (action) -> Void in
            
            if(pumpIncome!.canAfford(cost)){
                pumpIncome!.subtractPowerFluid(cost)
               pumpIncome!.levelUpStorageLevel()
                self.updateViews()
            } else {
                self.showErrorDialog()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showErrorDialog(){
        let message = "Not enough Power Fluid"
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Default) {
            (action) -> Void in
        }
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func updateViews(){
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        var pumpIncome = delegate.pumpIncome
        
        
        
        pumpSpeedCostLabel.text = "Cost: \(10 * (pumpIncome!.rateLevel + 1))ml"
        pumpAmmountCostLabel.text = "Cost: \(10 * (pumpIncome!.ammountLevel + 1))ml"
        pumpStorageCostLabel.text = "Cost: \(10 * (pumpIncome!.storageLevel + 1))ml"
    }


}


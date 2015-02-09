//
//  FirstViewController.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/9/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit

let UserDefaultsPumpIncomeKey = "PumpIncome"

class FirstViewController: UIViewController {

    @IBOutlet weak var pumpRateLabel: UILabel!
    @IBOutlet weak var pumpIncomeLabel: UILabel!
    
    var backgroundQueue = NSOperationQueue()
    var pumpIncome : PumpIncome?
    var timer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsPumpIncomeKey) as? NSData {
            pumpIncome = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? PumpIncome
        } else {
            pumpIncome = PumpIncome()
        }
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.pumpIncome = self.pumpIncome
        
        self.pumpIncomeLabel.text = "Current Power Fluid: \(pumpIncome!)ml/\(pumpIncome!.maxPowerFluidStorage)ml"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(pumpIncome!.powerFluidRate, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        self.updateView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.pumpIncome = delegate.pumpIncome
        self.updateView()
        self.updateTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(){
        self.pumpIncome!.increment()
        
        self.updateView()
        
        savePumpIncome()
    }
    
    func updateView(){
        let pumpText = String(format: "Pumping \(pumpIncome!.powerFluidAmmountString)ml per %.2f seconds", self.pumpIncome!.powerFluidRate)
        self.pumpRateLabel.text = pumpText
        self.pumpIncomeLabel.text = "Current Power Fluid: \(pumpIncome!)ml/\(pumpIncome!.powerFluidStorageString)ml"
    }
    
    func savePumpIncome(){
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.pumpIncome = self.pumpIncome
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(self.pumpIncome!)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: UserDefaultsPumpIncomeKey)
        defaults.synchronize()
    }
    
    func updateTimer(){
        timer?.invalidate()
        timer = nil
        
        timer = NSTimer.scheduledTimerWithTimeInterval(pumpIncome!.powerFluidRate, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
}


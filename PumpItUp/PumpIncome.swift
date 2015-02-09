//
//  PumpIncome.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/9/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit

let POWER_FLUID_KEY = "PowerFluid"
let POWER_FLUID_RATE_KEY = "PowerFluidRate"
let MAX_POWER_FLUID_STORAGE = "MaxPowerFluidStorage"
let POWER_FLUID_AMMOUNT_KEY = "PowerFluidAmmount"

class PumpIncome: NSObject, Printable, NSCoding{
    
    var powerFluid = 1800
    var rateLevel = 0
    var storageLevel = 0
    var ammountLevel = 0
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.powerFluid = aDecoder.decodeIntegerForKey(POWER_FLUID_KEY)
        self.rateLevel = aDecoder.decodeIntegerForKey(POWER_FLUID_RATE_KEY)
        self.storageLevel = aDecoder.decodeIntegerForKey(MAX_POWER_FLUID_STORAGE)
        self.ammountLevel = aDecoder.decodeIntegerForKey(POWER_FLUID_AMMOUNT_KEY)
    }
    
    override init(){
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(powerFluid, forKey: POWER_FLUID_KEY)
        aCoder.encodeInteger(rateLevel, forKey: POWER_FLUID_RATE_KEY)
        aCoder.encodeInteger(storageLevel, forKey: MAX_POWER_FLUID_STORAGE)
        aCoder.encodeInteger(ammountLevel, forKey: POWER_FLUID_AMMOUNT_KEY)
    }
    
    required init(powerFluid:Int, powerFluidRate:Int, maxPowerFluidStorage:Int, ammountLevel:Int) {
        self.powerFluid = powerFluid
        self.rateLevel = powerFluidRate
        self.storageLevel = maxPowerFluidStorage
        self.ammountLevel = ammountLevel
        super.init()
    }
    
    var powerFluidRate : Double{
        return 5.0 / Double(self.rateLevel + 1)
    }
    
    var maxPowerFluidStorage : Int{
        return 1000 * (Int(exp(Double(self.storageLevel + 1))))
    }
    
    var powerFluidAmmount : Int{
        return 10 * (Int(exp(Double(self.ammountLevel + 1))))
    }
    
    var nextLevelPowerFluidRate : Double{
        return 5.0 / Double(self.rateLevel + 2)
    }
    
    var nextLevelMaxPowerFluidStorage : Int{
        return 1000 * (Int(exp(Double(self.storageLevel + 2))))
    }
    
    var nextLevelPowerFluidAmmount : Int{
        return 10 * (Int(exp(Double(self.ammountLevel + 2))))
    }
    
    var powerFluidAmmountString : String{
        var returnString = powerFluidAmmount.description as NSString
        let len = returnString.length
        
        if(len == 0){
            return "0"
        }
        if(len == 1){
            return "0.0" + returnString
        }
        if(len == 2){
            return "0." + returnString
        }
        
        returnString = returnString.substringWithRange(NSRange(location: 0, length: len-2)) + "." + returnString.substringWithRange(NSRange(location: len - 2, length: 2))
        
        return returnString
    }
    
    var powerFluidStorageString : String{
        var returnString = maxPowerFluidStorage.description as NSString
        let len = returnString.length
        
        if(len == 0){
            return "0"
        }
        if(len == 1){
            return "0.0" + returnString
        }
        if(len == 2){
            return "0." + returnString
        }
        
        returnString = returnString.substringWithRange(NSRange(location: 0, length: len-2)) + "." + returnString.substringWithRange(NSRange(location: len - 2, length: 2))
        
        return returnString
    }
    
    
    var nextLevelPowerFluidAmmountString : String{
        var returnString = nextLevelPowerFluidAmmount.description as NSString
        let len = returnString.length
        
        if(len == 0){
            return "0"
        }
        if(len == 1){
            return "0.0" + returnString
        }
        if(len == 2){
            return "0." + returnString
        }
        
        returnString = returnString.substringWithRange(NSRange(location: 0, length: len-2)) + "." + returnString.substringWithRange(NSRange(location: len - 2, length: 2))
        
        return returnString
    }
    
    var nextLevelMaxPowerFluidStorageString : String{
        var returnString = nextLevelMaxPowerFluidStorage.description as NSString
        let len = returnString.length
        
        if(len == 0){
            return "0"
        }
        if(len == 1){
            return "0.0" + returnString
        }
        if(len == 2){
            return "0." + returnString
        }
        
        returnString = returnString.substringWithRange(NSRange(location: 0, length: len-2)) + "." + returnString.substringWithRange(NSRange(location: len - 2, length: 2))
        
        return returnString
    }
    
    func increment(){
        if(powerFluid + powerFluidAmmount > maxPowerFluidStorage){
            powerFluid = maxPowerFluidStorage
        } else {
            powerFluid += powerFluidAmmount
        }
    }
    
    override var description : String {
        var returnString = powerFluid.description as NSString
        let len = returnString.length
        
        if(len == 0){
            return "0"
        }
        if(len == 1){
            return "0.0" + returnString
        }
        if(len == 2){
            return "0." + returnString
        }
        
        returnString = returnString.substringWithRange(NSRange(location: 0, length: len-2)) + "." + returnString.substringWithRange(NSRange(location: len - 2, length: 2))
        
        return returnString
    }
    
    func subtractPowerFluid(ammount: Int){
        self.powerFluid -= ammount * 100
    }
    
    func canAfford(ammount: Int) -> Bool{
        return self.powerFluid >= ammount * 100
    }
    
    func levelUpRateLevel(){
        self.rateLevel++
    }
    
    func levelUpStorageLevel(){
        self.storageLevel++
    }
    
    func levelUpAmmount(){
        self.ammountLevel++
    }
    
    
}

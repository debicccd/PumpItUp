//
//  RunningMapViewController.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/17/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit
import CoreLocation

class RunningMapViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var newMapView: GMSMapView!
    
    @IBOutlet weak var mapLabel: UILabel!
    
    let locationManager = CLLocationManager()
    //var mapView : GMSMapView?
    
    var lats : [Double] = []
    var longs : [Double] = []
    
    var cals : Int = 0
    
    var initial = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newMapView.myLocationEnabled = true
        
        newMapView.camera = GMSCameraPosition.cameraWithLatitude(0.0, longitude: 0.0, zoom: 18)
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapLabel.text = "0 Calories Earned (\(getCalories()) saved up)"
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Authorized || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let lat = self.locationManager.location.coordinate.latitude
        let long = self.locationManager.location.coordinate.longitude
        
        newMapView.camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: newMapView.camera.zoom)
        
        if initial {
            initial = false
            return
        }
        
        if(lats.count > 0){
            let newLoc = CLLocation(latitude: lat, longitude: long)
            let previousLoc = CLLocation(latitude: lats.last!, longitude: longs.last!)
            
            let distance = newLoc.distanceFromLocation(previousLoc)
            
            if distance > 5 {
                self.lats.append(lat)
                self.longs.append(long)
                updateTrack()
            }
        } else {
            self.lats.append(lat)
            self.longs.append(long)
        }
    }
    
    func updateTrack(){
        newMapView.clear()
        
        var start = GMSMarker(position: CLLocationCoordinate2D(latitude: lats[0], longitude: longs[0]))
        
        start.map = newMapView
        
        var i = 1
        var distance = 0.0
        
        var path = GMSMutablePath()
        
        var prev = CLLocation(latitude: lats[0], longitude: longs[0])
        
        path.addCoordinate(CLLocationCoordinate2D(latitude: lats[0], longitude: longs[0]))
        
        while i < self.lats.count {
            let loc = CLLocation(latitude: lats[i], longitude: longs[i])
            path.addCoordinate(CLLocationCoordinate2D(latitude: lats[i], longitude: longs[i]))
            distance += prev.distanceFromLocation(loc)
            prev = loc
            i++
        }
        
        let pathLine = GMSPolyline(path: path)
        pathLine.map = newMapView
        
        mapLabel.text = "\(Int(distance)) Calories Earned (\(getCalories()) saved up)"
        
        cals = Int(distance)
    }
    
    @IBAction func collectCalories(sender: AnyObject) {
        changeCalories(cals)
        
        cals = 0
        
        lats = []
        longs = []
        
        self.mapLabel.text = "0 Calories Earned (\(getCalories()) saved up)"
    }
    
    func getCalories() -> Int {
        if let cals = NSUserDefaults.standardUserDefaults().integerForKey(UserDefaultsCaloriesKey) as Int? {
            return cals
        } else {
            return 0
        }
    }
    
    func changeCalories(ammount: Int) {
        var newCals = ammount
        if let cals = NSUserDefaults.standardUserDefaults().integerForKey(UserDefaultsCaloriesKey) as Int? {
            newCals += cals
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(newCals, forKey: UserDefaultsCaloriesKey)
        defaults.synchronize()
    }
    
    func canAfford(ammount: Int) -> Bool {
        if let cals = NSUserDefaults.standardUserDefaults().integerForKey(UserDefaultsCaloriesKey) as Int? {
            return cals >= ammount
        } else {
            return false
        }
    }
}

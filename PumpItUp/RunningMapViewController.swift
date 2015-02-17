//
//  RunningMapViewController.swift
//  PumpItUp
//
//  Created by CSSE Department on 2/17/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit

class RunningMapViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func updateLocation(){
    }

}

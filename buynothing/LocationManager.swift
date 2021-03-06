//
//  LocationManager.swift
//  buynothing
//
//  Created by Jake Romer on 4/14/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject {
  static let shared = LocationManager()
  let manager = CLLocationManager()
  var currentLocation: CLLocation?

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.distanceFilter = 1_000
    requestPermission()
  }

  func requestPermission() {
    let authStatus = CLLocationManager.authorizationStatus()
    let authIsRestricted = authStatus == CLAuthorizationStatus.restricted
    let authIsDenied = authStatus == CLAuthorizationStatus.denied
    let authNotDetermined = authStatus == CLAuthorizationStatus.notDetermined

    if authIsRestricted || authIsDenied || authNotDetermined {
      manager.requestWhenInUseAuthorization()
    } else {
      CLLocationManager.locationServicesEnabled()
      manager.requestLocation()
    }
  }

}

// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLocation = location
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

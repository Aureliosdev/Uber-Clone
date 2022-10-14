//
//  LocationManager.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//


import CoreLocation
//This class manage users location basically
class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        //I'm use CLLocationAccuracy due to kclocationbest shows some error
        locationManager.desiredAccuracy = CLLocationAccuracy()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
 
       
    }
    
}

//MARK: - GRAB & UPDATE  USERS LOCATION
extension LocationManager: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        //once we get the location stops updating,also drain the battery of the phone
        locationManager.stopUpdatingLocation()
    }
}

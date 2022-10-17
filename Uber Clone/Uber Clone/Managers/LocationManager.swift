//
//  LocationManager.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//


import CoreLocation

//MARK: - The ObservableObject conformance allows instances of this class to be used inside views, so that when important changes happen the view will reload.  This class manage users location basically

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
   static let shared  = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
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
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        //once we get the location stops updating,also drain the battery of the phone
        locationManager.stopUpdatingLocation()
    }
}

//
//  UberMapViewRepresentable.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI
import MapKit


//MARK: -  UIViewRepresentable instance to create and manage a UIView object in your SwiftUI interface

struct UberMapViewRepresentable: UIViewRepresentable {

    let mapView  = MKMapView()
    
    let locationManager = LocationManager()
    
    //This func in charge of making a map
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator 
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    //It's return custom class
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
          
    }
    
}

//MARK: - The Custom class located here
extension UberMapViewRepresentable {
   
    //
    class MapCoordinator: NSObject,MKMapViewDelegate {
        //we get access to parent class
        let parent: UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
    //MARK: - Delegate method shows location.zoom the region and display the user
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                                           longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05 ,
                                                                   longitudeDelta: 0.05) )
           //setting the region after all
            parent.mapView.setRegion(region, animated: true)

        }
    }
}

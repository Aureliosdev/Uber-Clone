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

    let locationManager = LocationManager.shared
    
    @Binding var mapState: MapViewState
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    //This func in charge of making a map
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Debug map state is \(mapState)")
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .locationSelected:
            if let selectedLocation = locationViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocation)
                context.coordinator.configurePolyline(withDestinationCoordinate: selectedLocation)
    
            }
            break
          
        case .searchingForLocation:
            break
        case .polylineAdded:
            break
        }
    
       
//        if mapState == .noInput {
//            context.coordinator.clearMapViewAndRecenterOnUserLocation()
//        }
    }
    
    //It's return custom class
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
          
    }
    
}

//MARK: - The Custom class located here
extension UberMapViewRepresentable {
   
    
    class MapCoordinator: NSObject,MKMapViewDelegate {
        //we get access to parent class
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var  currentRegion: MKCoordinateRegion?
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
        //MARK: - Delegate method shows location.zoom the region and display the user
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                                           longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05 ,
                                                                   longitudeDelta: 0.05) )
            self.currentRegion = region
            //setting the region after all
            parent.mapView.setRegion(region, animated: true)
            
        }
     
        //MARK: - Helpers
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            //deletes couple of anno's from the map, leaves only 1
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            
        }
        
        //Apple maps directions is available to specific countries only. Please check full list here. Shortly you dont see polyline in Kazakhstan. Change to USA or other country if u want to see blue line.
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            //getting user location from the func mapview didupdate
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate ,
                                to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded 
               //adjust our polyline with ride request view
                let rect =  self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))   
                 
                self.parent.mapView.setRegion( MKCoordinateRegion(rect), animated: true)
            }
        }
        
        //Generate the polyline
 
        
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}

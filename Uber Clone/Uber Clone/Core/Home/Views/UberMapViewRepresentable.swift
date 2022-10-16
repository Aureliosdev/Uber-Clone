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
        if let selectedLocation = locationViewModel.selectedLocationCoordinate {
            context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocation)
            context.coordinator.configurePolyline(withDestinationCoordinate: selectedLocation)
        }
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
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
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
            getDestinationRoute(from: userLocationCoordinate ,
                                to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                 
            }
        }
        
        //Generate the polyline
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
            let userPlaceMark = MKPlacemark(coordinate: userLocation)
            let destinationPlaceMark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlaceMark)
            request.destination = MKMapItem(placemark: destinationPlaceMark)
            let directions  = MKDirections(request: request)
            directions.calculate { response, error in
                if let error = error {
                    print("Debug failed to get directions \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else { return }
                completion(route)
            }
        }
    }
}

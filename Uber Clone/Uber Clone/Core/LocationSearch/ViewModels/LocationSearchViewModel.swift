//
//  LocationSearchViewModel.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    //MARK: - Properties
    
    @Published var results  = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    
    private let searchCompleter  = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D? 
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - Helpers
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("Debug location search failed with error \(error.localizedDescription)")
                return
            }
            guard let item  = response?.mapItems.first else { return }
            let coordinate  = item.placemark.coordinate
            self.selectedUberLocation = UberLocation(title: localSearch.title,
                                                      coordinate: coordinate)
            print("Debug: Location coordinates \(coordinate)")
        }
    }
    func computeRidePrice(forType type: RideType) -> Double {
        guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude:  userCoordinate.latitude,
                                      longitude: userCoordinate.longitude)
        let destination  = CLLocation(latitude: destCoordinate.latitude,
                                      longitude: destCoordinate.longitude)
        
        let tripDistanceInMeters  = userLocation.distance(from: destination)
        
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest  = MKLocalSearch.Request()    //configure searchrequest
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)   // accessing in the top func
    }
    
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
            self.configurePickupAndDropOffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropOffTimes(with expectedTravelTime: Double) {
        let  formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}
 //MARK: -  We gave some query and give us locations under the hood

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
   
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results  = completer.results
    }
}

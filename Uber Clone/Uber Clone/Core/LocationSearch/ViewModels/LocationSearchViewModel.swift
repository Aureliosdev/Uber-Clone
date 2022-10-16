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
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    
    private let searchCompleter  = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    
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
            self.selectedLocationCoordinate = coordinate
            print("Debug: Location coordinates \(coordinate)")
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest  = MKLocalSearch.Request()    //configure searchrequest
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)   // accessing in the top func
    }
    
}
 //MARK: -  We gave some query and give us locations under the hood

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
   
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results  = completer.results
    }
}

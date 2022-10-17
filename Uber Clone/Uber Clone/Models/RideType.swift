//
//  RideType.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 17.10.2022.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    case uberX
    case uberBlack
    case uberXL
    
    var id: Int { return rawValue }
    
    var descriptionString: String {
        switch self {
        case .uberX: return  "UberX"
        case .uberBlack: return "Uber Black"
        case .uberXL: return "Uber XL"
            
        }
        
    }
    var imageName: String {
        switch self {
        case .uberX: return  "UberX"
        case .uberBlack: return "uberBlack"
        case .uberXL: return "UberX"
            
        }
    }
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .uberBlack:  return 20
        case .uberXL: return 10
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInKm =  distanceInMeters / 1000

        switch self {
        case .uberX: return distanceInKm * 1.5 + baseFare
        case .uberBlack:  return distanceInKm * 2.0 + baseFare
        case .uberXL: return distanceInKm * 1.75 + baseFare
        }
    }
    
}

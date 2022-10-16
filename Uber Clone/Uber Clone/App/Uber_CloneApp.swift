//
//  Uber_CloneApp.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI

@main
struct Uber_CloneApp: App {
   @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
           HomeView()
            
                //MARK: - This property allow us to utilize singular instance of LocationSearchViewModel. We dont have 2 separate instances we're gonna have single one.
            
                .environmentObject(locationViewModel)
        }
    }
}

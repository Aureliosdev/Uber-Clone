//
//  HomeView.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI

struct HomeView: View {
     
    @State private var mapState  = MapViewState.noInput
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                //Actually shows map to full screen
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
               
                if mapState ==  .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                }else if mapState == .noInput {
                    //Our Textfield placed
                     LocationSearchActivationView()
                        .padding(.top,72)
                        //when we tap the label we call the searchview
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                //Our button on the top
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top,4)
            }
            
            if mapState == .locationSelected  || mapState == .polylineAdded {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

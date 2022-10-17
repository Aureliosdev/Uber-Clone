//
//  MapViewActionButton.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    var body: some View {
        Button { withAnimation(.spring()) {
            actionForState(mapState)
        } }
        
            label: {
                //here we get switching images
                Image(systemName: imageNameForState(mapState))
               //Really matter one after one, to create circle button
                .foregroundColor(.black)
                .font(.title2)
                .padding()
                .background(Color(.white))
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("Debug: no input")
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            mapState = .noInput
            //BUG FIXING. after selecting each location, previous just dissapears
            viewModel.selectedUberLocation = nil
        }
    }
    func imageNameForState(_ state:MapViewState) -> String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .polylineAdded:
           return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
    
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}

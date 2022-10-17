//
//  LocationSearchView.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI

struct LocationSearchView: View {
    //When the value changes, SwiftUI updates the parts of the view hierarchy that depend on the value
    @State private var startLocation = ""
    @Binding var  mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
     
    var body: some View {
        VStack {
            
            HStack {
                VStack {
                    //Small elements in the left
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle( )
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                    
                }
                
                VStack {
                    TextField("Current location",text: $startLocation)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Where to?",text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
                
            } 
            .padding(.horizontal)
            .padding(.top,64)
            
            Divider()
                .padding(.vertical)
            //List View
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultsCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                             
                            }
                    }
                }
            }
        }
        //changing background from transparent
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}


struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation) )
    }
}

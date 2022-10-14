//
//  HomeView.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        //Actually shows map to full screen
        UberMapViewRepresentable()
            .ignoresSafeArea()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

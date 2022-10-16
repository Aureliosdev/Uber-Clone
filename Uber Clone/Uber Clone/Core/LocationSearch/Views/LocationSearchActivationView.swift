//
//  LocationSearchActivationView.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 15.10.2022.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
           
            Rectangle()
                .fill(Color.black)
                .frame(width: 8,height: 8)
                .padding(.horizontal)
            
            Text("Where to go?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64,
               height: 50)
        .background(
            Rectangle()
                .fill(Color(.white))
                .shadow(color: .black, radius: 6)
        )
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}

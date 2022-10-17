//
//  RideRequestView.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 17.10.2022.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48,height: 6)
                .padding(.top,8)
            // Trip info view
            HStack {
                VStack {
                    //Small elements in the left
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle( )
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                    
                }
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Current location")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(locationViewModel.pickupTime  ?? "")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    HStack {
                        if let location =  locationViewModel.selectedUberLocation {
                            Text(location.title)
                                .font(.system(size: 16,weight: .semibold))
                        }
                              
                        Spacer()
                        Text(locationViewModel.dropOffTime ?? "")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            //Ride type selection view
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(Color(.gray))
                .frame(maxWidth: .infinity,alignment: .leading)
                
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases ) { rideType  in
                        VStack(alignment: .leading) {
                            Image(rideType.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading,spacing: 4) {
                                Text(rideType.descriptionString)
                                    .font(.system(size: 14,weight: .semibold))
                                Text(locationViewModel.computeRidePrice(forType: rideType).toCurrency())
                                    .font(.system(size: 14,weight: .semibold))
                            }
                            .padding()
                        }
                        .frame(width: 112,height: 140)
                        .foregroundColor(rideType == selectedRideType ? .white : Color.theme.primaryTextColor)
                        .background(rideType == selectedRideType ? .blue : Color.theme.secondaryBackground)
                        .scaleEffect(rideType == selectedRideType ? 1.2  : 1.0)
                        .cornerRadius(10)
                        
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRideType =  rideType
                            }
                        }
                    }
               
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            //Payement option view
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 6568")
                    .fontWeight(.bold)
                
                
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackground)
            .cornerRadius(10)
            .padding(.horizontal)
            
            
            //Request option button
            Button {
                
            } label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32,height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
            }
        }
        .padding(.bottom,16)
        .background(Color.theme.backgroundColor)
        .cornerRadius(12)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}

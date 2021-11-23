//
//  Search.swift
//  weather
//
//  Created by Владислав Космачев.
//

import SwiftUI
import Combine

struct Search: View {
    
    @Binding var cityView:Bool
    @Binding var lat:Double
    @Binding var lon:Double
    @StateObject var searchMV = APIGeocoding()
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle().fill(Color.white).cornerRadius(25).shadow(radius: 10).opacity(0.75)
                VStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                        TextField("Поиск города", text: $searchMV.searchText)
                    }
                }.foregroundColor(.gray).font(.headline).padding()
            }.frame(width:UIScreen.main.bounds.width-32, height: 40).padding()
            List(searchMV.cities){ search in
                Button(action: {
                    lat = search.lat
                    lon = search.lon
                    cityView = false
                }){
                    Text("\(search.name)")
                }
            }.listStyle(InsetListStyle())
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search(cityView: .constant(false), lat: .constant(0.0), lon: .constant(0.0))
    }
}

//
//  APIGeocoding.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON

class APIGeocoding: ObservableObject, APIGeocodingProtocol{
    
    @Published var cities:[Model.Cities] = []
        
    @Published var searchText: String = String()
    
    var subscription: Set<AnyCancellable> = []
        
    init() {
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.cities = []
                    return nil
                    }
                    return string
                })
            .compactMap{ $0 }
            .sink { (_) in
            } receiveValue: { [self] (searchField) in
                getCities(query: searchField)
            }.store(in: &subscription)
    }
        
    
    func getCities(query:String){
        
        let param = [
            "q": query,
            "APPID": Constants.apiKey
        ] as [String : Any]
        
        let request = AF.request(Constants.apiLinkGeocoding, method: .get, parameters: param)
        request.responseJSON{ (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.cities = []
                    if (json.count != 0){
                        for i in 0...json.count-1 {
                            self.cities.append(Model.Cities(id: i, name: json[i]["local_names"]["ru"].stringValue,  lat: json[i]["lat"].doubleValue, lon: json[i]["lon"].doubleValue))
                        }
                    }
                    debugPrint(json)
                case .failure(let error):
                    print(error)
                }
        }
    }
}

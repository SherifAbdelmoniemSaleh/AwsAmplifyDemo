//
//  CountriesViewModel.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 07/04/2021.
//
import Foundation
import RxCocoa
import RxSwift
import Alamofire
import ObjectMapper
class CountriesViewModel {
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var countriesModelSubject = PublishSubject<[CountriesModel]>()
    
    var countriesModelObservable: Observable<[CountriesModel]> {
        return countriesModelSubject
    }

    func getAllCountries(){
        loadingBehavior.accept(true)
        let path : String = String(format:"https://b2bapi.travotels.com/V3/Lookup/GetAllNationalities")
        let sharedHeaders : [String: String] =  [
          "Content-Type": "application/json" ]
        NetworkManager.performRequestWithPath(baseUrl: path, path: nil, requestMethod: .get, requestParam: nil , headersParam: sharedHeaders , encoding: .default , success: { (response) in
            
            if let json = response as? [String:Any], // <- Swift Dictionary
               let results = json["data"] as? [[String:Any]] { // <- get array inside data
                let countryList:[CountriesModel] = Mapper<CountriesModel>().mapArray(JSONObject: results )! //map countries to CountryModel
                self.countriesModelSubject.onNext(countryList)
                self.loadingBehavior.accept(false)
            }
        }, failure: {error in
            self.loadingBehavior.accept(false)
            print(error)
        })
    }
}


//
//  CountriesModel.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 07/04/2021.
//


import Foundation
import ObjectMapper


class CountriesModel : NSObject, Mappable{
 
  
    var id : Any!
    var name : String!
    var code : String?
   
  
    internal init(id: Any, name: String , code : String = "") {
    self.id = id
    self.name = name
    self.code = code
  }
  

    class func newInstance(map: Map) -> Mappable?{
        return CountriesModel()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
    }

}


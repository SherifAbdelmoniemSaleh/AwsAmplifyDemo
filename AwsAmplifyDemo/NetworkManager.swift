//
//  NetworkManager.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 08/04/2021.
//

import Foundation

import UIKit
import Alamofire

typealias SuccessNetworkClousre = (Any?)  -> Void
typealias FailureNetworkClousre = (_ error: NSError) -> Void

public class NetworkManager {
    static let tokenKey = "Authorization"
    static let contentTypeKey = "Content-Type"
    static let contentTypeValue = "application/json"
    
    class func performRequestWithPath (baseUrl          :String?,
                                       path             :String?,
                                       requestMethod    :Alamofire.HTTPMethod,
                                       requestParam     :[String: Any]?,
                                       headersParam     :[String: String]?,
                                       encoding         :JSONEncoding?,
                                       success          :@escaping SuccessNetworkClousre,
                                       failure          :@escaping FailureNetworkClousre){
        
        let url = (path != nil) ? baseUrl! + path! : baseUrl
        let headers: [String: String] = [:]
        
        if let encoding = encoding {
            
            Alamofire.request(URL.init(string: url!)!, method: requestMethod, parameters: requestParam, encoding: encoding, headers: headers)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case  .success(_):
                        success(response.result.value)
                    case .failure(let error):
                        failure(error as NSError)
                        break
                    }
                }
        } else{
            
            Alamofire.request(URL.init(string: url!)!, method: requestMethod, parameters: requestParam, headers: headers)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case  .success(_):
                        success(response.result.value)
                    case .failure(let error):
                        failure(error as NSError)
                    }
                }
        }
    }
    
    class func userShouldLogout () {
        
    }
}


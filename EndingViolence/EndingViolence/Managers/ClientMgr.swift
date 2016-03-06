//
//  ClientMgr.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Alamofire

// curl -X POST -H "Content-Type: application/json" -d '{"data":"hi"}' https://demo1272084.mockable.io/alarm

struct ClientMgr {

    static let endpoint = "https://demo1272084.mockable.io/alarm"
    
    static func raiseTheAlarm(session: MSession) {
        
        let json = session.toJSON()
        print(json)

        Alamofire.request(.POST, ClientMgr.endpoint, parameters: json, encoding: .JSON)
            .validate()
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    static func uploadImage(image: UIImage) {
        
        
        /*
        Alamofire.upload(
            .POST,
            ClientMgr.endpoint,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: unicornImageURL, name: "unicorn")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        */
    }
    
}


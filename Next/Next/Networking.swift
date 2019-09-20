//
//  Networking.swift
//  UpMeme
//
//  Created by jason smellz on 6/30/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import Foundation
import Firebase
// Networking layer

class Networking {
    
    // create default urlsession
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    // get stripe ephemeral session key from backend
    
    func getMeme(_ memeId: String, _ upVote: Bool, _ completion: @escaping (_ memeUrl: String?, _ moreContentExists: Bool) -> ()) {
//        let number = Int.random(in: 1 ... 3)
//        let filename = String(number) + ".jpg"
//        completion(filename, true)
        
        print("get meme request started")
        self.dataTask?.cancel()

        // endpoint

        var url = URLRequest(url: URL(string:"https://us-central1-next-84941.cloudfunctions.net/getMeme")!)

        // check if user is signed in and get user auth token

        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in

            if let error = error  {
                return
            }

            // pass token and api version for stripe to backend with POST
            let params : [String: Any] = ["memeId": memeId, "upVote": upVote, "token" : token]

            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                return
            }

            // set up http method, headers, and parameters
            url.httpMethod = "POST"
            url.httpBody = httpBody
            url.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.dataTask = self.defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }

                if let error = error {
                    "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    print("RESPONSE", response)
                    guard let json = (try? JSONSerialization.jsonObject(with: data, options:    JSONSerialization.ReadingOptions.allowFragments)) as? [String: Any] else {
                        print("Not containing JSON")
                        return
                    }

                    DispatchQueue.main.async {

                        // return meme image url
                        print(json)
                        guard
                            let id = json["id"] as? String, let content = json["content"] as? Bool
                            else { return completion("no more content", false) }
                        print("ID", id)
                        completion(id, content)

                    }
                }
            }

            self.dataTask?.resume()
        }
    }

}

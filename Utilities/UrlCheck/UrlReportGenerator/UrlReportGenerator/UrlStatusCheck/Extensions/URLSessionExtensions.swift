//
//  File.swift
//  

import Foundation

extension URLSession {
   
   func syncRequest(with url: URL) -> (Data?, URLResponse?, Error?) {
      var data: Data?
      var response: URLResponse?
      var error: Error?
      
      let dispatchGroup = DispatchGroup()
      let task = dataTask(with: url) {
         data = $0
         response = $1
         error = $2
         dispatchGroup.leave()
      }
      dispatchGroup.enter()
      task.resume()
      dispatchGroup.wait()
      
      return (data, response, error)
   }
   
   func syncRequest(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
      var data: Data?
      var response: URLResponse?
      var error: Error?
      
      let dispatchGroup = DispatchGroup()
      let task = dataTask(with: request) {
         data = $0
         response = $1
         error = $2
         dispatchGroup.leave()
      }
      dispatchGroup.enter()
      task.resume()
      dispatchGroup.wait()
      
      return (data, response, error)
   }
   
}

// Note: a timeout can be added by using func wait(timeout: DispatchTime) -> DispatchTimeoutResult instead of func wait()

// Example 1
//var urlRequest = URLRequest(url: config.pullUpdatesURL)
//urlRequest.httpMethod = "GET"
//urlRequest.httpBody = requestData
//urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//let (data, response, error) = URLSession.shared.syncRequest(with: urlRequest)

// Example 2
//let url = URL(string: "https://www.example.com/")
//let (data, response, error) = URLSession.shared.syncRequest(with: url)

//
//  AuthorizationViewController.swift
//  VKWay
//
//  Created by Евгений Оводков on 16/05/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView! 
    var completitionHandler: (()->())?
    
    var logOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6992342"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.65")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        
        webView.navigationDelegate = self
        webView.load(request)
        
    }
    
    
}

extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        Session.current.token   = params["access_token"] ?? ""
        Session.current.id      = (Int(params["user_id"] ?? "0")) ?? 0
        
        KeychainWrapper.standard.set(Session.current.token, forKey: "token")
        UserDefaults.standard.set(Session.current.id, forKey: "id")
        
        if let completion = completitionHandler {
            completion()
        }
        decisionHandler(.cancel)
        dismiss(animated: true, completion: nil)

        
    }
    
}
    

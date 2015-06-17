////
////  RESTFullManager.swift
////  EnTurma
////
////  Created by Gabriel Silva on 6/11/15.
////  Copyright (c) 2015 mds. All rights reserved.
////
//
//import Foundation
//
//class RESTFullManager {
//    private var URL_BASE = "http://192.168.0.14:3000/"
//    private var operationManager : AFHTTPRequestOperationManager
//    private var params : NSDictionary
//    
//    init(params : NSDictionary){
//        self.operationManager = AFHTTPRequestOperationManager()
//        self.params = params
//    }
//    
//    private func encodeParamsToURLResquest() ->String{
//        var urlParams = "?utf8=E2%9C%93"
//        for(key, value) in self.params{
//            var currentKey = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
//            var currentValue = value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
//            
//            urlParams += "&" + currentKey! + "=" + currentValue!
//        }
//        return urlParams
//    }
//    
//    func requestReport(success : (AFHTTPRequestOperation!, AnyObject!)-> Void, failure: (AFHTTPRequestOperation!, NSError!)-> Void) -> Void{
//        var urlRequest = self.URL_BASE + "report/request_report.json" + self.encodeParamsToURLResquest()
//        self.genericRequest(urlRequest, success: success, failure: failure)
//    }
//    
//    func requestCompare(success : (AFHTTPRequestOperation!, AnyObject!)-> Void, failure: (AFHTTPRequestOperation!, NSError!)-> Void) -> Void{
//        var urlRequest = self.URL_BASE + "compare_reports/request_comparation.json" + self.encodeParamsToURLResquest()
//        self.genericRequest(urlRequest, success: success, failure: failure)
//    }
//
//    
//    private func genericRequest(url: String,success : (AFHTTPRequestOperation!, AnyObject!)-> Void, failure: (AFHTTPRequestOperation!, NSError!)-> Void){
//        
//        self.operationManager.GET(url,
//            parameters: nil,
//            success: success,
//            failure: failure)
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//}

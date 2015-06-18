////
////  RESTFullManager.swift
////  EnTurma
////
////  Created by Gabriel Silva on 6/11/15.
////  Copyright (c) 2015 mds. All rights reserved.

import Foundation
import Alamofire

class RESTFullManager {
    private var URL_BASE = "http://192.168.1.12:3000/"
    private var params : NSDictionary
    
    init(params : NSDictionary){
        self.params = params
    }
    
    private func encodeParamsToURLResquest() ->String{
        var urlParams = "?utf8=E2%9C%93"
        for(key, value) in self.params{
            var currentKey = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            var currentValue = value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            urlParams += "&" + currentKey! + "=" + currentValue!
        }
        return urlParams
    }
    
    func requestReport(success : (jsonObject : NSDictionary)-> Void, failure: ()-> Void) -> Void{
        var urlRequest = self.URL_BASE + "report/request_report.json" + self.encodeParamsToURLResquest()
        self.genericRequest(urlRequest, success: success, failure: failure)
    }
    
    func requestCompare(success : (jsonObject : NSDictionary)-> Void, failure: ()-> Void) -> Void{
        var urlRequest = self.URL_BASE + "compare_reports/request_comparation.json" + self.encodeParamsToURLResquest()
        self.genericRequest(urlRequest, success: success, failure: failure)
    }
    
    func requestRanking(success : (jsonObject : NSDictionary)-> Void, failure: ()-> Void) -> Void{
        var urlRequest = self.URL_BASE + "ranking/request_ranking.json" + self.encodeParamsToURLResquest()
         self.genericRequest(urlRequest, success: success, failure: failure)
    }

    
    private func genericRequest(url: String,success : (jsonObject : NSDictionary)-> Void, failure: ()-> Void){
        Alamofire.request(.GET, url).responseJSON { (_, _, JSON, _) in
            var jsonResponse = JSON as! NSDictionary
            success(jsonObject: jsonResponse)
        }        
    }
    
    

}

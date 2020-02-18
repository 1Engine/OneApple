//
//  Request.swift
//  iOSTests
//
//  Created by R on 08.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import XCTest
import iOS

class RequestTests: XCTestCase {
    
    func testBuilder() {
        let url = "http://test.com"
        let method = Request.Method.post
        let headers: [String: Any] = ["Header1":"Value1", "Header2": "Value2"]
        let requestType = Request.RequestType.json(["Param1": "Value1", "Param2": "Value2"])
        let request = Request()
            .url(url)
            .method(method)
            .headers(headers)
            .requestType(requestType)
        
        XCTAssertEqual(url, request.url?.absoluteString)
    }
    
    func testSendJson() {
        
    }
    
    func testSendText() {
        
    }
    
    func testSendJpeg() {
        
    }

    func testSendPng() {
        
    }

    func testReceiveJson() {
        
    }
    
    func testReceiveText() {
        
    }
    
    func testReceiveInt() {
        
    }
    
    func testReceiveFloat() {
        
    }
    
    func testReceiveImage() {
        Request()
            .resultType(.image) .get("https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Cat_poster_1.jpg/320px-Cat_poster_1.jpg") { data, error in
                
            }
    }
    
    func testReceiveData() {
        
    }

    func testEmptyUrl() {
        
    }

    func testParseError() {
        
    }

    func testEmptyResponse() {
        
    }

}

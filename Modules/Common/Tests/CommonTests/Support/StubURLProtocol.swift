//
//  StubURLProtocol.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Alamofire
import Foundation
@testable import Common

final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var stubData: Data?
    nonisolated(unsafe) static var stubStatusCode: Int = 200
    nonisolated(unsafe) static var lastRequestURL: URL?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        StubURLProtocol.lastRequestURL = request.url
        let response = HTTPURLResponse(
            url: request.url ?? URL(fileURLWithPath: "/"),
            statusCode: StubURLProtocol.stubStatusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )
        if let response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = StubURLProtocol.stubData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

enum StubbedAPIClientFactory {
    static func make(json: String, statusCode: Int = 200) -> AlamofireAPIClient {
        StubURLProtocol.stubData = json.data(using: .utf8)
        StubURLProtocol.stubStatusCode = statusCode
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        let session = Session(configuration: configuration)
        return AlamofireAPIClient(session: session)
    }
}

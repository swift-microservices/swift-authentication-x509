//
//  SPIFFEIDTests.swift
//  swift-authentication-x509
//
//  Created by Zaid Rahhawi on 9/11/26.
//

import AuthenticationX509
import Testing

@Suite
struct SPIFFEIDTests {
    @Test(
        "Parsing a SPIFFE URI",
        arguments: [
            ("spiffe://example/billing-worker", SPIFFEID(trustDomain: "example", path: "/billing-worker")),
            ("spiffe://example/a/b", SPIFFEID(trustDomain: "example", path: "/a/b")),
            ("spiffe://example/", SPIFFEID(trustDomain: "example", path: "/")),
            ("spiffe://example", nil),
            ("spiffe:///billing-worker", nil),
            ("https://example/billing-worker", nil),
            ("", nil),
        ] as [(String, SPIFFEID?)]
    )
    func parsing(uri: String, expected: SPIFFEID?) {
        #expect(SPIFFEID(uri: uri) == expected)
    }

    @Test("An ID round-trips through its URI")
    func uriRoundTrips() {
        let id = SPIFFEID(trustDomain: "example", path: "/billing-worker")
        #expect(id.uri == "spiffe://example/billing-worker")
        #expect(SPIFFEID(uri: id.uri) == id)
    }
}

//
//  TestCertificate.swift
//  swift-authentication-x509
//
//  Created by Zaid Rahhawi on 9/11/26.
//

import Crypto
import Foundation
import X509

enum TestCertificate {
    /// A self-signed certificate whose subject alternative names are the given URIs.
    static func withURIs(_ uris: [String]) throws -> Certificate {
        let key = Certificate.PrivateKey(P256.Signing.PrivateKey())
        let name = try DistinguishedName { CommonName("test") }

        return try Certificate(
            version: .v3,
            serialNumber: Certificate.SerialNumber(),
            publicKey: key.publicKey,
            notValidBefore: Date(),
            notValidAfter: Date().addingTimeInterval(3600),
            issuer: name,
            subject: name,
            signatureAlgorithm: .ecdsaWithSHA256,
            extensions: try Certificate.Extensions {
                if !uris.isEmpty {
                    SubjectAlternativeNames(uris.map { .uniformResourceIdentifier($0) })
                }
            },
            issuerPrivateKey: key
        )
    }
}

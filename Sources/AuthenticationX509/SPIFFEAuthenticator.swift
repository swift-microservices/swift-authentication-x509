//
//  SPIFFEAuthenticator.swift
//  swift-authentication-x509
//
//  Created by Zaid Rahhawi on 9/11/26.
//

import Authentication
import X509

/// Names a peer by the SPIFFE ID in its certificate's subject alternative names.
///
/// The transport verified the certificate at the handshake: it chains to the trust roots, it is
/// within its validity, the peer holds its key. What remains is reading who it names. The first
/// URI subject alternative name that parses as a SPIFFE ID in the trust domain is the peer. A
/// certificate with none, or with IDs only in other trust domains, is declined: a valid peer
/// this service does not admit, which continues unbound rather than refused. This authenticator
/// never throws.
///
/// An application whose peers are richer than an ID wraps it in an `Authenticator` of its own
/// and maps the ID.
public struct SPIFFEAuthenticator: Authenticator {
    /// The trust domain this service admits.
    public let trustDomain: String

    public init(trustDomain: String) {
        self.trustDomain = trustDomain
    }

    public func authenticate(_ certificate: Certificate) -> SPIFFEID? {
        guard let alternativeNames = try? certificate.extensions.subjectAlternativeNames else {
            return nil
        }

        return alternativeNames
            .lazy
            .compactMap { name -> SPIFFEID? in
                if case .uniformResourceIdentifier(let uri) = name { SPIFFEID(uri: uri) } else { nil }
            }
            .first { $0.trustDomain == trustDomain }
    }
}

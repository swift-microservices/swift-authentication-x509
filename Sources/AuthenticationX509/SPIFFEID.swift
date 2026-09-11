//
//  SPIFFEID.swift
//  swift-authentication-x509
//
//  Created by Zaid Rahhawi on 9/11/26.
//

/// A SPIFFE ID: `spiffe://<trust-domain><path>`, the name a workload carries in its certificate.
public struct SPIFFEID: Hashable, Sendable {
    /// The issuer's namespace: `example` in `spiffe://example/billing-worker`.
    public let trustDomain: String

    /// The workload within it, with its leading slash: `/billing-worker`.
    public let path: String

    public init(trustDomain: String, path: String) {
        self.trustDomain = trustDomain
        self.path = path
    }

    /// Parses `spiffe://<trust-domain><path>`, or fails for anything else.
    public init?(uri: String) {
        let scheme = "spiffe://"

        guard uri.hasPrefix(scheme) else {
            return nil
        }

        let rest = uri.dropFirst(scheme.count)

        guard let slash = rest.firstIndex(of: "/"), rest.startIndex < slash else {
            return nil
        }

        self.init(trustDomain: String(rest[..<slash]), path: String(rest[slash...]))
    }

    /// The ID as a URI.
    public var uri: String {
        "spiffe://\(trustDomain)\(path)"
    }
}

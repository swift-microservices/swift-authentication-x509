//
//  SPIFFEAuthenticatorTests.swift
//  swift-authentication-x509
//
//  Created by Zaid Rahhawi on 9/11/26.
//

import Authentication
import AuthenticationX509
import ServiceContextModule
import Testing
import X509

@Suite
struct SPIFFEAuthenticatorTests {
    let authenticator = SPIFFEAuthenticator(trustDomain: "example")

    @Test("A certificate naming a workload in the trust domain is authenticated")
    func authenticatesWorkloadInTrustDomain() throws {
        let certificate = try TestCertificate.withURIs(["spiffe://example/billing-worker"])

        #expect(authenticator.authenticate(certificate) == SPIFFEID(trustDomain: "example", path: "/billing-worker"))
    }

    @Test("A certificate naming a workload in another trust domain is declined")
    func declinesOtherTrustDomain() throws {
        let certificate = try TestCertificate.withURIs(["spiffe://other/billing-worker"])

        #expect(authenticator.authenticate(certificate) == nil)
    }

    @Test("A certificate with no subject alternative names is declined")
    func declinesWithoutNames() throws {
        let certificate = try TestCertificate.withURIs([])

        #expect(authenticator.authenticate(certificate) == nil)
    }

    @Test("Among several names, the one in the trust domain is chosen")
    func choosesNameInTrustDomain() throws {
        let certificate = try TestCertificate.withURIs([
            "https://example/not-spiffe",
            "spiffe://other/billing-worker",
            "spiffe://example/billing-worker",
        ])

        #expect(authenticator.authenticate(certificate) == SPIFFEID(trustDomain: "example", path: "/billing-worker"))
    }

    @Test("The peer it names is bound as a principal of the certificate")
    func peerIsBoundAsPrincipal() throws {
        let certificate = try TestCertificate.withURIs(["spiffe://example/billing-worker"])
        let peer = try #require(authenticator.authenticate(certificate))

        var context = ServiceContext.topLevel
        context[PrincipalKey<SPIFFEID, Certificate>.self] = Principal(identity: peer, credential: certificate)

        let principal = ServiceContext.withValue(context) {
            ServiceContext.current?[PrincipalKey<SPIFFEID, Certificate>.self]
        }

        #expect(principal?.identity == peer)
        #expect(principal?.credential == certificate)
    }
}

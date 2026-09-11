# ``AuthenticationX509``

Who is calling, proved by the certificate presented at the TLS handshake.

## Overview

A process proves who it is with the client certificate it presented when the connection was
made. The transport verified it before any byte of the request was read; what remains for the
application is reading who it names. ``SPIFFEAuthenticator`` does that: an
`Authenticator<Certificate, SPIFFEID>` that reads the `spiffe://<trust-domain><path>` URI from
the certificate's subject alternative names, which is how a CA the stack issues itself names
each workload.

The peer it names becomes a `Principal<SPIFFEID, Certificate>`, bound under
`PrincipalKey<SPIFFEID, Certificate>` by a transport package: swift-authentication-grpc's
`AuthenticationGRPCNIOTransport` product for gRPC over the NIO transport.

## Example

```swift
let authenticator = SPIFFEAuthenticator(trustDomain: "example")
```

A transport package applies it where the certificate is available and binds the result. A
handler then reads which process is calling:

```swift
let peer = ServiceContext.current?[PrincipalKey<SPIFFEID, Certificate>.self]?.identity
```

## Topics

### SPIFFE

- ``SPIFFEID``
- ``SPIFFEAuthenticator``

### Design

- <doc:CertificatesAsCredentials>

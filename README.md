# swift-authentication-x509

Who is calling, proved by the certificate presented at the TLS handshake.

```swift
.package(url: "https://github.com/swift-microservices/swift-authentication-x509.git", from: "0.1.0"),
```

```swift
.product(name: "AuthenticationX509", package: "swift-authentication-x509"),
```

## The vocabulary

A process proves who it is with the client certificate it presented when the connection was made.
The transport verified it before any byte of the request was read. What remains is reading who it
names:

| Type | Role |
| --- | --- |
| `SPIFFEID` | `spiffe://<trust-domain><path>`, the name a workload carries |
| `SPIFFEAuthenticator` | an `Authenticator<Certificate, SPIFFEID>`: reads the SPIFFE ID from the subject alternative names, within one trust domain |

The shape comes from [swift-authentication](https://github.com/swift-microservices/swift-authentication):
an authenticator turns a credential into an identity, declines with `nil`, or refuses by throwing.
This one never throws, because the transport already refused every certificate that could be
refused. An unknown peer is a valid one this service does not admit, and it is declined, so the
call continues unbound.

## Reading the peer

```swift
let authenticator = SPIFFEAuthenticator(trustDomain: "example")
```

A transport package applies it where the certificate is available and binds the result as a
`Principal<SPIFFEID, Certificate>`. For gRPC over the NIO transport that is
`CertificateAuthenticationInterceptor` in swift-authentication-grpc. A handler then reads:

```swift
let peer = ServiceContext.current?[PrincipalKey<SPIFFEID, Certificate>.self]?.identity
```

A call can carry both a certificate and a token, a service relaying a person's call, so the two
principals are bound independently under separate keys.

## Requirements

Swift 6.3, macOS 15 or Linux.

## Development

```sh
swift test
swift-format lint --strict --recursive Sources Tests    # what the soundness check runs
```

## Contributing

Pull requests are welcome. Keep a change focused, prove new behaviour with a test, and label the
pull request with its semantic version impact.

## License

MIT. See [LICENSE](LICENSE).

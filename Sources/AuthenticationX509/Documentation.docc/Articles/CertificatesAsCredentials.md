# Certificates as credentials

What a certificate proves, what it does not, and why an unknown peer is not an error.

## The transport did the checking

When a connection is mutually authenticated, the TLS handshake already established that the
peer's certificate chains to the trust roots, is within its validity, and belongs to the key the
peer holds. A request that reaches the application arrived over a connection that passed all of
that. Nothing here re-verifies a certificate.

## Authenticating is reading a name

What the application adds is the mapping from a certificate to a peer it knows. That is an
`Authenticator<Certificate, Identity>` from swift-authentication, and ``SPIFFEAuthenticator`` is
the one this package ships: it reads the SPIFFE URI in the subject alternative names, restricted
to one trust domain. An application whose peers carry more than an ID wraps it and maps the ID.

## Unknown is unbound, not refused

The authenticator returns `nil` for a certificate it has no name for, and the call continues
with no certificate principal bound. It never throws: the transport already refused every
certificate that could be refused. The certificate was valid, so the peer is real; it is simply
not one this service admits. What a known peer may then do is the destination's decision, made
where the service is built. A certificate proves a credential, never a permission.

## Two principals on one call

A service relaying a person's call arrives with its own certificate and the person's token. The
two are bound independently, under `PrincipalKey<SPIFFEID, Certificate>` and
`PrincipalKey<AppToken, String>`, so a handler can ask either question: which process is calling,
and on whose behalf.

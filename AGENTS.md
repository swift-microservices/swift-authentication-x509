# Repository guidelines

This package is the certificate vocabulary shared by every service in the organization. Read
this before changing anything.

## What this package is

- One product, `AuthenticationX509`: `SPIFFEID` and `SPIFFEAuthenticator`, an
  `Authenticator<Certificate, SPIFFEID>` from swift-authentication. It depends on
  swift-authentication and swift-certificates.
- The principal and key types are swift-authentication's, generic over the credential. Nothing
  here redeclares them.
- A certificate proves a process. The identity is whatever the application's authenticator
  returns; SPIFFE is the one this package ships.

## What does not belong here

- Verifying a certificate. The transport did that at the handshake; this package only reads names.
- Refusing an unknown peer. The authenticator returns `nil` and the call continues unbound.
  Whether a peer is admitted is decided where the service is built.
- Anything that needs a transport type. The gRPC interceptor that reads the certificate off the
  connection is in swift-authentication-grpc.

## Swift

- Swift 6.3, strict concurrency, `Sendable` everywhere it is meaningful.
- Tests use Swift Testing. SPIFFE parsing is a table; the authenticator is proven against
  certificates generated in memory with swift-certificates, including that its peer binds as a
  principal.
- Doc comments on every public declaration; the DocC catalog is the long-form explanation.
- Format with `swift-format format --in-place --recursive Sources Tests`; the soundness check on
  every pull request runs the same rules, an API breakage check against the base branch, and
  shellcheck and yamllint.
- File headers follow the existing files: name, package, author, date.

## Releases

- Every pull request carries exactly one label: `⚠️ semver/major`, `🆕 semver/minor`,
  `🔨 semver/patch`, or `semver/none`. The label check blocks merging without one.
- Releases are GitHub Releases, created by the Auto Release workflow: run it by hand on `main`
  and it computes the next version from the labels of the pull requests merged since the last
  release, tags it, and writes the notes from `.github/release.yml`. A major bump is refused
  there and is cut by hand.
- Consumers pin by tag, never by branch or path.

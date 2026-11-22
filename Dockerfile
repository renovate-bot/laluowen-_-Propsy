# Built from GoReleaser's prebuilt binaries (see .goreleaser.yaml's `builds`
# and `dockers_v2` sections) — this Dockerfile does NOT run `go build`, since
# that would compile the binary a second time, once per target platform, on
# top of GoReleaser already having done it. For a plain `docker build .`
# without GoReleaser (e.g. quick local testing), build the binary yourself
# first: CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o linux/amd64/propsy
# ./cmd/propsy, then `docker build --build-context .=.` from here — or just
# run `goreleaser release --snapshot --clean`, which does both steps for
# every supported platform.
# Keep this file free of RUN steps: the release builds the linux/arm64 image on an
# amd64 runner without QEMU (see .github/workflows/release.yml), which only works
# while nothing needs to execute inside the image.
FROM gcr.io/distroless/static-debian13:nonroot@sha256:89e00a7e78df216bcbf495e7f43135f03ddbd3e98024a4104731872d6c8cf3c6
ARG TARGETPLATFORM
WORKDIR /app
COPY $TARGETPLATFORM/propsy /app/propsy
EXPOSE 8080
USER nonroot:nonroot
CMD ["/app/propsy"]

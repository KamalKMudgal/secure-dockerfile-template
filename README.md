# Secure Dockerfile Template

A production-minded Node.js container baseline. It uses a multi-stage build, a small runtime image, a non-root user, explicit production dependencies, and a read-only-friendly layout.

## Included defaults

- Multi-stage build: compilers and dev dependencies stay out of the runtime image.
- Non-root runtime account with no login shell.
- Deterministic dependency install via `npm ci`.
- `NODE_ENV=production` and only runtime dependencies in the final image.
- A restrictive `.dockerignore`.
- CI builds the image and scans the repository configuration with Trivy.

## Use

1. Copy `Dockerfile` and `.dockerignore` into your Node.js project.
2. Replace `src/server.js` with your application entry point.
3. Pin the base-image tag to a digest after testing it in your own build pipeline.
4. At deployment, set a read-only root filesystem, drop Linux capabilities, and supply secrets through the platform secret store—never the Dockerfile or image.

```sh
docker build --pull --tag my-service:local .
docker run --rm --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m -p 3000:3000 my-service:local
```

This is a starting point, not a substitute for application dependency management, runtime policy, and regular image updates.

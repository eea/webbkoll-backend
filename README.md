# Webbkoll backend

This is the backend for the [Webbkoll](https://github.com/andersju/webbkoll) site checker.
It's a tiny script that makes use of [Puppeteer](https://github.com/GoogleChrome/puppeteer).
It visits a given URL with Chromium and returns JSON with headers, cookies, requests, etc.
It's not pretty.

## Docker deployment

The recommended deployment method is via Docker. The `Dockerfile` builds a container with:

- **Node 24** base image
- **Google Chrome Stable** (system Chromium, not Puppeteer's bundled copy)
- **Shallow clone** of upstream source from [dataskydd.net/webbkoll-backend](https://codeberg.org/dataskydd.net/webbkoll-backend)
- **Non-root user**: runs as `node` user with sandbox-disabled Chrome flags (`--no-sandbox`, `--disable-setuid-sandbox`)
- **dumb-init** as PID 1 for proper signal handling

Build and run:

```sh
docker build -t webbkoll-backend .
docker run -p 8100:8100 webbkoll-backend
```

## Manual setup (without Docker)

Node 24+ required. Run `npm install`, which installs everything necessary including a local copy of Chromium; then `npm start` (or `node index.js`) to start.

Usage: `http://localhost:8100/?fetch_url=http://www.example.com`

Make sure you have all necessary system dependencies; see [Puppeteer's troubleshooting page](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md) for e.g. a list of necessary Ubuntu/Debian packages.

The script listens to port 8100 by default. Output is logged to `webbkoll-backend.log`.
Note that this script should be considered highly experimental, and it has NO throttling
or access control whatsoever -- this needs to be handled elsewhere (for Webbkoll the frontend handles this).
Don't put it on a public-facing server unless you're looking for trouble.

Inspired by [Puppeteer as a Service](https://github.com/GoogleChromeLabs/pptraas.com).

### Keep it running

Sample systemd unit file:

```
[Unit]
Description=Webbkoll-backend

[Service]
Type=simple
ExecStart=/usr/bin/npm start
WorkingDirectory=/home/foobar/webbkoll-backend
User=foobar
Group=foobar
Restart=always

[Install]
WantedBy=multi-user.target
```

Run `systemctl daemon-reload` for good measure, and then try `systemctl start webbkoll-backend`.
(And `systemctl enable webbkoll-backend` to have it started automatically.)

## Important

Always upgrade both webbkoll and webbkoll-backend together — backward compatibility between versions is not guaranteed.

Upstream source: [codeberg.org/dataskydd.net/webbkoll-backend](https://codeberg.org/dataskydd.net/webbkoll-backend)
EEA fork: [github.com/eea/webbkoll-backend](https://github.com/eea/webbkoll-backend)

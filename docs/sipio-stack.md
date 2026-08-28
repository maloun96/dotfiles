# sipio — the Reshetcall local platform stack

Everything needed to run the Cloudflare Workers platform in `~/www/sipcf`.
The `sipio` function lives in `~/.dotfiles/functions.zsh` (sourced from `.zshrc:123`).

Services run **detached in the background**, each writing stdout+stderr to
`~/.local/state/sipio/logs/<svc>.log`. No terminal multiplexer is involved, so
this works in any terminal, over ssh, and from a non-interactive shell. Use
`sipio logs <svc>` where you would once have looked at a tab.

```
sipio --help
```

---

## Commands

| Command | What it does |
|---|---|
| `sipio run <svc>…` | start (or restart) one or more services, detached — e.g. `sipio run fe app idp` (a bad or ambiguous name aborts the whole set before anything is killed; anything that dies within 2s is reported with a pointer to its log) |
| `sipio run <svc> --here` | run it in the current shell instead (foreground, Ctrl+C stops) — one service only |
| `sipio <svc>…` | shorthand for `sipio run <svc>…` |
| `sipio all` | core stack — idp app ctl fin pay did crm mon fe |
| `sipio full` | everything, incl. contaqt-new and the Vite frontends |
| `sipio stop` | kill every service (its PID, then anything still holding its ports) |
| `sipio status` | host-by-host health table, with PIDs |
| `sipio logs <svc>` | `tail -f` one service's log (`sipio logs` interleaves them all; `-n 50` prints the last 50 lines and exits) |
| `sipio seed` | migrate + seed all planes, then drift-check |
| `sipio drift` | drift-check only |
| `sipio open <svc>` | open `http://localhost:<port>` — always works |
| `sipio web <svc>` | open `https://<svc>.sip.test` — needs the Valet proxies |
| `sipio ls` | list services, hostnames, ports, directories |

Aliases: `stack` = `sipio all`, `stackfull` = `sipio full`, `stackstop` = `sipio stop`,
`stacklogs` = `sipio logs`.

`<svc>` accepts the **short name** (`app`), the **hostname** (`app.sip.test`), or the
**repo directory** (`pbx-api`) — the bare repo name, not its product group. A repo holding
several services (`contaqt-new`) lists the candidates rather than guessing, and so does a
bare group name (`PBX`).

---

## Services

### Core — `sipio all`

| svc | hostname | port | insp | directory |
|---|---|---|---|---|
| `idp` | idp.sip.test | 8791 | 9241 | `sip-idp/workers/id` |
| `app` | app.sip.test | 8793 | 9244 | `PBX/pbx-api/workers/api` |
| `ctl` | control.sip.test | 8794 | 9245 | `SIP/sip.io-v2` |
| `fin` | billing.sip.test | 8795 | 9242 | `FINANCE/financial-worker/workers/finance` |
| `pay` | payments.sip.test | 8796 | 9243 | `FINANCE/payment-gateway/workers/gateway` |
| `did` | numbers.sip.test | 8797 | 9250 | `DIDHUB/didhub-worker` |
| `crm` | crm.sip.test | 8787 | 9251 | `CONTAQT/contaqt-crm/apps/api` |
| `mon` | monitor.sip.test | 8788 | — | `platform-dev` (flow-monitor) |
| `fe` | pbx.sip.test | 3000 | — | `PBX/pbx/frontend` |

### Extra — only via `sipio full`

| svc | hostname | port | insp | directory |
|---|---|---|---|---|
| `ws` | workspace.sip.test | 8703 | 9260 | `CONTAQT/contaqt-new/apps/workspace` (bundles `core`) |
| `ev` | events.sip.test | 8704 | 9262 | `CONTAQT/contaqt-new/apps/events` |
| `chat` | chat.sip.test | 8706 | 9261 | `CONTAQT/contaqt-new/apps/chat` |
| `cnui` | workspace-ui.sip.test | 5177 | — | `CONTAQT/contaqt-new/apps/workspace-ui` |
| `dhc` | dashboard.sip.test | 5175 | — | `DIDHUB/didhub-customer` |
| `fraud` | fraud.sip.test | 5176 | — | `SIP/fraud-screen-dashboard` |
| `svx` | spanvox.sip.test | 8798 | 9252 | `spanvox/spanvox-api` |
| `svxd` | spanvox-admin.sip.test | 5178 | — | `spanvox/spanvox-dashboard` |
| `wp` | — | — | — | `PBX/webphone` (watch build → `PBX/pbx/frontend/public/webphone/`) |

**A `404` on `/` means the worker is up** and simply has no root route. `DOWN` is the
real failure signal.

Spanvox is a separate product, so `svx` and `svxd` sit in `sipio full`, not
`sipio all` — but `sipio svx svxd` starts them on their own. Two services now share
the `spanvox/` group, so a bare `sipio spanvox` is ambiguous and lists both; address
them by short name (`svx`, `svxd`) or repo (`spanvox-api`, `spanvox-dashboard`).
The dashboard reads its API base from `spanvox-dashboard/.env.development*`, pinned
to `svx`'s 8798. `spanvox-phone` and `spanvox-sbc` are still not in the registry.

Not in the stack: `sipio-id` / `sipio-id-v2` (superseded by `sip-idp`),
`rest-kit` (library).

---

## Valet proxies

All 16 are registered **with TLS** — `https://idp.sip.test` and friends, on a
locally-trusted cert. To re-register them (new machine, or after `valet uninstall`):

```bash
zsh ~/.dotfiles/bin/valet-sip-proxies.sh
```

That script re-runs every `valet proxy <host> <target> --secure`. Drop `--secure`
for plain HTTP. Remove one with `valet unproxy idp.sip`; list them with
`valet proxies` (the `SSL` column shows which are secured).

**Valet needs a TTY for sudo.** It shells out to `sudo` for every command, so it
cannot run from a non-interactive context — neither Claude Code's `!` prefix nor a
scripted shell. Run it in a real terminal tab.

> **Proxying rewrites the `Host` header.** sip-idp mints `iss: http://localhost:8791`,
> so OAuth flows can behave differently through `idp.sip.test` than through localhost.
> When something works on the port but not the hostname, that's the first suspect —
> use `sipio open <svc>` to reach the raw port.

---

## First-time setup

```bash
cd ~/www/sipcf/platform-dev
npm run bootstrap     # clone/pull all 13 repos as siblings + link shared Claude skills
sipio all             # start the core stack (finance must be up before seeding)
sipio seed            # migrate + seed every plane, then drift-check
```

`sipio seed` runs the whole chain: `npm run seed` (migrate + seed the 4 offline
planes) → `npm run seed:finance` (the finance tier needs its **live** worker, because
balances and subscriptions are Durable-Object state) → `npm run drift`.

A green drift check is **27 passed, 0 failed**.

### Migrations that platform-seed does NOT cover

```bash
cd ~/www/sipcf/CONTAQT/contaqt-crm/apps/api && npx wrangler d1 migrations apply crm-prod --local
cd ~/www/sipcf/DIDHUB/didhub-worker        && npx wrangler d1 migrations apply didhub-prod --local -c wrangler.local.toml
cd ~/www/sipcf/spanvox/spanvox-api         && npm run migrate:local
```

contaqt-crm also needs generated keys before it will boot:

```bash
cd ~/www/sipcf/CONTAQT/contaqt-crm/apps/api
node scripts/bootstrap.mjs      # prints secrets → .dev.vars, plus brand seed SQL
```

---

## Gotchas

Each of these cost real debugging time. They are why the function looks the way it does.

**Node 22 is mandatory.** Wrangler refuses anything older and fails with a bare
"Wrangler requires at least Node.js v22.0.0". `nvm alias default 22` is set, but a
detached service runs in a **non-interactive shell that never sources `.zshrc`**, so
`nvm` does not exist there — `sipio` resolves `~/.nvm/versions/node/v22.*/bin` itself
and prepends it to that process's `PATH`. If you launch a worker by hand from an odd
shell, check `node -v` first.

**Every wrangler worker needs its own `--inspector-port`.** They all default to
`9229`; the second one onward dies with `Address already in use (127.0.0.1:9229)` —
and the message points at the *inspector* port, not the service port, which makes it
easy to misread. Every entry in the registry carries a distinct one.

**`wrangler dev` leaves orphaned `workerd` children.** A plain `kill` of the parent
leaves `workerd` holding *both* the service port and the inspector port. `sipio stop`
sends TERM, waits, then escalates to `-9` on anything still bound. Symptom if you skip
this: the next start fails on a port you're certain is free.

**`DIDHUB/didhub-worker` needs `wrangler.local.toml`.** Its real config has
`[[send_email]] remote = true`, which forces a remote proxy session and hard-fails
without a Cloudflare login. The local variant comments that flag out. Same pattern as
sip.io-v2's committed `wrangler.local.jsonc`. It also serves `ui/dist`, so run
`npm run build:ui` once or the worker won't boot.

**`CONTAQT/contaqt-new/apps/workspace` serves `workspace-ui/dist`** — run `npx vite build` in
`apps/workspace-ui` once, or the worker exits on a missing assets directory.

**Switching branches invalidates the local D1.** After moving `SIP/sip.io-v2` from a
feature branch back to `main`, migrations failed with `duplicate column name: color` —
the local database still held the feature branch's schema. Delete the local state and
re-seed:

```bash
rm -rf ~/www/sipcf/SIP/sip.io-v2/.wrangler-dev/v3/d1 \
       ~/www/sipcf/SIP/sip.io-v2/workers/api/.wrangler/state/v3/d1
sipio seed
```

**`DIDHUB/didhub-worker` migration 0041 is broken on a fresh database.** 0001–0040 apply
fine; `0041_rate_sheet_manual_upload_type.sql` then selects `trunk_id` from a table
that only has `trunk_group_id` — a rename step is missing from the chain (0046's own
header notes 0044 "was numbered 0040 before renumbering"). The worker runs fine at the
0040 schema. Don't "fix" it casually: 0041 and 0044 use the destructive SQLite
rename-create-copy-drop pattern that 0046 documents as having already destroyed ~474K
`termination_rate` rows once.

**Wiring the PBX frontend to the stack.** `PBX/pbx/frontend/.env` (gitignored) drives it.
Four settings matter, and three of them are non-obvious:

```
NEXT_PUBLIC_API_URL=https://app.sip.test/api      # pbx-api — note the /api suffix
NEXT_PUBLIC_SIP_API_URL=https://control.sip.test/v1   # sip.io-v2 — /v1 belongs in the baseURL
VITE_IDP_URL=https://idp.sip.test
VITE_TENANT_SUBDOMAIN_ROUTING=false
```

`VITE_TENANT_SUBDOMAIN_ROUTING` defaults to **true**, which rewrites every call to
`{tenant}.<apiHost>/api`. That silently worked against `localhost:8793` (`*.localhost`
resolves) but breaks on `app.sip.test` — Valet serves the exact host only. The v2
workers resolve the tenant from the Bearer token, so this must be `false`.

**A new FE origin must be allowlisted on BOTH planes — they have separate lists.**
The FE talks to pbx-api *and* directly to sip.io-v2 `/v1` (no BFF proxy — that's a hard
invariant), so each worker gates the origin independently:

| Plane | File | Var |
|---|---|---|
| pbx-api | `PBX/pbx-api/workers/api/wrangler.jsonc` | `CORS_ORIGINS` (`vars` block) |
| sip.io-v2 | `SIP/sip.io-v2/workers/api/wrangler.jsonc` | `CORS_ORIGINS` (`vars` block) |

Fixing only pbx-api gets you a successful login followed by a wall of
`blocked by CORS policy` on `control.sip.test/v1/*`. Both need
`https://pbx.sip.test`.

`/api/auth/*` on pbx-api is stricter still — it uses `AUTH_CORS_ORIGINS`, falling back to
only the **non-wildcard** entries of `CORS_ORIGINS`, and turns an unapproved origin away
with `403 origin_not_allowed`. A wildcard like `https://*.sip.test` will not make login
work; the exact origin has to be listed.

**pbx-api needs `IDP_SVC_HMAC_KEY` to log anyone in.** Without it, login fails
`401 idp_svc_key_missing`. sip-idp refuses an unattested scope push (CT-21), so pbx-api
signs the backchannel call with a per-product key. sip-idp's dev default lives in
`sip-idp/workers/id/wrangler.jsonc` as `SVC_HMAC_KEYS` — pbx's entry is
`dev-pbx-svc-key`, and that value goes in `PBX/pbx-api/workers/api/.dev.vars`:

```
IDP_SVC_HMAC_KEY=dev-pbx-svc-key
```

It is *not* in `.dev.vars.example`, so a fresh checkout has a working stack that cannot
log in. Verify the whole chain with:

```bash
curl -s -X POST https://app.sip.test/api/auth/login \
  -H 'Origin: https://pbx.sip.test' -H 'Content-Type: application/json' \
  -d '{"email":"demo@pbx.im","password":"password"}'
```

A healthy response is `200` with an `access_token` whose payload carries
`sipio_account_id: acc_test` and `sip_user: us_1001`.

**Vite blocks unknown hostnames.** Reaching a Vite dev server through a proxy
hostname returns `Blocked request. This host ("pbx.sip.test") is not allowed` —
Vite's DNS-rebinding guard. There is no CLI flag; it only reads
`server.allowedHosts` from config. All four Vite apps (pbx/frontend,
contaqt-new/apps/workspace-ui, didhub-customer, fraud-screen-dashboard) now carry
`allowedHosts: [".sip.test"]`. A new Vite frontend needs the same line.

**A crash on startup is silent without the log.** There is no tab to glance at, so
`sipio` waits 2s after starting a set and reports anything already dead. Slower
failures (a worker that binds, then throws on first request) only show up in
`sipio logs <svc>` — that is the first place to look when `sipio status` says `DOWN`.

**Logs are truncated on every start.** `sipio run <svc>` overwrites
`logs/<svc>.log`. Copy it elsewhere before restarting if you need to keep a trace.

---

## Environment

| Var | Default | Purpose |
|---|---|---|
| `SIPIO_ROOT` | `~/www/sipcf` | where the repos live |

State lives under `~/.local/state/sipio/`: `procs` maps `svc|host|port|pid` for what
is running, and `logs/<svc>.log` holds each service's output. Deleting `procs` only
costs you the PID column in `sipio status` — `sipio stop` still frees every port.

Local secrets (all gitignored or untracked, none of them real): `.dev.vars` in
pbx-api, financial-worker, payment-gateway, didhub-worker and contaqt-crm; `.env` in
fraud-screen-dashboard. The shared values must match across services —
`PARENT_JWT_SECRET` is shared by pbx-api and finance, and finance's
`GATEWAY_HMAC_SECRET` must equal the gateway's `BILLING_ENGINE_HMAC_SECRET`.

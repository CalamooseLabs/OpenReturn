# Foundations & Grants

OpenReturn distinguishes **foundations** (private foundations, which file IRS
**Form 990-PF**) from **nonprofits** (public charities filing 990 / 990-EZ / 990-N),
lets users **follow** organizations, and exposes a foundation's **grants** and the
nonprofits they fund. This is built almost entirely from data already captured at
ingest — the form filed and the grant graph — so it needs no extra import.

## Classification (`org_type` + `is_grantmaker`)

Every organization carries two **derived, cached** fields (on the org response and
filterable in search):

| Field | Values | Meaning |
|-------|--------|---------|
| `org_type` | `foundation` | the org has **ever filed a 990-PF** (a private foundation) |
| | `nonprofit` | filed a 990 / 990-EZ / 990-N (a public charity) and never a 990-PF |
| | `other` | only a different return (e.g. 990-T) |
| | `null` | no IRS return on file (e.g. audited-only data) |
| `is_grantmaker` | `true` / `false` | the org has **grant records** — true for any grantmaker, including a public charity that grants via **Schedule I**, not only 990-PF filers |

`org_type` and `is_grantmaker` are **orthogonal**: a 990-PF foundation is almost
always a grantmaker, but a public charity that runs a grant program is a
`nonprofit` that is *also* a grantmaker.

**It is a cache.** The classification is (re)derived for touched orgs at the end of
every ingest, and you can rebuild it for the whole database at any time:

```bash
openreturn classify        # (re)derive org_type + is_grantmaker for all orgs
```

A freshly imported database has correct classification only after that finalize /
rebuild (the same contract as scores and the search index). An org that has filed
both a 990 and a 990-PF (in different years) classifies as a **foundation** —
990-PF dominates.

## Sector (NTEE major group)

`org_type` says *what kind of filer* an org is; **sector** says *what field it
works in* — Arts, Education, Health, Human Services, etc. Unlike `org_type` and
`is_grantmaker`, sector is **not derivable from the 990**: the e-file XML carries
no NTEE code (only free-text mission and noisy per-program NAICS activity codes).
So sector is an **assignable attribute**, seeded with the ~26
[NTEE major groups](https://nccs.urban.org/publication/irs-activity-codes)
(`A`–`Z`) and set per org through the existing CRUD:

```
POST /organizations        { "ein": "364348917", "sector_code": "I" }   # on create
POST /organizations/edit   { "ein": "364348917", "sector_code": "I" }   # or later
GET  /organizations/sectors                                             # the vocabulary
```

Every org response carries `sector_code` + `sector_name` (`null` until assigned),
and search filters on it: `GET /organizations/search?sector=E&state=TX`. The
`sector` table has a `parent_code` column reserved for grouping the majors into
custom buckets later; a BMF/NTEE import keyed on EIN could backfill assignments in
bulk (not yet built). See the [Frontend Guide](frontend.md) for the
sector-dropdown + assignment recipe.

## Discover & search by type

The org [list](api.md#get-organizations) and [search](api.md#get-organizationssearch)
endpoints take `type`, `grantmaker`, and `sector` filters, combinable with the
name / EIN / state / city / county filters:

```
GET /organizations/search?type=foundation&state=TX        # foundations in Texas
GET /organizations/search?grantmaker=1&q=community         # grantmakers named "community…"
GET /organizations/search?sector=E&county=48453            # Health orgs in Travis County, TX
GET /organizations?type=nonprofit                          # browse nonprofits
```

Every organization in the response carries `org_type`, `is_grantmaker`, and (for a
logged-in user) a `following` flag.

## Follow / track organizations

A logged-in user keeps a personal **watchlist** — handy for tracking a set of
foundations. Following is a *user* action (a program / API key has no watchlist).
Requires `follow:read` / `follow:write` (granted to viewer, editor, admin).

```
POST /follows/follow      { "ein": "364348917" }     # follow
POST /follows/unfollow    { "ein": "364348917" }     # unfollow
GET  /follows                                         # my watchlist
GET  /follows?type=foundation                         # …filtered to foundations
```

The `following` flag on org [detail](api.md#get-organizationsdetail) and search
results tells the UI whether to show "Follow" or "Following".

## A foundation's grants (and who funds a nonprofit)

```
GET /organizations/grants?ein=<ein>&direction=made       # grants this org MADE (default)
GET /organizations/grants?ein=<ein>&direction=received   # grants this org RECEIVED
```

`made` is the **foundation → nonprofits** view: every grant the org reported, the
recipient, amount (cash + non-cash), year, kind, and purpose, plus a `summary`
(total $, distinct recipients, by-year). `received` lists the org's funders.

**Resolve to link 990-PF grants to recipients.** A 990-PF grant carries **no
recipient EIN** in the e-file XML, so a foundation→nonprofit link for PF grants is
populated only after the graph resolver enriches grantee identities:

```bash
openreturn resolve         # cluster grantees into canonical parties; link PF grant EINs
```

Schedule-I grants (from public charities) carry the recipient EIN as filed, so they
link immediately. See [Access Control](access-control.md) for the permissions each
route requires.

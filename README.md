# HLTV results scraper

Scrapes the latest Counter-Strike match results from
[hltv.org/results](https://www.hltv.org/results) and returns them as an array
of plain Ruby hashes.

HLTV is protected by Cloudflare, which blocks plain HTTP clients. This scraper
drives a real Chrome browser through [Ferrum](https://github.com/rubycdp/ferrum)
(raw Chrome DevTools Protocol, no chromedriver) to get past the challenge.

## Requirements

- Ruby 3.3+
- Google Chrome / Chromium (`google-chrome` on your `PATH`)
- On a headless server: `Xvfb` — Chrome must run **headed** or Cloudflare blocks it

```bash
bundle install
```

## Usage

```ruby
require 'hltv_scrap'

results = HltvScrap.results
results.first
# =>
# {
#   match_url:   "https://www.hltv.org/matches/2395492/9z-vs-parivision-...",
#   team1:       "9z",
#   crest1:      "https://img-cdn.hltv.org/teamlogo/....png",
#   score1:      "3",
#   team2:       "PARIVISION",
#   crest2:      "https://img-cdn.hltv.org/teamlogo/....png",
#   score2:      "0",
#   map:         "bo5",
#   event:       "XSE Pro League Guangzhou 2026",
#   event_crest: "https://img-cdn.hltv.org/eventlogo/....png",
#   date:        "2026-07-12"   # nil for featured results at the top
# }
```

`HltvScrap.get_results` is kept as an alias for backwards compatibility.

### Running on a server (no display)

Chrome must be headed, so wrap the process in a virtual display:

```bash
xvfb-run -a bundle exec ruby your_script.rb
```

### Injecting a custom client

`HltvScrap.results` accepts any object that responds to `#fetch(url)` and
returns HTML. This is handy for tests or for swapping in your own fetch logic:

```ruby
HltvScrap.results(client: my_client)
```

## Console

Open an IRB session with the code loaded (no install needed):

```bash
bundle exec bin/console
```

It exposes `HltvScrap.results` (live scrape) and `fixture_results` (parses the
saved fixture, no network). For a live scrape on a server, wrap it in Xvfb:

```bash
xvfb-run -a bundle exec bin/console
```

## Development

The scraper is split into two pieces so the parsing logic can be tested without
touching the network:

- `HltvScrap::Client` — fetches the rendered HTML with headed Chrome.
- `HltvScrap::Parser` — turns that HTML into result hashes.

Run the test suite (Minitest, runs against a saved HTML fixture — no network):

```bash
bundle exec rake test
```

Lint with RuboCop:

```bash
bundle exec rubocop
```

Run everything (tests are the default task):

```bash
bundle exec rake
```

## How the fixture is refreshed

`test/fixtures/results.html` is a trimmed snapshot of the live results page.
If HLTV changes its markup, re-capture the page (e.g. with a browser) and update
the fixture and the parser selectors together.

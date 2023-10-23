# Flood

## History

Flood is the merging of two development streams (1) GREAT #1, which was 9-months of work by mostly Luke Imhoff with
assistance from Trevor Rosen and Samuel Huckins on Pro integration; metasploit-framework testing from Juan Vazquez; and
design consultation with James "Egypt" Lee and David Maloney on metasploit-framework functionality, and (2) Electro,
which was the last mainline release of Metasploit.

### [Great #1](great-one)

GREAT #1 (GREAT Refactor Extension And Test Number 1) started out as a refactor of the `Mdm::Module` cache to support
the faster startups by having the cache being persistent.  (In Electro, the cache is deleted and recreated on each
restart of `msfconsole` or `prosvc`.)  Along the way, what could be helled in the cache was expanded and various bugs
with metasploit-framework were discovered, leading the the rename to GREAT #1.

The work on GREAT #1 occurred on [metasploit_data_models](great-one/metasploit_data_models.png) and
[metasploit-framework](great-one/metasploit-framework.png).  (Additionally, `metasploit-model` was extracted from
`metasploit_data_models`, but that was a side-effect of the belief that `metasploit-framework` could not use SQLite3 for
the cache and the cache had to be modeled using in-memory ActiveModels.)

## Goals

The [plan for Flood](overview.png) involves

* Finishing [left-over work from Electro](remaining-credentials-work.png)
* [Updating to Ruby 2.1](ruby.png) (Led by James "Egypt" Lee)
* Updating to Rails 4.1 (Led by Lance Sanchez)
* Extracting [metasploit-cache](metasploit-cache.png) from metasploit-model and metasploit_data_models to support both a
  PostgreSQL and SQLite3 backend for cache. (Led by Luke Imhoff)
* Extracting [metasploit-search](metasploit-search.png) from metasploit-model and metasploit_data_models so the
  search tech can be used in `metasploit-cache`. (Led by Luke Imhoff)
* Extracting version_spec shared examples into [metasploit-version](metasploit-version.png). Additionally, rake tasks
  will be define to make updating the version.rb easier. (Led by Luke Imhoff)
* Extracting `rake yard` into [metasploit-yard](metasploit-yard.png) so that it doesn't get defined 6 times in pro, which
  causes delays when running `rake yard`. (Led by Luke Imhoff)
* Porting [GREAT #1 changes to metasploit-framework](great-one/metasploit-framework.png) in a piece-meal fashion, so
  that the changes needed for the cache can be separated from the bug fixes found along the way.  (Led by Luke Imhoff)

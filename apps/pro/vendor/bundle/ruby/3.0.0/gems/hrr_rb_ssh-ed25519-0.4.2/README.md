# HrrRbSsh::Ed25519

[![Build Status](https://travis-ci.org/hirura/hrr_rb_ssh-ed25519.svg?branch=master)](https://travis-ci.org/hirura/hrr_rb_ssh-ed25519)
[![Maintainability](https://api.codeclimate.com/v1/badges/07ebfd442f48308b52f6/maintainability)](https://codeclimate.com/github/hirura/hrr_rb_ssh-ed25519/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/07ebfd442f48308b52f6/test_coverage)](https://codeclimate.com/github/hirura/hrr_rb_ssh-ed25519/test_coverage)
[![Gem Version](https://badge.fury.io/rb/hrr_rb_ssh-ed25519.svg)](https://badge.fury.io/rb/hrr_rb_ssh-ed25519)

hrr_rb_ssh-ed25519 is an hrr_rb_ssh extension that supports ED25519 public key algorithm.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
    - [Requiring libraries](#requiring-libraries)
- [Supported Features](#supported-features)
    - [Authentication layer](#authentication-layer)
    - [Transport layer](#transport-layer)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [License](#license)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hrr_rb_ssh'
gem 'hrr_rb_ssh-ed25519'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install hrr_rb_ssh
$ gem install hrr_rb_ssh-ed25519
```

## Usage

### Requiring libraries

`hrr_rb_ssh-ed25519` can be used with `hrr_rb_ssh` library.

```ruby
require 'hrr_rb_ssh'
require 'hrr_rb_ssh/ed25519'
```

Then, supported and preferred algorithm lists show `ssh-ed25519`.

```ruby
p HrrRbSsh::Transport::ServerHostKeyAlgorithm.list_supported
# => [(snipped,) "ssh-ed25519" (,snipped)]
p HrrRbSsh::Transport::ServerHostKeyAlgorithm.list_preferred
# => [(snipped,) "ssh-ed25519" (,snipped)]
```

## Supported Features

The following features are supported.

### Authentication layer

- Public key authentication
    - ssh-ed25519

### Transport layer

- Server host key algorithm
    - ssh-ed25519

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hirura/hrr_rb_ssh-ed25519. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hirura/hrr_rb_ssh-ed25519/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the HrrRbSsh::Ed25519 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hirura/hrr_rb_ssh-ed25519/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).

# ronin-recon

[![CI](https://github.com/ronin-rb/ronin-recon/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-recon/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-recon.svg)](https://codeclimate.com/github/ronin-rb/ronin-recon)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-recon)
* [Issues](https://github.com/ronin-rb/ronin-recon/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-recon)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-recon is a micro-framework and tool for performing reconnaissance.
ronin-recon uses multiple workers which process different value types
(ex: IP, host, URL, etc) and produce new values. ronin-recon contains built-in
recon workers and supports loading additional 3rd-party workers from Ruby
files or 3rd-party git repositories. ronin-recon has a unique queue design
and uses asynchronous I/O to maximize efficiency.

## Features

* Uses asynchronous I/O and fibers.
* Supports defining recon modules as plain old Ruby class.
* Provides built-in recon workers for:
  * DNS lookup of host-names.
  * Getting nameservers.
  * Getting mailservers.
  * DNS reverse lookup of IP addresses.
* Supports loading additional recon modules from Ruby files or from installed
  3rd-party git repositories.
* Builds a network graph of all discovered assets.
* Provides a simple CLI for listing workers or performing recon.

## Synopsis

```shell
$ ronin-recon
Usage: ronin-recon [options]

Options:
    -V, --version                    Prints the version and exits
    -h, --help                       Print help information

Arguments:
    [COMMAND]                        The command name to run
    [ARGS ...]                       Additional arguments for the command

Commands:
    help
```

## Examples

```ruby
require 'ronin/recon/engine'

domain = Ronin::Recon::Values::Domain.new('github.com')

Ronin::Recon::Engine.run([domain], max_depth: 3) do |value,parent|
  case value
  when Ronin::Recon::Values::Domain
    puts "Found domain #{value} for #{parent}"
  when Ronin::Recon::Values::Nameserver
    puts "Found nameserver #{value} for #{parent}"
  when Ronin::Recon::Values::Mailserver
    puts "Found mailserver #{value} for #{parent}"
  when Ronin::Recon::Values::Host
    puts "Found host #{value} for #{parent}"
  when Ronin::Recon::Values::IP
    puts "Found IP address #{value} for #{parent}"
  end
end
```

## Requirements

* [Ruby] >= 3.0.0
* [ronin-support] ~> 1.0
* [ronin-core] ~> 0.1
* [ronin-repos] ~> 0.1

## Install

```shell
$ gem install ronin-recon
```

### Gemfile

```ruby
gem 'ronin-recon', '~> 0.1'
```

### gemspec

```ruby
gem.add_dependency 'ronin-recon', '~> 0.1'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-recon/fork)
2. Clone It!
3. `cd ronin-recon/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

ronin-recon - A micro-framework and tool for performing reconnaissance.

Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-recon is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-recon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-recon.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
## [2.0.1] - 2019-06-10
### Added
- Adds ability to use environment variables.

## [2.0.0] - 2019-06-06
### Breaking Changes
- Update minimum required ruby version to 2.3. Drop unsupported ruby versions.
- Update dependancy on sensu-plugin to 4.0

### Added
- Travis build automation to generate Sensu Asset tarballs that can be used n conjunction with Sensu provided ruby runtime assets and the Bonsai Asset Index
- Require latest sensu-plugin for Sensu Go support

## [1.0.0] - 2017-07-6
### Added
- Ruby 2.3 & 2.4 testing

### Breaking Changes
- Dropped Ruby 1.9.3 support
- Updated JSON dependency to 1.8.5

### Fixed
- PR template spelling

## [0.1.0] - 2015-11-06
### Fixed
- create binstubs only for ruby files

### Added
- Added settingsname and routing_key options

## [0.0.3] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.2] - 2015-06-03
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

## 0.0.1 - 2015-05-21
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-victorops/compare/1.1.0...HEAD
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-victorops/compare/1.1.0...1.1.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-victorops/compare/0.0.3...0.1.0
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-victorops/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-victorops/compare/0.0.1...0.0.2

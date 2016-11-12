# ivy-serializers

See [changes since release][HEAD]

## [0.3.0][] / 2015-06-05

* Gracefully handle `nil` in belongs-to relationships.
* Update JSON-API format for 1.0.
* Always include an `id` attribute for all resources, per JSON-API spec.

## [0.2.0][] / 2015-05-05

* Fixes a bug where the JSON-API format wouldn't use the `:data` key as the
  top-level when rendering a collection, and ensures that the
  `ActiveModel::Serializers` format uses a singular key when rendering an
  individual resource.
* Extract Rails integration into `ivy-serializers-rails`.

## [0.1.0][] / 2015-05-01

* Initial release.

[0.1.0]: https://github.com/IvyApp/ivy-serializers/tree/v0.1.0
[0.2.0]: https://github.com/IvyApp/ivy-serializers/compare/v0.1.0...v0.2.0
[0.3.0]: https://github.com/IvyApp/ivy-serializers/compare/v0.2.0...v0.3.0
[HEAD]: https://github.com/IvyApp/ivy-serializers/compare/v0.3.0...master

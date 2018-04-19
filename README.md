MONSTODON
=========

<!--  Update these links/images once we have Travis up and running  -->

<!--
[![Build Status](https://img.shields.io/travis/tootsuite/mastodon.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/maintainability/tootsuite/mastodon.svg)][code_climate]
-->

<!--
[travis]: https://travis-ci.org/tootsuite/mastodon
[code_climate]: https://codeclimate.com/github/tootsuite/mastodon
-->

Monstodon is an implementation of [ActivityMon](https://gist.github.com/marrus-sh/b964a9c98cec9b8e306afe4834472732) on top of [Mastodon](https://github.com/tootsuite/mastodon).
It is a **free, open-source social network server** based on **open web protocols** like ActivityPub and OStatus—only with support for cute monsters as well :3

**Ruby on Rails** is used for the back-end, while **React.js** and Redux are used for the dynamic front-end. A static front-end for public resources (profiles and statuses) is also provided.

If you would like, you can [support the development of this project on Patreon][patreon] or [Liberapay][liberapay]. 

[patreon]: https://www.patreon.com/kibigo
[liberapay]: https://liberapay.com/kibigo/

---

## Mastodon Resources

- [Frequently Asked Questions](https://github.com/tootsuite/documentation/blob/master/Using-Mastodon/FAQ.md)
- [Use this tool to find Twitter friends on Mastodon](https://bridge.joinmastodon.org)
- [API overview](https://github.com/tootsuite/documentation/blob/master/Using-the-API/API.md)
- [List of Mastodon instances](https://github.com/tootsuite/documentation/blob/master/Using-Mastodon/List-of-Mastodon-instances.md)
- [List of apps](https://github.com/tootsuite/documentation/blob/master/Using-Mastodon/Apps.md)
- [List of sponsors](https://joinmastodon.org/sponsors)

## Monstodon Features

**Support for cute, federated mon :3**

Who doesn't want a cute mon or several on your ActivityPub profile???

## Mastodon Features

**No vendor lock-in: Fully interoperable with any conforming platform**

It doesn't have to be Mastodon, whatever implements ActivityPub or OStatus is part of the social network!

**Real-time timeline updates**

See the updates of people you're following appear in real-time in the UI via WebSockets. There's a firehose view as well!

**Federated thread resolving**

If someone you follow replies to a user unknown to the server, the server fetches the full thread so you can view it without leaving the UI

**Media attachments like images and short videos**

Upload and view images and WebM/MP4 videos attached to the updates. Videos with no audio track are treated like GIFs; normal videos are looped - like vines!

**OAuth2 and a straightforward REST API**

Mastodon acts as an OAuth2 provider so 3rd party apps can use the API

**Fast response times**

Mastodon tries to be as fast and responsive as possible, so all long-running tasks are delegated to background processing

**Deployable via Docker**

You don't need to mess with dependencies and configuration if you want to try Mastodon, if you have Docker and Docker Compose the deployment is extremely easy

---

## Development

Please follow the [development guide](https://github.com/tootsuite/documentation/blob/master/Running-Mastodon/Development-guide.md) from the documentation repository.

## Deployment

There are guides in the documentation repository for [deploying on various platforms](https://github.com/tootsuite/documentation#running-mastodon).

## Contributing

You can open issues for bugs you've found or features you think are missing. You can also submit pull requests to this repository. [Here are the guidelines for code contributions](CONTRIBUTING.md)

**IRC channel**: #mastodon on irc.freenode.net

## License

Forked from Mastodon, copyright (C) 2016-2018 Eugen Rochko & other Mastodon contributors (see AUTHORS.md).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

---

## Extra credits

The elephant friend illustrations are created by [Dopatwo](https://mastodon.social/@dopatwo)

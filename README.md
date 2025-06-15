# 🐻‍❄️ BearPublish

![Icon](img.png)

Static site generator for Bear Notes.

## Overview

**BearPublish** transforms a Bear Notes database into a static website.

## Project Architecture

### Modules

- `BearDatabase`: SQL logic to extract notes, metadata, tags, and files.
- `BearMarkdown`: Note content markdown parser with custom bear specific processors (file blocks, wikilinks, hex colors, etc...)
- `BearWebUI`: Web UI interface made with [Plot](https://github.com/JohnSundell/Plot).
- `BearDomain`: Intermediary domain objects that mediate between database and ui layers.

### Site Generation

- `BearSiteBuilder`: Builds `BearSite` with the needed data.
- `BearSiteRenderer`: Renders a `BearSite` with the provided renderers.
- `BearSiteGenerator`: Writes rendered site to output url and copies media files.
- `BearPublisher`: Composes the generator with the data providers and needed renderers. 
- `BearPublisherComposer`: Composes the publisher with data coming from the bear database and ui renders.
- `BearPublisherCLI`: command-line interface using `ArgumentParser`.

## Installation & Usage

Build and run the CLI. By default it outputs the site into a `dist` folder:

```
swift build -c release \
swift run
```

For custom output and paths, pass arguments:

```bash
swift build -c release
.build/release/BearPublishCLI \
  --db-path /path/to/database.sqlite \
  --files-folder-path /path/to/files \
  --images-folder-path /path/to/images \
  --output ./dist \
  --title "My Static Site" \
  --lang "en""
```

## Things I would do different if I started over

- Use vanilla js instead of htmx
- Better routing

## Contributing

This is a personal open source project. I don’t guarantee maintenance or support for feature requests, though improvements might happen depending on my availability.

## Third party

- [Plot](https://github.com/JohnSundell/Plot)
- [Markdownkit](https://github.com/objecthub/swift-markdownkit)
- [SQLite](https://github.com/stephencelis/SQLite.swift)

## License

MIT

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

## What I'd Do Differently (and Hope to Add Eventually)

- **Drop HTMX for vanilla JS** – HTMX helped speed up the prototype, but it's overkill for what this project needs. I’m mainly using `hx-get` and `hx-swap`, and the extra attributes feel like baggage.
  
- **Better routing** – Currently routes rely on query parameters (e.g., `?slug=note-slug`). I’d prefer cleaner URLs like `bearsit.es/note-slug`.

## Ideas for Future Improvements

- **Theme selection** – Right now, the only supported theme is Duotone Light (❤️). I’d like to support theme selection via CLI:  
  `BearPublishCLI (...args...) --theme duotone-light`
- **Frontend theme switcher** – Ideally, visitors should be able to select themes from the generated site's UI.
- **Fix UI bug** – There's a minor issue when selecting nested menu items that aren’t expanded yet.
- **Mac App** – I’d love to build a GUI for non-technical users to publish directly.
- **Tag-based note export** – Add support for filtering exported notes via tags:  
  `BearPublishCLI --tags [dev, code, articles]`
- **Companion app** – A lightweight CLI or GUI focused solely on exporting notes by tag in raw markdown.
- **Optimize CSS and JS** – These were initially written in 2023 to get a quick prototype running, so some parts may be ~~ugly~~~ repetitive or unoptimized.
- **Polish frontend and markdown parser** – Still have a lot of rough edges.

## Contributing

This is a personal open source project.  While I’d love to keep improving it, I can’t promise active maintenance or support for feature requests. That said, improvements may happen as time and energy allow.

Feel free to open issues or pull requests — just know that response times may vary (and sometimes take a while).

## Third party

- [Plot](https://github.com/JohnSundell/Plot)
- [Markdownkit](https://github.com/objecthub/swift-markdownkit)
- [SQLite](https://github.com/stephencelis/SQLite.swift)

## Related Projects

- [Bear PHP export script](https://gist.github.com/crisfeim/55e5c005f7e888ee0a380660b2dba8d5) — One of my first attempts of doing something like this.
- [Bearnotes Hugo theme](https://github.com/crisfeim/theme-hugo-bearnotes) — Basically the grandpa of this project.
- [Miyano](https://github.com/wuusn/miyano) — Main inspiration for this project.


## License

MIT

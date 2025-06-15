# 🐻‍❄️ BearPublish

![Icon](img.png)


Static site generator for Bear Notes.

## Overview

**BearPublish** transforms a Bear Notes database into a static website.

## Project Architecture

- `BearDatabase`: SQL logic to extract notes, metadata, tags, and files.
- `BearSiteBuilder` / `BearSiteRenderer`: transform models into HTML resources.
- `BearSiteGenerator`: writes output and copies media files.
- `BearPublisherComposer`: main programmatic entry point.
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
.build/release/BearPublisherCLI \
  --db-path /path/to/database.sqlite \
  --files-folder-path /path/to/files \
  --images-folder-path /path/to/images \
  --output ./dist \
  --title "My Static Site"
```

## License

MIT

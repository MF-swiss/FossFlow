# FossFLOW - Isometric Diagramming Tool <img width="30" height="30" alt="fossflow" src="https://github.com/user-attachments/assets/56d78887-601c-4336-ab87-76f8ee4cde96" />

<p align="center">
 <a href="README.md">English</a> | <a href="docs/README.cn.md">简体中文</a> | <a href="docs/README.es.md">Español</a> | <a href="docs/README.pt.md">Português</a> | <a href="docs/README.fr.md">Français</a> | <a href="docs/README.hi.md">हिन्दी</a> | <a href="docs/README.bn.md">বাংলা</a> | <a href="docs/README.ru.md">Русский</a> | <a href="docs/README.id.md">Bahasa Indonesia</a> | <a href="docs/README.de.md">Deutsch</a>
</p>


<p align="center">
<a href="https://trendshift.io/repositories/15118" target="_blank"><img src="https://trendshift.io/api/badge/repositories/15118" alt="FossFlow | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>
</p>

<b>Also!</b> If you haven't yet, please check out the underlying library this is built on by <a href="https://github.com/markmanx/isoflow">@markmanx</a> I truly stand on the shoulders of a giant here 🫡

## Try it online
<p align="center">
Go to  <b> --> https://mf-swiss.github.io/FossFlow/ <-- </b>
</p>
<p align="center">
</p>

------------------------------------------------------------------------------------------------------------------------------
FossFLOW is a powerful, open-source Progressive Web App (PWA) for creating beautiful isometric diagrams. Built with React and the <a href="https://github.com/markmanx/isoflow">Isoflow</a> (Now forked and published to NPM as fossflow) library, it runs entirely in your browser with offline support.

![Screenshot_20250630_160954](https://github.com/user-attachments/assets/e7f254ad-625f-4b8a-8efc-5293b5be9d55)

- **🤝 [CONTRIBUTING.md](https://github.com/MF-swiss/FossFlow/blob/main/CONTRIBUTING.md)** - How to contribute to the project.

## 🐳 Quick Deploy with Docker

```bash
# Using Docker Compose (recommended - includes persistent storage)
docker compose up

# Or run directly from Docker Hub with persistent storage
docker run -p 80:80 -v $(pwd)/diagrams:/data/diagrams mfswiss/fossflow:latest
```

Server storage is enabled by default in Docker. Your diagrams will be saved to `./diagrams` on the host.

### Step-by-Step Docker Guide (Recommended)

Use this if you want a reliable local setup without installing Node.js directly.

1. **Install and start Docker Desktop**
   - Ensure Docker Engine is running before continuing.

2. **Clone and enter the repository**
   ```bash
   git clone https://github.com/MF-swiss/FossFlow
   cd FossFLOW
   ```

3. **Start FossFLOW with the development compose file**
   ```bash
   docker compose -f compose.dev.yml up --build
   ```

4. **Open the app in your browser**
   - Frontend: [http://localhost:3000](http://localhost:3000)
   - Backend API: [http://localhost:3001](http://localhost:3001)

5. **Stop the stack**
   - Press `Ctrl + C` in the running terminal, then:
   ```bash
   docker compose -f compose.dev.yml down
   ```

6. **Run in background (optional)**
   ```bash
   docker compose -f compose.dev.yml up -d --build
   ```
   To stop background services:
   ```bash
   docker compose -f compose.dev.yml down
   ```

### Common Docker Troubleshooting

- **Port already in use (3000/3001)**: stop the process using that port, then restart compose.
- **Docker daemon not reachable**: restart Docker Desktop and wait until it is fully started.
- **Changes not visible**: restart with `--build` and hard refresh the browser.

To disable server storage, set `ENABLE_SERVER_STORAGE=false`:
```bash
docker run -p 80:80 -e ENABLE_SERVER_STORAGE=false mfswiss/fossflow:latest
```

### HTTP Basic Authentication (Optional)

Protect your FossFLOW instance with HTTP Basic Auth:

```bash
# With Docker Compose
HTTP_AUTH_USER=admin HTTP_AUTH_PASSWORD=secret docker compose up

# Or with docker run
docker run -p 80:80 \
  -e HTTP_AUTH_USER=admin \
  -e HTTP_AUTH_PASSWORD=secret \
   mfswiss/fossflow:latest
```

> **Note**: Both variables must be set to enable authentication. If either is empty, the app is accessible without login.

## Quick Start (Local Development)

```bash
# Clone the repository
git clone https://github.com/MF-swiss/FossFlow
cd FossFLOW

# Install dependencies
npm install

# Build the library (required first time)
npm run build:lib

# Start development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Monorepo Structure

This is a monorepo containing two packages:

- `packages/fossflow-lib` - React component library for drawing network diagrams (built with Webpack)
- `packages/fossflow-app` - Progressive Web App which wraps the lib and presents it (built with RSBuild)

### Development Commands

```bash
# Development
npm run dev          # Start app development server
npm run dev:lib      # Watch mode for library development

# Building
npm run build        # Build both library and app
npm run build:lib    # Build library only
npm run build:app    # Build app only

# Testing & Linting
npm test             # Run unit tests
npm run lint         # Check for linting errors

# E2E Tests (Selenium)
cd e2e-tests
./run-tests.sh       # Run end-to-end tests (requires Docker & Python)

# Publishing
npm run publish:lib  # Publish library to npm
```

## How to Use

### Creating Diagrams

1. **Add Items**:
   - Press the "+" button on the top right menu, the library of components will appear on the left
   - Drag and drop components from the library onto the canvas
   - Or right-click on the grid and select "Add node"

2. **Connect Items**: 
   - Select the Connector tool (press 'C' or click connector icon)
   - **Click mode** (default): Click first node, then click second node
   - **Drag mode** (optional): Click and drag from first to second node
   - Switch modes in Settings → Connectors tab

3. **Save Your Work**:
   - **Quick Save** - Saves to browser session
   - **Export** - Download as JSON file
   - **Import** - Load from JSON file

### Storage Options

- **Session Storage**: Temporary saves cleared when browser closes
- **Export/Import**: Permanent storage as JSON files
- **Auto-Save**: Automatically saves changes every 5 seconds to session

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Documentation

- [FOSSFLOW_ENCYCLOPEDIA.md](FOSSFLOW_ENCYCLOPEDIA.md) - Comprehensive guide to the codebase
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contributing guidelines

## License

MIT

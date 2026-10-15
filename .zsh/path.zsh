# PATH configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/Library/TeX/texbin"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# PKG_CONFIG_PATH
export PKG_CONFIG_PATH="$(brew --prefix graphviz)/lib/pkgconfig"
export PKG_CONFIG_PATH="$(brew --prefix zlib)/lib/pkgconfig"

# Docker/Podman
export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

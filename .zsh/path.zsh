# PATH configuration
# Homebrew prefix differs by CPU (/opt/homebrew on Apple Silicon, /usr/local on Intel)
if command -v brew >/dev/null; then
  : "${HOMEBREW_PREFIX:=$(brew --prefix)}"
  export PATH="$HOMEBREW_PREFIX/opt/sqlite/bin:$PATH"
  # PKG_CONFIG_PATH (colon-joined; each assignment used to overwrite the previous one)
  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/graphviz/lib/pkgconfig:$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/Library/TeX/texbin"

# Docker/Podman (only if a podman machine exists)
if command -v podman >/dev/null; then
  _podman_sock="$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)"
  [ -n "$_podman_sock" ] && export DOCKER_HOST="unix://$_podman_sock"
  unset _podman_sock
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Environment variables
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export CPPFLAGS="-I$(brew --prefix zlib)/include"
export HOMEBREW_AUTO_UPDATE_SECS=604800
export HOMEBREW_NO_ASK=1
export LDFLAGS="-L$(brew --prefix zlib)/lib"

# SDK of OpenAI to MLX (commented - enable when needed)
# export OPENAI_API_BASE="http://127.0.0.1:8080/v1"
# export OPENAI_BASE_URL="http://127.0.0.1:8080/v1"
# export OPENAI_API_KEY="local-mlx"
# export OPENAI_MODEL="mlx-community/Phi-4-mini-instruct-4bit"

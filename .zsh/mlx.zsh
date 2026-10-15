# MLX-related functions for local LLM serving

function mlx-on-demand() {
  local MODEL="${1:-$OPENAI_MODEL}"
  local PORT="${2:-8080}"
  local TOKENS="${3:-4096}"

  echo "🚀 Iniciando MLX Server con $MODEL en puerto $PORT..."
  echo "   Presiona Ctrl+C para detener y liberar RAM."

  mlx_lm.server \
    --model "$MODEL" \
    --port "$PORT" \
    --max-tokens "$TOKENS" \
    --prompt-concurrency 1 \
    --decode-concurrency 1 \
    --prompt-cache-bytes 3GB \
    --log-level WARNING
}

# graphify-mlx init .           # runs graphify extract + cluster-only
# graphify-mlx update .         # runs graphify update --force
# graphify-mlx extract . 8080 4096 4096 1

function graphify-mlx() {
  local CMD="${1:-extract}"
  local TARGET="${2:-.}"
  local MODEL="${OPENAI_MODEL:-$(detect_mlx_model)}"
  local PORT="${3:-8080}"
  local TOKENS="${4:-4096}"
  local TOKEN_BUDGET="${5:-4096}"
  local CONCURRENCY="${6:-1}"

  if [[ "$CMD" != "init" && "$CMD" != "extract" && "$CMD" != "update" ]]; then
    echo "Usage: graphify-mlx {init|extract|update} [target=.] [port=8080] [max-tokens=4096] [token-budget=4096] [max-concurrency=1]"
    return 1
  fi

  if [[ "$CMD" == "update" ]]; then
    graphify update "$TARGET" --force
    return $?
  fi

  # Start MLX server for extract/init
  echo "Starting MLX server: $MODEL on port $PORT"
  mlx_lm.server \
    --model "$MODEL" \
    --port "$PORT" \
    --max-tokens "$TOKENS" \
    --prompt-concurrency 1 \
    --decode-concurrency 1 \
    --prompt-cache-bytes 3GB \
    --log-level WARNING \
    &
  local MLX_PID=$!

  # Cleanup on Ctrl+C / termination
  trap 'kill $MLX_PID 2>/dev/null; wait $MLX_PID 2>/dev/null; trap - INT TERM; return 130' INT TERM

  # Wait for the HTTP server to be listening
  echo "Waiting for MLX server on port $PORT..."
  local ready=0
  for i in {1..60}; do
    if curl -s -o /dev/null "http://127.0.0.1:$PORT/v1/models"; then
      ready=1
      echo "MLX server ready."
      break
    fi
    sleep 1
  done

  if [[ $ready -eq 0 ]]; then
    echo "MLX server failed to start within 60s."
    kill $MLX_PID 2>/dev/null
    wait $MLX_PID 2>/dev/null
    trap - INT TERM
    return 1
  fi

  graphify extract "$TARGET" \
    --backend openai \
    --model "$MODEL" \
    --token-budget "$TOKEN_BUDGET" \
    --max-concurrency "$CONCURRENCY" \
    --api-timeout 1200

  local exit_status=$?

  if [[ "$CMD" == "init" && "$exit_status" -eq 0 ]]; then
    echo "Clustering and generating report + graph.html..."
    GRAPHIFY_API_TIMEOUT=1200 graphify cluster-only "$TARGET" \
      --backend openai \
      --model "$MODEL" \
      --max-concurrency "$CONCURRENCY" \
      --batch-size 20
    exit_status=$?
  fi

  # Stop the server and free RAM
  kill $MLX_PID 2>/dev/null
  wait $MLX_PID 2>/dev/null
  trap - INT TERM

  return $exit_status
}

# Detect appropriate MLX model based on architecture
function detect_mlx_model() {
  local arch=$(uname -m)
  if [[ "$arch" == "arm64" ]]; then
    echo "mlx-community/Llama-3.2-3B-Instruct-4bit"
  elif [[ "$arch" == "x86_64" ]]; then
    echo "mlx-community/Llama-3.2-3B-Instruct-4bit"
  else
    echo "mlx-community/Phi-4-mini-instruct-4bit"
  fi
}

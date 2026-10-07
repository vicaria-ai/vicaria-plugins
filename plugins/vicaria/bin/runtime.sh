# POSIX runtime setup helpers, sourced by vc-capture and its detached installer.
# Completed wheel environments are not reinstalled. An interrupted install is never resumed in
# place: its children may still be writing, so the next attempt gets a new path.

runtime_hash() (
  if command -v sha256sum >/dev/null 2>&1; then
    value=$(sha256sum) || exit 1
  elif command -v shasum >/dev/null 2>&1; then
    value=$(shasum -a 256) || exit 1
  else
    exit 1
  fi
  value=${value%% *}
  case $value in *[!0-9a-f]*|'') exit 1 ;; esac
  [ ${#value} -eq 64 ] || exit 1
  printf '%s\n' "$value"
)

runtime_identity() (
  LC_ALL=C
  export LC_ALL
  records='wheel-set-v1'
  found=''
  for wheel in "$1"/*.whl; do
    [ -f "$wheel" ] && [ ! -L "$wheel" ] || exit 1
    name=${wheel##*/}
    case $name in *[!a-zA-Z0-9._-]*|'') exit 1 ;; esac
    digest=$(runtime_hash < "$wheel") || exit 1
    records="$records
$name $digest"
    found=1
  done
  [ -n "$found" ] || exit 1
  printf '%s\n' "$records" | runtime_hash
)

runtime_python() (
  selected=''; have=''
  [ -f "$1/ready" ] && read -r selected < "$1/ready"
  case $selected in
    *[!a-zA-Z0-9-]*|'') exit 1 ;;
    build-*)
      [ -f "$1/$selected/installed" ] && read -r have < "$1/$selected/installed"
      [ "$have" = "$2" ] && [ -x "$1/$selected/venv/bin/python" ] || exit 1
      printf '%s\n' "$1/$selected/venv/bin/python" ;;
    *) exit 1 ;;
  esac
)

runtime_build() (
  rt=$1; wheels=$2; want=$3; base=$4
  printf '%s\n' "$$" > "$rt/lock/pid" || exit 1
  cleanup() {
    owner=''
    [ -f "$rt/lock/pid" ] && read -r owner < "$rt/lock/pid"
    if [ "$owner" = "$$" ]; then
      rm -f "$rt/lock/pid"
      rmdir "$rt/lock" 2>/dev/null || :
    fi
  }
  trap cleanup EXIT
  trap 'exit 1' HUP INT TERM
  # Check health in this detached process, under the setup lock. A ready marker
  # alone cannot prove that its interpreter or dependencies still work.
  if [ -f "$rt/ready" ]; then
    py=$(runtime_python "$rt" "$want")
    if [ -n "$py" ] && "$py" -I -c 'import smart_gateway.capture.hook; import vicaria_contracts' >/dev/null 2>&1; then
      exit 0
    fi
    mv "$rt/ready" "$rt/ready.broken-$$" || exit 1
  fi
  attempt=$(mktemp -d "$rt/build-XXXXXXXX") || exit 1
  setup() {
    mkdir "$attempt/wheels" || return 1
    # Freeze inputs before invoking an installer; marketplace updates cannot
    # change the wheel bytes underneath this attempt.
    cp "$wheels"/*.whl "$attempt/wheels/" || return 1
    [ "$(runtime_identity "$attempt/wheels")" = "$want" ] || return 1
    mkdir "$attempt/uv" || return 1
    if [ -x "$base/runtime/uv/uv" ]; then
      cp "$base/runtime/uv/uv" "$attempt/uv/uv" || return 1
    else
      command -v curl >/dev/null 2>&1 || return 1
      curl -LsSf https://astral.sh/uv/install.sh -o "$attempt/install-uv.sh" || return 1
      UV_INSTALL_DIR="$attempt/uv" UV_NO_MODIFY_PATH=1 sh "$attempt/install-uv.sh" || return 1
    fi
    "$attempt/uv/uv" python install 3.12 &&
      "$attempt/uv/uv" venv --python 3.12 "$attempt/venv" &&
      "$attempt/uv/uv" pip install --no-deps --python "$attempt/venv/bin/python" "$attempt/wheels"/*.whl &&
      "$attempt/venv/bin/python" -I -c 'import smart_gateway.capture.hook; import vicaria_contracts' >/dev/null
  }
  if setup; then
    rm -rf "$attempt/uv"
    printf '%s\n' "$want" > "$attempt/installed" || exit 1
    printf '%s\n' "${attempt##*/}" > "$attempt/name" || exit 1
    # Atomic, no-overwrite publication. Even if stale-lock recovery launches
    # competing private attempts, only one complete interpreter is selected.
    ln "$attempt/name" "$rt/ready" 2>/dev/null || [ -f "$rt/ready" ] || exit 1
    rm -f "$rt/failed"
    echo ready > "$rt/state"
  else
    # All foreground installer commands have returned. Only this known-failed
    # attempt is safe to remove; traps never remove interrupted/orphaned builds.
    rm -rf "$attempt"
    if [ ! -f "$rt/ready" ]; then
      date -u +%Y-%m-%dT%H:%M:%SZ > "$rt/failed"
      echo failed > "$rt/state"
    fi
    exit 1
  fi
)

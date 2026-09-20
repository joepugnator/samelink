#!/bin/sh
# Fails fast on first failure; uses isolated tmpdir.
set -u

BIN="./samelink"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT INT TERM

pass=0
fail=0

ok() { pass=$((pass+1)); echo "ok: $1"; }
bad() { fail=$((fail+1)); echo "FAIL: $1"; }

# 0. build is up to date
make samelink >/dev/null || { echo "FAIL: build failed"; exit 1; }

# 1. basic create: target exists, readlink matches
echo "hello" > "$TMP/hello.txt"
if "$BIN" "$TMP/hello.txt" "$TMP/link1"; then
  if [ -L "$TMP/link1" ] && [ "$(readlink "$TMP/link1")" = "$TMP/hello.txt" ]; then
    ok "basic create + readlink matches"
  else
    bad "basic create: link missing or readlink mismatch"
  fi
else
  bad "basic create: exit code nonzero"
fi

# 2. dangling target succeeds (symlink does not check target)
if "$BIN" "$TMP/no-such-file" "$TMP/dangling"; then
  if [ -L "$TMP/dangling" ]; then
    ok "dangling target succeeds"
  else
    bad "dangling target: no symlink created"
  fi
else
  bad "dangling target: should succeed but failed"
fi

# 3. existing linkpath fails (EEXIST) without -f
echo "x" > "$TMP/exists"
if "$BIN" "$TMP/hello.txt" "$TMP/exists" 2>/dev/null; then
  bad "existing dest: should fail but succeeded"
else
  ok "existing dest fails without -f"
fi

# 4. missing parent dir fails (ENOENT)
if "$BIN" "$TMP/hello.txt" "$TMP/no-dir/link" 2>/dev/null; then
  bad "missing parent dir: should fail but succeeded"
else
  ok "missing parent dir fails"
fi

# 5. wrong arg count -> exit 2 + usage
if "$BIN" only-one-arg 2>/dev/null; then
  bad "arg count: should fail but succeeded"
else
  if [ "$?" -eq 2 ]; then
    ok "wrong arg count exits 2"
  else
    bad "wrong arg count: expected exit 2"
  fi
fi

echo "---"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]

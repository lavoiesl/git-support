#!/bin/bash

# Script location
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Hooks to be copied
hooks="update post-update"
hooks_dir="$(dirname $DIR)/hooks"

# Configuration
# TODO: get those from arguments
root="$PWD"
project_root="$root/repositories"
env_root="$root/environments"
# The skeleton repository represent the basic structure for a new repo
skeleton="$project_root/skeleton.git"
default_env="dev"
other_envs="stage"
environments="$default_env $other_envs"

# Variables and sanity check
project_name="$1"

if [[ -z "$project_name" ]]; then
  echo "Usage: $0 project-name [default-env] [other-envs]" >&2
  exit 1
fi

shift

if [[ -n "$@" ]]; then
  environments="$@"
  default_env=$1
  shift
  other_envs="$@"
fi

bare_dir="$project_root/$project_name.git"
envs_dir="$env_root/$project_name"

if [[ -d "$bare_dir" ]]; then
  echo "Project $project_name already exists" >&2
  exit 2
fi

# If skeleton exists, clone it
if [[ -d "$skeleton" ]]; then
  git clone --bare "$skeleton" "$bare_dir"
else
  # Else, create a bare repository
  git init --bare "$bare_dir"
fi

# Create root commit and all branches
tmpdir="$(mktemp -d /tmp/create-repo.XXXXXXX)"

git clone "$bare_dir" "$tmpdir"

cd "$tmpdir"

# Change HEAD to $default_env
git symbolic-ref HEAD refs/heads/$default_env
git commit --allow-empty -m 'Initial commit'

for env in $other_envs; do
  git checkout -b $env
done

git push origin $environments

cd "$bare_dir"
GIT_DIR="$bare_dir" git symbolic-ref HEAD refs/heads/$default_env

rm -Rf $tmpdir

# Checkout environments

for env in $environments; do
  env_dir="$envs_dir/$env"
  GIT_DIR="$bare_dir" git config branch.$env.update-dir "$env_dir"
  git clone "$bare_dir" -b $env "$env_dir"
done

# Add hooks
for hook in $hooks; do
  ln -sv "$hooks_dir/$hook" "$bare_dir/hooks/"
done

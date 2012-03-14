#!/bin/bahsh

# Script location
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Hooks to be copied
hooks="update post-update"

# Configuration
root="$PWD"
project_root="$root/repositories"
env_root="$root/environments"
default_env="dev"
other_envs="stage"
environments="$default_env $other_envs"

# Variables and sanity check
project_name="$1"

if [[ -z "$project_name" ]]; then
  echo "Usage: $0 <project-name>" >&2
  exit 1
fi

bare_dir="$project_root/$project_name.git"
envs_dir="$env_root/$project_name"

if [[ -d "$bare_dir" ]]; then
  echo "Project $project_name already exists" >&2
  exit 2
fi

# Create bare repository
git init --bare "$bare_dir"

# Create root commit and all branches
tmpdir="$(mktemp -d -t create-repo)"

git clone "$bare_dir" "$tmpdir"

cd "$tmpdir"

git checkout -b $default_env
git commit --allow-empty -m 'Initial commit'

for env in $other_envs; do
  git checkout -b $env
done

git push origin $environments

cd "$bare_dir"

# Change HEAD to $default_env
git symbolic-ref HEAD refs/heads/$default_env

rm -Rf $tmpdir

# Checkout environments

for env in $environments; do
  env_dir="$envs_dir/$env"
  GIT_DIR="$bare_dir" git config branch.$env.update-dir "$env_dir"
  git clone "$bare_dir" -b $env "$env_dir"
done

# Add hooks
for hook in $hooks; do
  cp -v "$DIR/$hook" "$bare_dir/hooks/"
done

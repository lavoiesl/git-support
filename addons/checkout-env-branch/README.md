# Checkout an environment for matching branch

The purpose of this hook is when you have different versions of the repository checked out at several places and you want to update them, tracking a branch.

## Example
If you develop a website that has an environment **dev** and **stage**, your tree could look like this:

 * /mnt/repositories/**mywebsite**.git
 * /mnt/environments/**mywebsite**/**dev**
 * /mnt/environments/**mywebsite**/**stage**

## Configuration
For all the branches that are managed by this hook, a configuration should exists so that branch.**$branch**.update-dir points to a valid git repository

## Pushing
When a push is made to the bare repository, two hooks are fired

### update hook
The update hook is fired before the update is made and it checks if it’s a commit on a branch.

If branch.**$branch**.update-dir exists, this repository is checked if it has local modifications.

If it has modifications, an automatic commit is made and the update is cancelled.

### post-update hook
The update hook is fired after the update was succesful.

If branch.**$branch**.update-dir exists, this repository does a git pull -Xtheirs.

## Creation script

A script is included that creates repos and environments for these hooks

It also adds the hooks and optionally clones from a skeleton, check it out
# Merge 
Hooks called by 'git-merge'

## post-merge

### Invocation
 * Runs after a git-merge or a git-pull.
 * Not executed if the merge failed due to conflicts.
 * Exit status has no impact.

### Parameters
 1. A status flag specifying whether or not the merge being done was a squash merge.

### Typical usages
See contrib/hooks/setgitperms.perl

 * Can be used in conjunction with a corresponding pre-commit hook to save and restore any form of metadata associated with the working tree
   * Permissions/ownership
   * ACLS

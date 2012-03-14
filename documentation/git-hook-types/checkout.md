# Checkout
Hooks called by 'git-checkout'

## post-checkout

### Invocation
 * Runs after having updated the worktree.
 * Exit status has no impact.

### Parameters
 1. Ref of the previous HEAD
 2. Ref of the new HEAD (which may or may not have changed)
 3. A flag indicating whether the checkout was a branch checkout
   * Changing branches, flag=1
   * File checkout, retrieving a file from the index, flag=0

### Typical usages
 * Perform repository validity checks
 * Auto-display differences from the previous HEAD if different
 * Set working dir metadata properties

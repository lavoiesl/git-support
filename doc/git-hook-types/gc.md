# Garbage collector

## pre-auto-gc

This hook is invoked by 'git-gc --auto'. 

### Invocation
 * Runs just before running the garbage collector.
 * Exiting with non-zero status aborts the 'git-gc --auto'.

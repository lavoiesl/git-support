# Apply patch
Hooks invoked by git-am script

## applypatch-msg

Invoked before the patch is applied.
Same purpose as commit-msg hook.

### Invocation
 * Runs before the patch is applied.
 * Exiting with non-zero aborts the patch and no change is made.

### Parameters

 1. The file that holds the proposed commit log message

### Typical usages
 * Normalize the commit message.
 * Refuse the commit after inspecting the message file
 * Run the commit-msg hook, if the latter is enabled.


## pre-applypatch

### Invocation
 * Runs after the patch is applied, but before a commit is made.
 * Exiting with non-zero aborts the commit, leaving the patch applied.

### Typical usages
 * Inspect the current working tree and refuse to make a commit if it does not pass certain test. 
 * Run the pre-commit hook, if the latter is enabled.

## post-applypatch

### Invocation
 * Runs after the patch is applied and a commit is made.
 * Exit status has no impact.

### Typical usages
 * Notifications
 * Run the post-commit hook, if the latter is enabled.

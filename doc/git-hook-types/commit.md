

# Commit 
Hooks invoked by git-commit script

All the 'git-commit' hooks are invoked with the environment variable GIT_EDITOR=: if the command will not bring up an editor to modify the commit message.

## pre-commit

### Invocation
Can be bypassed with --no-verify option. 
Runs before obtaining the proposed commit log message and making a commit. 
Exiting with non-zero status aborts the commit and no change is made.

### Typical usages
 * Catch introduction of lines with trailing whitespaces and aborts the commit when such a line is found.

## prepare-commit-msg

### Invocation
Not suppressed by the --no-verify option.
Runs after obtaining the default log message, but before the editor is started.
Exiting with non-zero status aborts the commit and no change is made.

### Parameters
One to three parameters.

 1. Name of the file of the commit log message
 2. Source of the commit message, and can be
   * message (if a -m or -F option was given)
   * template (if a -t option was given or the configuration option commit.template is set)
   * merge (if the commit is a merge or a .git/MERGE_MSG file exists)
   * squash (if a .git/SQUASH_MSG file exists)
   * commit
 3. commit SHA1 (if a -c, -C or --amend option was given).

### Typical usages
 * Edit the message file in place. 
 * Should not be used as replacement for pre-commit hook.
 * Comment out the Conflicts: part of a merge’s commit message.

## commit-msg

### Invocation
Can be bypassed with --no-verify option. 
Exiting with non-zero status aborts the commit and no change is made.

### Parameters
One to three parameters.

 1. Name of the file of the commit log message

### Typical usages
 * Normalize the commit message.
 * Refuse the commit after inspecting the commit message.
 * Detect duplicate "Signed-off-by" lines, and abort the commit if one is found.

## post-commit

### Invocation
Runs after a commit is made.
Exit status has no impact.

#### Typical usages
 * Notifications

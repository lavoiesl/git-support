# Git hook documentation
Simplified version of [http://book.git-scm.com/5\_git\_hooks.html](http://book.git-scm.com/5_git_hooks.html)

    // TODO: simplification

## Apply patch
Hooks invoked by git-am script

### applypatch-msg

Invoked before the patch is applied.
Same purpose as commit-msg hook.

#### Invocation
Runs before the patch is applied.
Exiting with non-zero aborts the patch and no change is made.

#### Parameters

 1. The file that holds the proposed commit log message

#### Typical usages
 * Normalize the commit message.
 * Refuse the commit after inspecting the message file
 * Run the commit-msg hook, if the latter is enabled.


### pre-applypatch

#### Invocation
Runs after the patch is applied, but before a commit is made.
Exiting with non-zero aborts the commit, leaving the patch applied.

#### Typical usages
 * Inspect the current working tree and refuse to make a commit if it does not pass certain test. 
 * Run the pre-commit hook, if the latter is enabled.

### post-applypatch

#### Invocation
Runs after the patch is applied and a commit is made.
Exit status has no impact.

#### Typical usages
 * Notifications
 * Run the post-commit hook, if the latter is enabled.

## Commit 
Hooks invoked by git-commit script

All the 'git-commit' hooks are invoked with the environment variable GIT_EDITOR=: if the command will not bring up an editor to modify the commit message.

### pre-commit

#### Invocation
Can be bypassed with --no-verify option. 
Runs before obtaining the proposed commit log message and making a commit. 
Exiting with non-zero status aborts the commit and no change is made.

#### Typical usages
 * Catch introduction of lines with trailing whitespaces and aborts the commit when such a line is found.

### prepare-commit-msg

#### Invocation
Not suppressed by the --no-verify option.
Runs after obtaining the default log message, but before the editor is started.
Exiting with non-zero status aborts the commit and no change is made.

#### Parameters
One to three parameters.

 1. Name of the file of the commit log message
 2. Source of the commit message, and can be
   * message (if a -m or -F option was given)
   * template (if a -t option was given or the configuration option commit.template is set)
   * merge (if the commit is a merge or a .git/MERGE_MSG file exists)
   * squash (if a .git/SQUASH_MSG file exists)
   * commit
 3. commit SHA1 (if a -c, -C or --amend option was given).

#### Typical usages
 * Edit the message file in place. 
 * Should not be used as replacement for pre-commit hook.
 * Comment out the Conflicts: part of a merge’s commit message.

### commit-msg

#### Invocation
Can be bypassed with --no-verify option. 
Exiting with non-zero status aborts the commit and no change is made.

#### Parameters
One to three parameters.

 1. Name of the file of the commit log message

#### Typical usages
 * Normalize the commit message.
 * Refuse the commit after inspecting the commit message.
 * Detect duplicate "Signed-off-by" lines, and abort the commit if one is found.

### post-commit

#### Invocation
Runs after a commit is made.
Exit status has no impact.

#### Typical usages
 * Notifications

## Rebase 
Hooks called by 'git-rebase'

### pre-rebase

#### Invocation
Runs before the rebase starts
Exiting with non-zero status aborts the rebase and no change is made.


## Checkout 
Hooks called by 'git-checkout'

### post-checkout

#### Invocation
Runs after having updated the worktree.
Exit status has no impact.

#### Parameters
 1. Ref of the previous HEAD
 2. Ref of the new HEAD (which may or may not have changed)
 3. A flag indicating whether the checkout was a branch checkout
   * Changing branches, flag=1 
   * File checkout, retrieving a file from the index, flag=0

#### Typical usages
 * Perform repository validity checks
 * Auto-display differences from the previous HEAD if different
 * Set working dir metadata properties

## Merge 
Hooks called by 'git-merge'

### post-merge

#### Invocation
Runs after a git-merge or a git-pull.
Not executed if the merge failed due to conflicts.
Exit status has no impact.

#### Parameters
 1. A status flag specifying whether or not the merge being done was a squash merge.

#### Typical usages
See contrib/hooks/setgitperms.perl

 * Can be used in conjunction with a corresponding pre-commit hook to save and restore any form of metadata associated with the working tree
   * Permissions/ownership
   * ACLS

## Receive
Hooks called by 'git-receive-pack' on the remote repository, which happens when a 'git-push' is done on a local repository.

### pre-receive

#### Invocation
Runs just before starting to update refs on the remote repository
Exiting with non-zero status aborts the update and no change is made.

This hook executes once for the receive operation. It takes no arguments, but for each ref to be updated it receives on standard input a line of the format:

SP SP LF

where <old-value> is the old object name stored in the ref, <new-value> is the new object name to be stored in the ref and <ref-name> is the full name of the ref. When creating a new ref, <old-value> is 40 0.

If the hook exits with non-zero status, none of the refs will be updated. If the hook exits with zero, updating of individual refs can still be prevented by the <<update,'update'>> hook.

Both standard output and standard error output are forwarded to 'git-send-pack' on the other end, so you can simply echo messages for the user.

## update

This hook is invoked by 'git-receive-pack' on the remote repository, which happens when a 'git-push' is done on a local repository. Just before updating the ref on the remote repository, the update hook is invoked. Its exit status determines the success or failure of the ref update.

The hook executes once for each ref to be updated, and takes three parameters:

the name of the ref being updated,
the old object name stored in the ref,
and the new objectname to be stored in the ref.
A zero exit from the update hook allows the ref to be updated. Exiting with a non-zero status prevents 'git-receive-pack' from updating that ref.

This hook can be used to prevent 'forced' update on certain refs by making sure that the object name is a commit object that is a descendant of the commit object named by the old object name. That is, to enforce a "fast forward only" policy.

It could also be used to log the old..new status. However, it does not know the entire set of branches, so it would end up firing one e-mail per ref when used naively, though. The <<post-receive,'post-receive'>> hook is more suited to that.

Another use suggested on the mailing list is to use this hook to implement access control which is finer grained than the one based on filesystem group.

Both standard output and standard error output are forwarded to 'git-send-pack' on the other end, so you can simply echo messages for the user.

The default 'update' hook, when enabled--and with hooks.allowunannotated config option turned on--prevents unannotated tags to be pushed.

## post-receive

This hook is invoked by 'git-receive-pack' on the remote repository, which happens when a 'git-push' is done on a local repository. It executes on the remote repository once after all the refs have been updated.

This hook executes once for the receive operation. It takes no arguments, but gets the same information as the <<pre-receive,'pre-receive'>> hook does on its standard input.

This hook does not affect the outcome of 'git-receive-pack', as it is called after the real work is done.

This supersedes the <<post-update,'post-update'>> hook in that it gets both old and new values of all the refs in addition to their names.

Both standard output and standard error output are forwarded to 'git-send-pack' on the other end, so you can simply echo messages for the user.

The default 'post-receive' hook is empty, but there is a sample script post-receive-email provided in the contrib/hooks directory in git distribution, which implements sending commit emails.

## post-update

This hook is invoked by 'git-receive-pack' on the remote repository, which happens when a 'git-push' is done on a local repository. It executes on the remote repository once after all the refs have been updated.

It takes a variable number of parameters, each of which is the name of ref that was actually updated.

This hook is meant primarily for notification, and cannot affect the outcome of 'git-receive-pack'.

The 'post-update' hook can tell what are the heads that were pushed, but it does not know what their original and updated values are, so it is a poor place to do log old..new. The <<post-receive,'post-receive'>> hook does get both original and updated values of the refs. You might consider it instead if you need them.

When enabled, the default 'post-update' hook runs 'git-update-server-info' to keep the information used by dumb transports (e.g., HTTP) up-to-date. If you are publishing a git repository that is accessible via HTTP, you should probably enable this hook.

Both standard output and standard error output are forwarded to 'git-send-pack' on the other end, so you can simply echo messages for the user.

## pre-auto-gc

This hook is invoked by 'git-gc --auto'. It takes no parameter, and exiting with non-zero status from this script causes the 'git-gc --auto' to abort.




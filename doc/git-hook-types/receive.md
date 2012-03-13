# Receive
Hooks called by 'git-receive-pack' on the remote repository, which happens when a 'git-push' is done on a local repository.

## pre-receive

### Invocation
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
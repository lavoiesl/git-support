# Receive
Hooks called by 'git-receive-pack' on the remote repository, which happens when a 'git-push' is done on a local repository.

Both standard output and standard error output are forwarded to 'git-send-pack' on the other end, so you can simply echo messages for the user.

## pre-receive

### Invocation
 * Runs just before starting to update refs on the remote repository
 * Exiting with non-zero status aborts the update and no change is made.
 * This hook executes once for the receive operation, independently of the number of refs.
 * Exiting with non-zero status aborts the receive and no change is made.
 * Updating of individual refs can still be prevented by the update hook.

### Parameters
It takes no arguments, but for each ref to be updated it receives on standard input a line of the format:

 1. The old object name stored in the ref
 2. The new object name to be stored in the ref
 3. The full name of the ref. 

When creating a new ref, the first parameter is 40 0.

## update

### Invocation
 * Runs just before updating the ref on the remote repository, after the pre-receive hook.
 * Exiting with non-zero status aborts the update and no change is made for this ref.

### Parameters
The hook executes once for each ref to be updated, and takes three parameters:

 1. The name of the ref being updated.
 2. The old object name stored in the ref.
 3. The new objectname to be stored in the ref.

### Typical usages
 * Can be used to prevent 'forced' update on certain refs by making sure that the object name is a commit object that is a descendant of the commit object named by the old object name. That is, to enforce a "fast forward only" policy.
 * Log the old..new status. However, it does not know the entire set of branches, so it would end up firing one e-mail per ref when used naively, though. The post-receive hook could be more suited for that.
 * Implement access control which is finer grained than the one based on filesystem group.
 * Prevent unannotated tags to be pushed.

## post-receive

### Invocation
 * Executes on the remote repository once after all the refs have been updated.
 * Exit status has no impact.

### Parameters
It takes no arguments, but receives the same input as the pre-receive hook.

### Typical usages
 * Send commit emails.
 * Update meta data for repositories
 * Run git-update-server-info to keep the information used by dumb transports (e.g., HTTP) up-to-date. Example: GitWeb

## post-update

### Invocation
 * Executes on the remote repository once after all the refs have been updated.
 * Exit status has no impact.

### Parameters 
Takes a variable number of parameters, each of which is the name of ref that was actually updated.

### Typical usages
 * Send commit emails.

The 'post-update' hook can tell what are the heads that were pushed, but it does not know what their original and updated values are, so it is a poor place to do log old..new. 
The post-receive hook does get both original and updated values of the refs. 
You might consider it instead if you need them.


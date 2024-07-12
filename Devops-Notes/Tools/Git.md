#### What is git and what are the most useful commands ?
- Git is a distributed version control system
#### GIT COMMANDS
- `git init`: Initializes a new Git repository in the current directory.
- `git clone `: Creates a copy of a remote repository on your local machine.
- `git add `: Adds a file to the staging area, preparing it for a commit.
- `git commit -m “”`: Records changes to the repository, creating a new commit with a descriptive message.
- `git status`: Displays the current state of the repository, including modified, staged, and untracked files.
- `git pull`: Fetches and merges changes from a remote repository into the current branch.
- `git push`: Pushes commits from a local branch to a remote repository.
- `git branch`: Lists existing branches in the repository.
- `git checkout `: Switches to a different branch.
- `git merge `: Merges changes from one branch into the current branch.
- `git log`: Shows a history of commits, including commit messages and other details.
- `git diff`: Displays the differences between the current state and the last commit.

### Why git is most popular ?

- Distributed architecture
- Speed and efficiency
- Branching and merging
- Collaboration and teamwork
- Stability and maturity
- Security

### Explain the difference between ‘git pull’ and ‘git fetch’ ?

- The `git pull` command combines two operations into one: fetching the latest changes from the remote repository and merging them into the current branch.

`git fetch`:

- The `git fetch` command retrieves the latest commits and updates the remote-tracking branches in your local repository. It doesn’t modify your current branch or merge the changes automatically.

— `git pull` combines the `git fetch` and `git merge` commands into one convenient operation, updating your current branch automatically.

— `git fetch` only retrieves the latest commits and updates the remote-tracking branches

### What command is used in git to change your working branch ?

git checkout "other-branch"
### What is the difference between git and GitHub ?

`Git`:

- Git is a distributed version control system (VCS)

`GitHub`:
 - GitHub is a web-based hosting service that provides a centralized platform for Git repositories.

- It adds additional features on top of Git, such as a web interface, collaboration tools, issue tracking, pull requests, and code reviews.`


### How do you rename a branch in Git ?
- Check the current branch: Before renaming the branch, ensure that you are not currently on the branch you want to rename. If you are on the branch, you can switch to a different branch using the `git checkout` command.
- Rename the branch: To rename a branch, you can use the `git branch` command with the `-m` option followed by the current branch name and the new desired name.
```bash
   ➜  Tools git:(master) git branch
➜  Tools git:(master) ✗ 
➜  Tools git:(master) ✗ git checkout india
error: pathspec 'india' did not match any file(s) known to git
➜  Tools git:(master) ✗ git checkout -b india
Switched to a new branch 'india'
➜  Tools git:(india) ✗ git checkout -b nepal
Switched to a new branch 'nepal'
➜  Tools git:(nepal) ✗ git checkout india
M       Devops-Notes/Tools/Git.md
Switched to branch 'india'
➜  Tools git:(india) ✗ git branch -m nepal Australia
➜  Tools git:(india) ✗ git branch
```


   git push -u origin <new-branch-name>
Replace `<new-branch-name>` with the new name of the branch you just renamed.

This command sets the upstream branch and pushes the changes to the remote repository. Subsequent pushes or pulls can be done using the new branch name.

### What things to be considered while reviewing a pull request ?

- Look into all individual commits
- Look first into the files which have relevant changes.
- We need to make sure that the PR’s code should be working properly as per the new feature for which the PR is raised.
- Functions should not be too long.
- There should not be redundant code.
- Variables and function names should be meaningful .
- If the application contains unit tests than the test coverage criteria should be met.

### What is the purpose of the ‘git stash’ command ?

 - The purpose of the `git stash` command is to provide a way to save your work without committing it, so you can switch to a different branch, pull changes from a remote repository, or perform other operations that require a clean working directory.

    — `git stash save`: Creates a new stash with the changes in your working directory.
    — `git stash list`: Lists all the stashes you have created.
    — `git stash apply`: Applies the most recent stash to your working directory.
    — `git stash pop`: Applies the most recent stash and removes it from the stash list.
    — `git stash drop`: Removes a specific stash from the stash list.
    — `git stash branch`: Creates a new branch and applies a stash to that branch.
Here are some advanced Git interview questions that can help you demonstrate your deep understanding of Git and its functionalities:

## **Advanced Git Interview Questions**

### How do you revert a commit that has already been pushed and made public?
- Use `git revert <commit-hash>` to create a new commit that undoes the changes introduced by the specified commit. This is a safe way to undo changes without rewriting history.

### **3. How do you squash the last N commits into a single commit?**
- Use `git rebase -i HEAD~N`. This command opens an interactive rebase session where you can mark commits to be squashed. Replace "pick" with "squash" (or "s") for the commits you want to combine.

### **4. Explain the Gitflow workflow and its components.**
- **Gitflow** is a branching model that uses two main branches: `master` and `develop`. The `master` branch is always production-ready, while `develop` is used for integrating features.
  - **Feature branches**: Created from `develop` for new features.
  - **Release branches**: Created from `develop` when preparing for a new production release.
  - **Hotfix branches**: Created from `master` to quickly fix production issues and merged back into both `master` and `develop`.

### **5. What is the purpose of `git stash` and how do you use it?**
- **`git stash`**: Temporarily saves your uncommitted changes and reverts your working directory to the last committed state. This is useful when you need to switch branches or pull updates without committing incomplete work.
  - **Usage**: `git stash`, `git stash pop` to apply the stash, and `git stash list`.

### **6. How do you handle merge conflicts in Git?**
  - **Steps to resolve**:
    1. Open the conflicted files and manually resolve the conflicts.
    2. Use `git add <file>` to mark the conflicts as resolved.
    3. Commit the changes using `git commit`.

### **7. What is `git cherry-pick` and when would you use it?**
- **`git cherry-pick`**: Applies the changes introduced by an existing commit to another branch. This is useful when you want to apply specific changes from one branch to another without merging the entire branch.
  - **Usage**: `git cherry-pick <commit-hash>`[7].

### **8. How do you set up a Git hook and what are some common use cases?**
- **Git hooks**: Scripts that Git executes before or after certain events, such as commits or merges.
  - **Setup**: Place executable scripts in the `.git/hooks` directory of your repository.
  - **Common use cases**: Enforcing commit message formats (`commit-msg` hook), running tests before pushing (`pre-push` hook), or checking code style (`pre-commit` hook)[6].

### **9. Explain the difference between `git rebase` and `git merge`.**
- **`git merge`**: Combines the changes from one branch into another, creating a new commit that represents the merge.
- **`git rebase`**: Reapplies commits from one branch onto another, creating a linear history. 
- It can make the commit history cleaner but can be dangerous if used on shared branches due to rewriting history.

### **10. How do you use `git bisect` to find a bug?**
- **`git bisect`**: A binary search tool to find the commit that introduced a bug.
  - **Steps**:
    1. Start bisecting: `git bisect start`.
    2. Mark the current commit as bad: `git bisect bad`.
    3. Mark a known good commit: `git bisect good <commit>`.
    4. Git will check out a commit halfway between the good and bad commits. 
        - Test this commit and mark it as good or bad.
    5. Repeat until Git identifies the first bad commit.
  - **End bisecting**: `git bisect reset`.


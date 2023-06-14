## SWPP, Assignment 1: Rebasing & Merging Branches

What you should do is to:

0. Clone this repo into your computer

1. Make a new commit on the `main` branch that replaces `SWPP` from `hello.cpp`
with your github username, so it prints:

```
make
./hello
Hello, my name is <your Github username>
```

The commit message should be "Update hello.cpp".

2. This repo has three branches: `main`, `bugfix`, `usemap`.
Checkout the existing `bugfix` branch using `git checkout` command.
Then, **rebase** it onto `main` using `git rebase` command.
See following diagram.

```
*----------* main
 \
  \
   --------* bugfix

==> (after rebase)

*----------* main
            \
             \
              --------* bugfix
```

3. Checkout `main` and merge `bugfix` into `main` using `git merge` command.
Thanks to the rebase done before, there will be no merge commit created.

4. On top of that, **merge** the existing `usemap` branch again. This causes a merge conflict;
please fix it carefully.
(When you commit the fix, please do not edit the commit message which will be e.g., `Merge branch 'usemap'`.)

NOTE: You should carefully see why it causes merge conflict. To do this, you
need to understand what `usemap` branch did.

5. Check that `make; ./check.sh` works successfully. :)

After this, `git log --oneline` at `main` branch should show the commits
including bugfix/usemap commits, "Update hello.cpp" commit,
and a merge commit.

`git log --oneline --no-merges` should hide the merge commits.

6. `./package.sh` will create an archive `submit.tar.gz`. Submit this archive to eTL.

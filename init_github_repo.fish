#!/usr/bin/env fish

function init_github_repo
    set -l repo_name (basename (pwd))

    # 1. Make sure gh is installed
    if not command -q gh
        echo "<!> GitHub CLI ('gh') is not installed."
        echo "<i> Install it first: https://cli.github.com"
        return 1
    end

    # 2. Check auth status; prompt to log in if not authenticated
    if not gh auth status >/dev/null 2>&1
        echo "<x> Not authenticated with GitHub CLI yet."
        echo "<i> Launching 'gh auth login' (choose SSH when prompted for protocol)..."
        gh auth login
        if test $status -ne 0
            echo "<x> Authentication failed. Aborting..."
            return 1
        end
    else
        echo "<+> Already authenticated with GitHub CLI."
    end

    # 3. Make sure gh uses SSH for git operations.
    set -l protocol (gh config get git_protocol 2>/dev/null)
    if test "$protocol" != "ssh"
        echo "<o> Setting gh's git protocol to ssh..."
        gh config set git_protocol ssh
    end

    # 4. Init git repo if this isn't one already
    if not test -d .git
        echo "<o> Initializing git repository..."
        git init
    else
        echo "<+> Git repo already initialized."
    end

    # 5. Create a .gitignore if one doesn't exist yet
    if not test -e .gitignore
        echo "<i> No .gitignore found — creating an empty one..."
        touch .gitignore
    end

    # 6. Stage and commit anything pending
    git add -A
    if git diff --cached --quiet
        echo "<=>  Nothing new to commit."
    else
        git commit -m "Initial commit"
    end

    # 7. Ask for visibility
    echo ""
    echo "Repo visibility:"
    echo "  1) private (default)"
    echo "  2) public"
    read -P "Choice [1/2]: " vis_choice
    set -l visibility "--private"
    if test "$vis_choice" = "2"
        set visibility "--public"
    end

    # 8. Create the GitHub repo from the local one and push it
    echo ""
    echo "<i> Creating GitHub repo '$repo_name' and pushing..."
    if gh repo create $repo_name $visibility --source=. --remote=origin --push
        set -l repo_url (gh repo view --json url -q .url)
        echo "<i> Done! Repo available at: $repo_url"
    else
        echo "<!> Something went wrong creating/pushing the repo."
        return 1
    end
end

init_github_repo

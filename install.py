#!/usr/bin/env python3
# pylint: disable=bare-except
# ruff: noqa: E722

"""
Install dotfiles.
"""

import os
import shutil
from datetime import datetime
from subprocess import call as subprocess_call, check_output

ROOT_PATH = os.path.dirname(os.path.abspath(__file__))
HOME_DIR=os.environ.get("HOME")

os.chdir(ROOT_PATH)

def get_git_config(field):
    """Gets the current Git user."""
    command = ["git", "config", field]
    try:
        output = check_output(command)
        output = output.decode("utf-8").strip()
    except:
        return ""
    return output

def copy(src, dest):
    """
    Copy a file or directory to a new location.
    """
    if os.path.isfile(src):
        if os.path.exists(dest):
            os.remove(dest)
        shutil.copy(src, dest)
    elif os.path.isdir(src):
        shutil.rmtree(dest, ignore_errors=True)
        shutil.copytree(src, dest, dirs_exist_ok=True)

def setup_dotfiles():
    """
    Copy dotfiles, modules, and configs to the home directory.
    Backs up existing files into a timestamped history directory first.
    """
    timestamp = datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
    history_dir = os.path.join("history", timestamp)
    os.makedirs(history_dir, exist_ok=True)

    for path in os.listdir("dotfiles"):
        file_path = os.path.join("dotfiles", path)
        home_path = os.path.join(HOME_DIR, path)
        history_path = os.path.join(history_dir, path)
        copy(home_path, history_path)
        copy(file_path, home_path)

    for module in os.listdir("modules"):
        module = os.path.join("modules", module)
        if os.path.isdir(module):
            for path in os.listdir(module):
                file_path = os.path.join(module, path)
                home_path = os.path.join(HOME_DIR, path)
                history_path = os.path.join(history_dir, path)
                copy(home_path, history_path)
                copy(file_path, home_path)

    for config in os.listdir("configs"):
        file_path = os.path.join("configs", config)
        home_path = os.path.join(HOME_DIR, ".config", config)
        history_path = os.path.join(history_dir, ".config", config)
        copy(home_path, history_path)
        copy(file_path, home_path)

def setup_gitconfig(user_name=None, user_email=None, signing_key=None):
    """
    Set up Git user configuration.
    """
    # User identity — prompt if missing, always write (dotfiles copy blanks the template)
    if not user_name:
        user_name = input("Enter your Git user name: ")
    subprocess_call(["git", "config", "--global", "user.name", user_name])

    if not user_email:
        user_email = input("Enter your Git user email: ")
    subprocess_call(["git", "config", "--global", "user.email", user_email])

    if not signing_key:
        signing_key = input("Enter your Git signing key (leave blank to skip): ")
    if signing_key:
        subprocess_call(["git", "config", "--global", "user.signingkey", signing_key])
    else:
        subprocess_call(["git", "config", "--global", "--unset", "user.signingkey"])

    # Commit settings
    subprocess_call(["git", "config", "--global", "commit.gpgsign", "false"])

    # Init settings
    subprocess_call(["git", "config", "--global", "init.defaultBranch", "main"])

    # Core settings
    subprocess_call(["git", "config", "--global", "core.autocrlf", "false"])
    subprocess_call(["git", "config", "--global", "core.excludesfile", "~/.gitignore"])
    subprocess_call(["git", "config", "--global", "core.pager", "vim -c 'set nonumber buftype=nofile' -"])

    if shutil.which("nvim"):
        subprocess_call(["git", "config", "--global", "core.editor", "nvim"])
    elif shutil.which("vim"):
        subprocess_call(["git", "config", "--global", "core.editor", "vim"])
    elif shutil.which("vi"):
        subprocess_call(["git", "config", "--global", "core.editor", "vi"])

    # Color settings
    subprocess_call(["git", "config", "--global", "color.ui", "auto"])
    subprocess_call(["git", "config", "--global", "color.diff", "false"])
    subprocess_call(["git", "config", "--global", "color.status", "auto"])
    subprocess_call(["git", "config", "--global", "color.branch", "auto"])
    subprocess_call(["git", "config", "--global", "color.interactive", "auto"])

    # Diff and merge tools
    subprocess_call(["git", "config", "--global", "diff.tool", "vimdiff"])
    subprocess_call(["git", "config", "--global", "diff.colorMoved", "default"])
    subprocess_call(["git", "config", "--global", "difftool.prompt", "false"])
    subprocess_call(["git", "config", "--global", "merge.tool", "vimdiff"])

    # Aliases
    subprocess_call(["git", "config", "--global", "alias.d", "difftool"])
    subprocess_call(["git", "config", "--global", "alias.co", "checkout"])
    subprocess_call(["git", "config", "--global", "alias.br", "branch"])
    subprocess_call(["git", "config", "--global", "alias.ci", "commit"])
    subprocess_call(["git", "config", "--global", "alias.st", "status"])
    subprocess_call(["git", "config", "--global", "alias.unstage", "reset HEAD --"])
    subprocess_call(["git", "config", "--global", "alias.last", "log -1 HEAD"])
    subprocess_call(["git", "config", "--global", "alias.lg", "log --oneline --graph --decorate"])

    # Branch behavior
    subprocess_call(["git", "config", "--global", "branch.autosetuprebase", "always"])
    subprocess_call(["git", "config", "--global", "branch.main.rebase", "true"])
    subprocess_call(["git", "config", "--global", "branch.master.rebase", "true"])

    # Push and pull defaults
    subprocess_call(["git", "config", "--global", "push.default", "current"])
    subprocess_call(["git", "config", "--global", "push.autoSetupRemote", "true"])
    subprocess_call(["git", "config", "--global", "pull.default", "current"])
    subprocess_call(["git", "config", "--global", "pull.rebase", "true"])
    subprocess_call(["git", "config", "--global", "fetch.prune", "true"])

    # Reuse recorded resolution
    subprocess_call(["git", "config", "--global", "rerere.enabled", "true"])

    # Credentials
    subprocess_call(["git", "config", "--global", "credential.helper", "cache --timeout=7200"])

    # Git LFS
    subprocess_call(["git", "config", "--global", "filter.lfs.clean", "git-lfs clean -- %f"])
    subprocess_call(["git", "config", "--global", "filter.lfs.smudge", "git-lfs smudge -- %f"])
    subprocess_call(["git", "config", "--global", "filter.lfs.process", "git-lfs filter-process"])
    subprocess_call(["git", "config", "--global", "filter.lfs.required", "true"])

    # URL shortcuts
    subprocess_call(["git", "config", "--global", "url.git@github.com:.insteadOf", "https://github.com"])
    subprocess_call(["git", "config", "--global", "url.git@gitlab.com:.insteadOf", "https://gitlab.com"])

if __name__ == "__main__":
    GIT_USER = get_git_config("user.name")
    GIT_EMAIL = get_git_config("user.email")
    GIT_SIGNING_KEY = get_git_config("user.signingkey")
    setup_dotfiles()
    setup_gitconfig(user_name=GIT_USER, user_email=GIT_EMAIL, signing_key=GIT_SIGNING_KEY)
    print(
        "\nDotfiles installed successfully!"
        "\nGit config updated."
        "\nRestart your terminal or run: source ~/.zshrc"
    )

#!/usr/bin/env python3
# pylint: disable=bare-except
# ruff: noqa: E722

"""
Install dotfiles.
"""

import os
import shutil
import sys
from datetime import datetime
from subprocess import call as subprocess_call, check_output

ROOT_PATH = os.path.dirname(os.path.abspath(__file__))
HOME_DIR = os.environ.get("HOME")


def get_backup_dir():
    return os.path.join(HOME_DIR, ".local", "backups", "dotfiles")


def remove(path):
    if os.path.islink(path) or os.path.isfile(path):
        os.remove(path)
    elif os.path.isdir(path):
        shutil.rmtree(path, ignore_errors=True)


def copy(src, dest):
    if not os.path.isfile(src) and not os.path.isdir(src):
        return
    if os.path.isfile(src):
        remove(dest)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copy2(src, dest)
    elif os.path.isdir(src):
        remove(dest)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copytree(src, dest, dirs_exist_ok=True)


def link_file(src, dest):
    remove(dest)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    os.symlink(os.path.abspath(src), dest)


def get_git_config(field):
    command = ["git", "config", field]
    try:
        output = check_output(command)
        output = output.decode("utf-8").strip()
    except:
        return ""
    return output


def get_url_insteadof_configs():
    try:
        output = check_output(["git", "config", "--global", "--get-regexp", r"url\..*\.insteadOf"])
        output = output.decode("utf-8").strip()
    except:
        return {}
    result = {}
    for line in output.splitlines():
        key, _, value = line.partition(" ")
        suffix_pos = key.lower().rfind(".insteadof")
        url_prefix = key[len("url."):suffix_pos]
        result[value] = url_prefix
    return result


def setup_dotfiles():
    timestamp = datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
    backup_dir = os.path.join(get_backup_dir(), timestamp)

    for path in os.listdir("dotfiles"):
        src = os.path.join(HOME_DIR, path)
        dest = os.path.join(backup_dir, path)
        copy(src, dest)

    for module in os.listdir("modules"):
        module_path = os.path.join("modules", module)
        if os.path.isdir(module_path):
            for path in os.listdir(module_path):
                src = os.path.join(HOME_DIR, path)
                dest = os.path.join(backup_dir, path)
                copy(src, dest)

    for config in os.listdir("configs"):
        src = os.path.join(HOME_DIR, ".config", config)
        dest = os.path.join(backup_dir, ".config", config)
        copy(src, dest)

    for path in os.listdir("dotfiles"):
        src = os.path.join(ROOT_PATH, "dotfiles", path)
        dest = os.path.join(HOME_DIR, path)
        link_file(src, dest)

    for module in os.listdir("modules"):
        module_path = os.path.join("modules", module)
        if os.path.isdir(module_path):
            for path in os.listdir(module_path):
                src = os.path.join(ROOT_PATH, module_path, path)
                dest = os.path.join(HOME_DIR, path)
                link_file(src, dest)

    for config in os.listdir("configs"):
        src = os.path.join(ROOT_PATH, "configs", config)
        dest = os.path.join(HOME_DIR, ".config", config)
        link_file(src, dest)


def _download(url, dest, name):
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    try:
        from urllib.request import urlopen
        response = urlopen(url)
        with open(dest, "wb") as f:
            f.write(response.read())
        print("Downloaded " + name)
    except Exception as e:
        print(f"Warning: could not download {name}: {e}")


def download_git_scripts():
    base = "https://raw.githubusercontent.com/git/git/master/contrib/completion"
    config_d = os.path.join(HOME_DIR, ".sh.d", "config.d")

    _download(
        f"{base}/git-completion.bash",
        os.path.join(config_d, "90-git-completion.bash"),
        "git-completion.bash",
    )
    _download(
        f"{base}/git-completion.zsh",
        os.path.join(config_d, "91-git-completion.zsh"),
        "git-completion.zsh",
    )
    _download(
        f"{base}/git-prompt.sh",
        os.path.join(config_d, "92-git-prompt.sh"),
        "git-prompt.sh",
    )


def setup_gitconfig(user_name=None, user_email=None, signing_key=None, url_insteadof=None):
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

    subprocess_call(["git", "config", "--global", "commit.gpgsign", "false"])

    subprocess_call(["git", "config", "--global", "init.defaultBranch", "main"])

    subprocess_call(["git", "config", "--global", "core.autocrlf", "false"])
    subprocess_call(["git", "config", "--global", "core.excludesfile", "~/.gitignore"])
    subprocess_call(["git", "config", "--global", "core.pager", "vim -c 'set nonumber buftype=nofile' -"])

    if shutil.which("fresh"):
        subprocess_call(["git", "config", "--global", "core.editor", "fresh"])
    elif shutil.which("nvim"):
        subprocess_call(["git", "config", "--global", "core.editor", "nvim"])
    elif shutil.which("vim"):
        subprocess_call(["git", "config", "--global", "core.editor", "vim"])
    elif shutil.which("vi"):
        subprocess_call(["git", "config", "--global", "core.editor", "vi"])

    subprocess_call(["git", "config", "--global", "color.ui", "auto"])
    subprocess_call(["git", "config", "--global", "color.diff", "false"])
    subprocess_call(["git", "config", "--global", "color.status", "auto"])
    subprocess_call(["git", "config", "--global", "color.branch", "auto"])
    subprocess_call(["git", "config", "--global", "color.interactive", "auto"])

    subprocess_call(["git", "config", "--global", "diff.tool", "vimdiff"])
    subprocess_call(["git", "config", "--global", "diff.colorMoved", "default"])
    subprocess_call(["git", "config", "--global", "difftool.prompt", "false"])
    subprocess_call(["git", "config", "--global", "merge.tool", "vimdiff"])

    subprocess_call(["git", "config", "--global", "alias.d", "difftool"])
    subprocess_call(["git", "config", "--global", "alias.co", "checkout"])
    subprocess_call(["git", "config", "--global", "alias.br", "branch"])
    subprocess_call(["git", "config", "--global", "alias.ci", "commit"])
    subprocess_call(["git", "config", "--global", "alias.st", "status"])
    subprocess_call(["git", "config", "--global", "alias.unstage", "reset HEAD --"])
    subprocess_call(["git", "config", "--global", "alias.last", "log -1 HEAD"])
    subprocess_call(["git", "config", "--global", "alias.lg", "log --oneline --graph --decorate"])

    subprocess_call(["git", "config", "--global", "branch.autosetuprebase", "always"])
    subprocess_call(["git", "config", "--global", "branch.main.rebase", "true"])
    subprocess_call(["git", "config", "--global", "branch.master.rebase", "true"])

    subprocess_call(["git", "config", "--global", "push.default", "current"])
    subprocess_call(["git", "config", "--global", "push.autoSetupRemote", "true"])
    subprocess_call(["git", "config", "--global", "pull.default", "current"])
    subprocess_call(["git", "config", "--global", "pull.rebase", "true"])
    subprocess_call(["git", "config", "--global", "fetch.prune", "true"])

    subprocess_call(["git", "config", "--global", "rerere.enabled", "true"])

    subprocess_call(["git", "config", "--global", "credential.helper", "cache --timeout=7200"])

    subprocess_call(["git", "config", "--global", "filter.lfs.clean", "git-lfs clean -- %f"])
    subprocess_call(["git", "config", "--global", "filter.lfs.smudge", "git-lfs smudge -- %f"])
    subprocess_call(["git", "config", "--global", "filter.lfs.process", "git-lfs filter-process"])
    subprocess_call(["git", "config", "--global", "filter.lfs.required", "true"])

    defaults = {
        "https://github.com": "git@github.com:",
        "https://gitlab.com": "git@gitlab.com:",
    }
    merged = {**defaults, **(url_insteadof or {})}
    for instead_of, url_prefix in merged.items():
        subprocess_call(["git", "config", "--global", f"url.{url_prefix}.insteadOf", instead_of])


def find_latest_backup():
    backup_dir = get_backup_dir()
    if not os.path.isdir(backup_dir):
        return None
    backups = sorted(os.listdir(backup_dir))
    return os.path.join(backup_dir, backups[-1]) if backups else None


def restore():
    latest = find_latest_backup()
    if not latest:
        print("No backups found in {}".format(get_backup_dir()))
        return
    for root, dirs, files in os.walk(latest):
        for f in files:
            src = os.path.join(root, f)
            rel_path = os.path.relpath(src, latest)
            dest = os.path.join(HOME_DIR, rel_path)
            remove(dest)
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            shutil.copy2(src, dest)
    print("Restored from {}".format(latest))


if __name__ == "__main__":
    if "--restore" in sys.argv:
        restore()
        sys.exit(0)

    os.chdir(ROOT_PATH)

    GIT_USER = get_git_config("user.name")
    GIT_EMAIL = get_git_config("user.email")
    GIT_SIGNING_KEY = get_git_config("user.signingkey")
    URL_INSTEADOF = get_url_insteadof_configs()
    setup_dotfiles()
    download_git_scripts()
    setup_gitconfig(user_name=GIT_USER, user_email=GIT_EMAIL, signing_key=GIT_SIGNING_KEY, url_insteadof=URL_INSTEADOF)
    print(
        "\nDotfiles installed successfully!"
        "\nGit config updated."
        "\nRestart your terminal or run: source ~/.zshrc"
    )

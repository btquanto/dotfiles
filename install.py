#!/usr/bin/env python3
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

GIT_USER = get_git_config("user.name")
GIT_EMAIL = get_git_config("user.email")

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

def main():
    """
    Main function.
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

if __name__ == "__main__":
    GIT_USER = get_git_config("user.name")
    GIT_EMAIL = get_git_config("user.email")
    main()
    env = dict(**os.environ)
    env.update(dict(GIT_USER=GIT_USER, GIT_EMAIL=GIT_EMAIL))
    subprocess_call([os.environ.get("SHELL", "bash"), "-lc", "exit"], env=env, shell=True)

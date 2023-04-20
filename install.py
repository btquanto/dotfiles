#!/usr/bin/env python3
"""
Install dotfiles.
"""

import re
import os
import shutil
from datetime import datetime
from subprocess import call as subprocess_call

ROOT_PATH = os.path.dirname(os.path.abspath(__file__))
HOME_DIR=os.environ.get("HOME")

os.chdir(ROOT_PATH)

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

    pattern = re.compile(r"^(_)")
    for path in os.listdir("dotfiles"):
        template_path = os.path.join("dotfiles", path)
        dot_name = pattern.sub(".", path)
        home_path = os.path.join(HOME_DIR, dot_name)
        history_path = os.path.join(history_dir, dot_name)
        copy(home_path, history_path)
        copy(template_path, home_path)

    for module in os.listdir("modules"):
        module = os.path.join("modules", module)
        if os.path.isdir(module):
            for path in os.listdir(module):
                template_path = os.path.join(module, path)
                dot_name = pattern.sub(".", path)
                home_path = os.path.join(HOME_DIR, dot_name)
                history_path = os.path.join(history_dir, dot_name)
                copy(home_path, history_path)
                copy(template_path, home_path)

    for module in os.listdir("configs"):
        template_path = os.path.join("configs", module)
        home_path = os.path.join(HOME_DIR, ".config", module)
        history_path = os.path.join(history_dir, ".config", module)
        copy(home_path, history_path)
        copy(template_path, home_path)

if __name__ == "__main__":
    main()
    subprocess_call([os.environ.get("SHELL", "bash"), "-lc", ":"])

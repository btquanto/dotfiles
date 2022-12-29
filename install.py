#!/usr/bin/env python3
import sys
import re
import os
import shutil
import json
from string import Template
from datetime import datetime
from subprocess import call as subprocess_call

ROOT_PATH = os.path.dirname(os.path.abspath(__file__))
ENVIRON = os.environ.copy()
HOME_DIR=ENVIRON.get("HOME")

os.chdir(ROOT_PATH)

class SafeDict(dict):
    def __missing__(self, key):
        return f"{{{key}}}"

def call(*args, env=None):
    cmd = " ".join(map(lambda s : f'"{s}"' if " " in s else s, map(str, args)))
    print(cmd)
    environ = os.environ.copy()
    if env:
        environ.update(env)
    subprocess_call(cmd, shell=True, env=environ)

def copy(src, dest):
    if os.path.isfile(src):
        if os.path.exists(dest): os.remove(dest)
        shutil.copy(src, dest)
    elif os.path.isdir(src):
        shutil.rmtree(dest, ignore_errors=True)
        shutil.copytree(src, dest, dirs_exist_ok=True)

def gen_file(src, dest, env=None):
    if not env:
        env = {}
    if os.path.isfile(src):
        if os.path.exists(dest): os.remove(dest)
        with open(src, "r") as fin, open(dest, "w") as fout:
            content = Template(fin.read()).safe_substitute(**env)
            fout.write(content)
    elif os.path.isdir(src):
        shutil.rmtree(dest, ignore_errors=True)
        shutil.copytree(src, dest, dirs_exist_ok=True)

def gen_config(override=False):
    if not os.path.exists("config.json") or override:
        print("Config file (config.json) not found or invalid. Generating...\n")
        name = input("Enter your name: ")
        email = input("Enter your email: ")
        env = {
            "GIT_USER": name,
            "GIT_EMAIL": email
        }
    else:
        with open("config.json", "r") as f:
            env = json.load(f)
        if "GIT_USER" not in env or "GIT_EMAIL" not in env:
            return gen_config(True)
    return env

def main():
    global ENVIRON
    env = gen_config()

    with open("config.json", "w") as f:
        json.dump(env, f, indent=2)
    
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
        gen_file(template_path, home_path, env=env)

    for module in os.listdir("modules"):
        module = os.path.join("modules", module)
        if os.path.isdir(module):
            for path in os.listdir(module):
                template_path = os.path.join(module, path)
                dot_name = pattern.sub(".", path)
                home_path = os.path.join(HOME_DIR, dot_name)
                history_path = os.path.join(history_dir, dot_name)
                copy(home_path, history_path)
                gen_file(template_path, home_path, env=env)
        
    for module in os.listdir("configs"):
        template_path = os.path.join("configs", module)
        home_path = os.path.join(HOME_DIR, ".config", module)
        history_path = os.path.join(history_dir, ".config", module)
        copy(home_path, history_path)
        gen_file(template_path, home_path, env=env)
    

if __name__ == "__main__":
    main()
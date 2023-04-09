#!/usr/bin/env python3

import os
from os.path import isdir
import shutil
import argparse
from typing import List, Tuple, Dict

import toml
from jinja2 import Environment, FileSystemLoader


def get_args() -> argparse.Namespace:
  arg_parser = argparse.ArgumentParser(description="Lightweight common UVM TB generator")
  arg_parser.add_argument('-i', '--input', required=True, help='[Required] Input config file for TB generation')
  arg_parser.add_argument('-d', '--debug', required=False, default=False, action="store_true", help=argparse.SUPPRESS)
  args = arg_parser.parse_args()
  return args

def get_config(args : argparse.Namespace) -> Tuple[Dict, Dict]:
  tbg_cfg = toml.load(args.input)
  if 'global' not in tbg_cfg.keys():
    raise KeyError(f'[global] section in config file "{args.input}" should be given')
  if 'VIP' in tbg_cfg.keys():
    vip_cfg = tbg_cfg['VIP']
  else:
    vip_cfg = {}
  if args.debug:
    print('[DEBUG] TB config:')
    print(tbg_cfg)
  return (tbg_cfg, vip_cfg)

def get_path(tbg_cfg : dict, args : argparse.Namespace) -> Tuple[str, str]:
  if 'out_path' not in tbg_cfg['global'].keys():
    out_path = os.getcwd()
    tbg_cfg['global']['out_path'] = out_path
  else:
    out_path = replace_env(tbg_cfg['global']['out_path'])

  print(f'Script attempt to output to path "{out_path}"')

  try:
    if not os.path.isdir(out_path):
      os.makedirs(out_path)
  except FileNotFoundError:
    print(f'Output path "{out_path}" is not found and cannot be created')

  script_path = os.path.dirname(os.path.abspath(__file__))[:-4]
  template_path = f'{script_path}/template'
  if args.debug:
    print(f'[DEBUG] Script folder is {script_path}')
    print(f'[DEBUG] Template folder is {template_path}')
  return (out_path, template_path)

def create_hier(out_path : str, template_path : str, args : argparse.Namespace):
  if args.debug:
    print(f'[DEBUG] Copy all template from [{template_path}/verify] to [{out_path}/verify]')
  try:
    shutil.rmtree(f'{out_path}/verify')
  except:
    pass
  shutil.copytree(f'{template_path}/verify', f'{out_path}/verify')

def generate(out_path : str, template_path : str, module_name : str):
  env = Environment(loader=FileSystemLoader(template_path))
  env.trim_blocks = True
  env.lstrip_blocks = True
  for parent, dirs, files in os.walk(template_path):
    for file in files:
      if file != 'global.j2':
        tmpl_file = os.path.join(parent, file).split(template_path)[1][1:].replace('\\', '/')
        if args.debug:
          print(f'[DEBUG] {tmpl_file}')
        template = env.get_template(tmpl_file)
        with open(f'{out_path}/{tmpl_file}.tmp', 'w') as f:
          f.write(template.render(module=module_name, global_info=tbg_cfg['global'], vip_info=vip_cfg))
        target_file = tmpl_file.replace('/yuu_', f'/{module_name}_')
        shutil.move(f'{out_path}/{tmpl_file}.tmp', f'{out_path}/{target_file}')
        if target_file != tmpl_file:
          os.remove(f'{out_path}/{tmpl_file}')

def replace_env(path : str) -> str:
  words = path.split('/')
  for word in words:
    if word.startswith('$'):
      if word[1:].startswith('(') or word[1:].startswith('{'):
        path = path.replace(word, os.environ[word[2:-1]])
      else:
        path = path.replace(word, os.environ[word[1:]])
  return path

if __name__  == '__main__':
  args = get_args()
  (tbg_cfg, vip_cfg) = get_config(args)
  (out_path, template_dir) = get_path(tbg_cfg, args)
  module_name = tbg_cfg['global']['out_name']
  create_hier(out_path, template_dir, args)
  generate(out_path, template_dir, module_name)
  print(f'{module_name} TB generate done')

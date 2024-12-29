#!/usr/bin/env python3
import os
import sys
import subprocess
import argparse
from typing import List, Optional
from prompt_toolkit import PromptSession
from prompt_toolkit.completion import WordCompleter
from prompt_toolkit.shortcuts import radiolist_dialog
from prompt_toolkit.formatted_text import HTML

DEFAULT_IGNORE_DIRS = [
    "/Applications",
    "/usr",
    "/var",
    "/lib",
    "/bin",
    "/sbin",
    ".next",
    ".build",
    "build",
    "node_modules",
    "*vite*",
    "*cache*",
    "*tmp*",
    "dist",
    ".git",
    ".idea",
    ".vscode",
    "__pycache__",
    "*.pyc",
    "*.log",
    "*.swp",
    "*.swo"
]

class RipSearch:
    def __init__(self):
        self.parser = self._create_parser()
        
    def _create_parser(self) -> argparse.ArgumentParser:
        parser = argparse.ArgumentParser(
            description='Natural language wrapper for ripgrep',
            usage='''rip <command> [<args>]

Commands:
    help, --help, -h     Show this help message
    folder               Search for folders containing a string
    file                Search for files with specific criteria
    content             Search for string patterns inside files
    interactive         Launch interactive search mode
            '''
        )
        return parser

    def show_help(self):
        print("""
🔍 Rip Search Help 🔍
====================

Commands:
---------
rip folder <string>              Search for folders containing string
rip folder <string> --path       Specify search path (default: root)

rip file <string>               Search for files with exact name match
    --contains                  Search for files containing string
    --ext .xxx                  Filter by extension
    --ignore-ext .xxx          Ignore specific extensions
    --min-size <size>          Minimum file size (e.g., 1M, 1G)
    --max-size <size>          Maximum file size
    --sort-accessed            Sort by last accessed time
    
rip content <string>            Search for string inside files
    --env-only                 Search only in .env files
    --path                     Specify search path
    --ext                      Filter by extension
    --ignore-ext              Ignore extensions
    --min-size                Minimum file size
    --max-size                Maximum file size
    
Common Options:
--------------
--ignore-dir <dir>            Ignore additional directories
--no-ignore                   Don't use default ignore list

Default Ignored:
--------------
""" + "\n".join(f"- {dir}" for dir in DEFAULT_IGNORE_DIRS))

    def _build_base_command(self, search_path: str = "/") -> List[str]:
        cmd = ["rg", "--hidden", "--follow"]
        for ignore in DEFAULT_IGNORE_DIRS:
            cmd.extend(["--glob", f"!{ignore}"])
        cmd.append("--search-path")
        cmd.append(search_path)
        return cmd

    def search_folders(self, pattern: str, path: str = "/") -> None:
        cmd = self._build_base_command(path)
        cmd.extend(["--type", "d", "--glob", f"*{pattern}*"])
        self._execute_command(cmd)

    def search_files(self, pattern: str, contains: bool = False, 
                    ext: Optional[str] = None, ignore_ext: Optional[str] = None,
                    min_size: Optional[str] = None, max_size: Optional[str] = None,
                    sort_accessed: bool = False, path: str = "/") -> None:
        cmd = self._build_base_command(path)
        
        if contains:
            cmd.extend(["--glob", f"*{pattern}*"])
        else:
            cmd.extend(["--glob", pattern])
            
        if ext:
            cmd.extend(["--type", ext.lstrip('.')])
        if ignore_ext:
            cmd.extend(["--glob", f"!*.{ignore_ext.lstrip('.')}"])
        if min_size:
            cmd.extend(["--size-limit", f">={min_size}"])
        if max_size:
            cmd.extend(["--size-limit", f"<={max_size}"])
        if sort_accessed:
            cmd.append("--sort-accessed")
            
        self._execute_command(cmd)

    def search_content(self, pattern: str, env_only: bool = False,
                      ext: Optional[str] = None, ignore_ext: Optional[str] = None,
                      min_size: Optional[str] = None, max_size: Optional[str] = None,
                      path: str = "/") -> None:
        cmd = self._build_base_command(path)
        
        if env_only:
            cmd.extend(["--glob", "*.env*"])
        if ext:
            cmd.extend(["--type", ext.lstrip('.')])
        if ignore_ext:
            cmd.extend(["--glob", f"!*.{ignore_ext.lstrip('.')}"])
        if min_size:
            cmd.extend(["--size-limit", f">={min_size}"])
        if max_size:
            cmd.extend(["--size-limit", f"<={max_size}"])
            
        cmd.append(pattern)
        self._execute_command(cmd)

    def _execute_command(self, cmd: List[str]) -> None:
        try:
            print(f"Executing command: {' '.join(cmd)}")  # Debug line
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.stdout:
                print(result.stdout)
            if result.stderr:
                print("Error:", result.stderr, file=sys.stderr)
        except subprocess.CalledProcessError as e:
            print(f"Error executing command: {e}", file=sys.stderr)
        except FileNotFoundError:
            print("Error: ripgrep (rg) command not found. Please ensure ripgrep is installed.", file=sys.stderr)

    def interactive_mode(self):
        search_types = [
            ('folder', 'Search for folders containing a string'),
            ('file', 'Search for files (name or content)'),
            ('content', 'Search for text inside files')
        ]
        
        result = radiolist_dialog(
            title="Rip Search",
            text="What would you like to search for?",
            values=search_types
        ).run()
        
        if result == 'folder':
            pattern = input("Enter folder name pattern: ")
            path = input("Enter search path (default: /): ").strip() or "/"
            self.search_folders(pattern, path)
            
        elif result == 'file':
            pattern = input("Enter file pattern: ")
            contains = input("Search for files containing pattern? (y/n): ").lower() == 'y'
            ext = input("Filter by extension (e.g., py, js) [optional]: ").strip()
            ignore_ext = input("Ignore extension [optional]: ").strip()
            min_size = input("Minimum file size (e.g., 1M, 1G) [optional]: ").strip()
            max_size = input("Maximum file size [optional]: ").strip()
            sort_accessed = input("Sort by last accessed? (y/n): ").lower() == 'y'
            path = input("Enter search path (default: /): ").strip() or "/"
            
            self.search_files(
                pattern, contains, ext, ignore_ext,
                min_size, max_size, sort_accessed, path
            )
            
        elif result == 'content':
            pattern = input("Enter search pattern: ")
            env_only = input("Search only in .env files? (y/n): ").lower() == 'y'
            ext = input("Filter by extension [optional]: ").strip()
            ignore_ext = input("Ignore extension [optional]: ").strip()
            min_size = input("Minimum file size [optional]: ").strip()
            max_size = input("Maximum file size [optional]: ").strip()
            path = input("Enter search path (default: /): ").strip() or "/"
            
            self.search_content(
                pattern, env_only, ext, ignore_ext,
                min_size, max_size, path
            )

def main():
    rip = RipSearch()
    
    if len(sys.argv) < 2 or sys.argv[1] in ['help', '--help', '-h']:
        rip.show_help()
        return
        
    if sys.argv[1] == 'interactive':
        rip.interactive_mode()
        return
        
    command = sys.argv[1]
    if command == 'folder':
        if len(sys.argv) < 3:
            print("Error: Please provide a search pattern")
            return
        pattern = sys.argv[2]
        path = sys.argv[4] if len(sys.argv) > 4 and sys.argv[3] == '--path' else "/"
        rip.search_folders(pattern, path)
        
    elif command == 'file':
        if len(sys.argv) < 3:
            print("Error: Please provide a search pattern")
            return
        # Parse other arguments...
        rip.search_files(sys.argv[2])
        
    elif command == 'content':
        if len(sys.argv) < 3:
            print("Error: Please provide a search pattern")
            return
        # Parse other arguments...
        rip.search_content(sys.argv[2])
        
    else:
        print(f"Unknown command: {command}")
        rip.show_help()

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import os
import sys
import subprocess
import argparse
from typing import List, Optional
from prompt_toolkit import PromptSession
from prompt_toolkit.shortcuts import radiolist_dialog, yes_no_dialog
from prompt_toolkit.styles import Style

# Define a style for the prompt toolkit
style = Style.from_dict({
    'dialog': 'bg:#2E3440 fg:#D8DEE9',
    'dialog.body': 'bg:#3B4252 fg:#D8DEE9',
    'dialog.title': 'bg:#4C566A fg:#88C0D0',
    'dialog.text': 'fg:#EBCB8B',
    'dialog.button': 'bg:#5E81AC fg:#D8DEE9',
})

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
    file                 Search for files with specific criteria
    content              Search for string patterns inside files
    interactive          Launch interactive search mode
            '''
        )
        return parser

    def show_help(self):
        print("\033[1;36m🔍 Rip Search Help 🔍\033[0m")
        print("=" * 20)
        print("\033[1;34mCommands:\033[0m")
        print("-" * 20)
        print("rip folder <string>              Search for folders containing string")
        print("rip folder <string> --path       Specify search path (default: root)")
        print("rip file <string>               Search for files with exact name match")
        print("    --contains                  Search for files containing string")
        print("    --ext .xxx                  Filter by extension")
        print("    --ignore-ext .xxx           Ignore specific extensions")
        print("    --min-size <size>           Minimum file size (e.g., 1M, 1G)")
        print("    --max-size <size>           Maximum file size")
        print("    --sort-accessed             Sort by last accessed time")
        print("rip content <string>            Search for string inside files")
        print("    --env-only                  Search only in .env files")
        print("    --path                      Specify search path")
        print("    --ext                       Filter by extension")
        print("    --ignore-ext                Ignore extensions")
        print("    --min-size                  Minimum file size")
        print("    --max-size                  Maximum file size")
        print("\033[1;34mCommon Options:\033[0m")
        print("-" * 20)
        print("--ignore-dir <dir>               Ignore additional directories")
        print("--no-ignore                      Don't use default ignore list")
        print("\033[1;34mDefault Ignored:\033[0m")
        print("-" * 20)
        print(", ".join(f"- {dir}" for dir in DEFAULT_IGNORE_DIRS))

    def _build_base_command(self, search_path: str = "/") -> List[str]:
        cmd = ["rg", "--hidden", "--follow"]
        for ignore in DEFAULT_IGNORE_DIRS:
            cmd.extend(["--glob", f"!{ignore}"])
        cmd.append(search_path)
        return cmd

    def search_folders(self, pattern: str, path: str = "/") -> None:
        cmd = self._build_base_command(path)
        cmd.extend(["--type", "d", "-g", f"*{pattern}*"])
        self._execute_command(cmd)

    def search_files(self, pattern: str, contains: bool = False, 
                    ext: Optional[str] = None, ignore_ext: Optional[str] = None,
                    min_size: Optional[str] = None, max_size: Optional[str] = None,
                    sort_accessed: bool = False, path: str = "/") -> None:
        cmd = self._build_base_command(path)
        
        if contains:
            cmd.extend(["-g", f"*{pattern}*"])
        else:
            cmd.extend(["-g", pattern])
            
        if ext:
            cmd.extend(["--type", ext.lstrip('.')])
        if ignore_ext:
            cmd.extend(["-g", f"!*.{ignore_ext.lstrip('.')}"])
        if min_size:
            cmd.extend(["--size", f">={min_size}"])
        if max_size:
            cmd.extend(["--size", f"<={max_size}"])
        if sort_accessed:
            cmd.append("--sort=accessed")
            
        self._execute_command(cmd)

    def search_content(self, pattern: str, env_only: bool = False,
                      ext: Optional[str] = None, ignore_ext: Optional[str] = None,
                      min_size: Optional[str] = None, max_size: Optional[str] = None,
                      path: str = "/") -> None:
        cmd = self._build_base_command(path)
        
        if env_only:
            cmd.extend(["-g", "*.env*"])
        if ext:
            cmd.extend(["--type", ext.lstrip('.')])
        if ignore_ext:
            cmd.extend(["-g", f"!*.{ignore_ext.lstrip('.')}"])
        if min_size:
            cmd.extend(["--size", f">={min_size}"])
        if max_size:
            cmd.extend(["--size", f"<={max_size}"])
            
        cmd.append(pattern)
        self._execute_command(cmd)

    def _execute_command(self, cmd: List[str]) -> None:
        try:
            cmd.append("--debug")  # Add debug flag
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
        session = PromptSession(style=style)
        
        search_types = [
            ('folder', 'Search for folders containing a string'),
            ('file', 'Search for files (name or content)'),
            ('content', 'Search for text inside files')
        ]
        
        result = radiolist_dialog(
            title="Rip Search",
            text="What would you like to search for?",
            values=search_types,
            style=style
        ).run()
        
        if result == 'folder':
            pattern = session.prompt("Enter folder name pattern: ")
            path = session.prompt("Enter search path (default: /): ", default="/")
            self.search_folders(pattern, path)
            
        elif result == 'file':
            pattern = session.prompt("Enter file pattern: ")
            contains = yes_no_dialog(title="Contains", text="Search for files containing pattern?").run()
            ext = session.prompt("Filter by extension (e.g., py, js) [optional]: ", default="")
            ignore_ext = session.prompt("Ignore extension [optional]: ", default="")
            min_size = session.prompt("Minimum file size (e.g., 1M, 1G) [optional]: ", default="")
            max_size = session.prompt("Maximum file size [optional]: ", default="")
            sort_accessed = yes_no_dialog(title="Sort Accessed", text="Sort by last accessed?").run()
            path = session.prompt("Enter search path (default: /): ", default="/")
            
            self.search_files(
                pattern, contains, ext, ignore_ext,
                min_size, max_size, sort_accessed, path
            )
            
        elif result == 'content':
            pattern = session.prompt("Enter search pattern: ")
            env_only = yes_no_dialog(title="Env Only", text="Search only in .env files?").run()
            ext = session.prompt("Filter by extension [optional]: ", default="")
            ignore_ext = session.prompt("Ignore extension [optional]: ", default="")
            min_size = session.prompt("Minimum file size [optional]: ", default="")
            max_size = session.prompt("Maximum file size [optional]: ", default="")
            path = session.prompt("Enter search path (default: /): ", default="/")
            
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
        contains = '--contains' in sys.argv
        ext = next((arg for arg in sys.argv if arg.startswith('--ext=')), None)
        ignore_ext = next((arg for arg in sys.argv if arg.startswith('--ignore-ext=')), None)
        min_size = next((arg for arg in sys.argv if arg.startswith('--min-size=')), None)
        max_size = next((arg for arg in sys.argv if arg.startswith('--max-size=')), None)
        sort_accessed = '--sort-accessed' in sys.argv
        pattern = sys.argv[2]
        path = sys.argv[4] if len(sys.argv) > 4 and sys.argv[3] == '--path' else "/"
        
        rip.search_files(
            pattern, contains, ext.split('=')[1] if ext else None,
            ignore_ext.split('=')[1] if ignore_ext else None,
            min_size.split('=')[1] if min_size else None,
            max_size.split('=')[1] if max_size else None,
            sort_accessed, path
        )
        
    elif command == 'content':
        if len(sys.argv) < 3:
            print("Error: Please provide a search pattern")
            return
        # Parse other arguments...
        pattern = sys.argv[2]
        env_only = '--env-only' in sys.argv
        ext = next((arg for arg in sys.argv if arg.startswith('--ext=')), None)
        ignore_ext = next((arg for arg in sys.argv if arg.startswith('--ignore-ext=')), None)
        min_size = next((arg for arg in sys.argv if arg.startswith('--min-size=')), None)
        max_size = next((arg for arg in sys.argv if arg.startswith('--max-size=')), None)
        path = sys.argv[4] if len(sys.argv) > 4 and sys.argv[3] == '--path' else "/"
        
        rip.search_content(
            pattern, env_only, ext.split('=')[1] if ext else None,
            ignore_ext.split('=')[1] if ignore_ext else None,
            min_size.split('=')[1] if min_size else None,
            max_size.split('=')[1] if max_size else None,
            path
        )
        
    else:
        print(f"Unknown command: {command}")
        rip.show_help()

if __name__ == "__main__":
    main()
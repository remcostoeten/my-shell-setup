# Shell Configuration Setup

This is my personal (WiP) modular and scalable setup for managing my entire shell setup, including aliases and functions.

> [!NOTE]
> Directory paths, logic and naming is WiP hence the folder `TODO_RESTRUCTURE_FROM_HERE`.

## Directory Structure

```
TODO_RESTRUCTURE_FROM_HERE/
│
├── inject_all.sh               # Central script that sources all other injectors
│
├── injectors/
│   ├── alias_injector.bash     # Sources all alias files
│   └── function_injector.bash  # Sources all function files
│
├── functions/                  # Directory containing individual function scripts
│   ├── catcopy_function.bash
│   ├── colorize_logs.bash
│   ├── copypwd_function.bash
│   ├── countdown-timer.bash
│   ├── dir_size_calculator.bash
│   └── move_except.bash
│
├── aliases/                    # Directory containing individual alias scripts
│   ├── development_aliases.bash
│   ├── general_aliases.bash
│   ├── git_aliases.bash
│   └── navigation_aliases.bash
│
└── logs/
    └── log.log                 # Example log file for testing
```

## Flow / Architecture

> [!TIP]
> I opted for .bashrc and singular .bash partials, but exactly the same applies for .zshrc or .sh partials as they are backward compatible and thus interchangeable.

### 1. Injectors

#### inject_all.sh
This is the central script that sources both the `alias_injector.bash` and `function_injector.bash` scripts. By sourcing this file in your `.bashrc` or `.zshrc`, you ensure that all your aliases and functions are loaded in every new shell session.

#### alias_injector.bash
This script sources all alias files stored in the `aliases/` directory. Each alias file is categorized by its purpose, making it easy to manage and extend.

#### function_injector.bash
This script sources all function files stored in the `functions/` directory. Each function is modular and can be easily added or removed as needed.

### 2. Adding Individual Modules

#### Adding New Aliases
1. Create a new `.bash` file in the `aliases/` directory with your desired aliases.
2. Update `alias_injector.bash` to include your new alias file.

#### Adding New Functions
1. Create a new `.bash` file in the `functions/` directory with your new function.
2. Update `function_injector.bash` to include your new function file.

## Expanding and Scaling the Setup

As your setup grows, consider organizing aliases and functions into more specific categories. You can create subdirectories within `aliases/` or `functions/` if necessary, and adjust the injector scripts to source files from these new locations.

## 🗓️ To-Do's / Roadmap

- [ ] Add example bash function to README
- [ ] Add example bash alias module to README
- [ ] Expand the alias modules with daily drivers:
  - Application Aliases (e.g., `code`, `browser`, `folder`)
  - System Aliases (e.g., `shutdown`, `reboot`, `enter_bios`)
  - Custom Function Aliases (e.g., `recordmp3`, `start_fullscreen_rec`, `print_project_tree`)
  - Development Aliases (e.g., `dbpush`, `dbgen`, `dbmigrate` for drizzle-kit: `push`, `generate`, `migrate`)
  - Cleanup Aliases (e.g., `f = prettier --write . --single-quote --no-semi --tab-width 4`)
- [ ] Add plugins injector:
  - `Autojump`
  - `Syntax highlighter`
  - Other plugins
- [ ] Add library/CLI injector:
  - Install path for `bun` and `pnpm`
  - Install path for `NVM`
  - Install path for `Turso CLI`
  - Install path for `Vercel CLI`
  - Install path for `GitHub CLI`
- [ ] Miscellaneous:
  - Personal complex-super specific scripts, tools, helpers, CLIs

## Real World Examples

<details>
<summary>inject_all.bash example</summary>

```bash
#!/bin/bash

# Inject All Script

# ===============================
# Source Alias and Function Injectors
# ===============================

# Source the Alias Injector
source "`(dirname "`{BASH_SOURCE[0]}")/alias_injector.bash"

# Source the Function Injector
source "`(dirname "`{BASH_SOURCE[0]}")/function_injector.bash"
```
</details>

<details>
<summary>function_injector.bash example</summary>

```bash
#!/bin/bash

# Function Injector Script

# ===============================
# Define the base directory
# ===============================
function_dir="`(dirname "`{BASH_SOURCE[0]}")/functions"

# ===============================
# Source All Function Files
# ===============================

# Source Catcopy Function
source "`function_dir/catcopy_function.bash"

# Source Copypwd Function
source "`function_dir/copypwd_function.bash"

# Source Countdown Timer Function
source "`function_dir/countdown-timer.bash"

# Source Directory Size Calculator Function
source "`function_dir/dir_size_calculator.bash"

# Source Colorize Logs Function
source "`function_dir/colorize_logs.bash"

# Source Move Except Function
source "`function_dir/move_except.bash"
```
</details>

<details>
<summary>alias_injector.bash example</summary>

```bash
#!/bin/bash

# Alias Injector Script

# ===============================
# Define the base directory
# ===============================
alias_dir="`(dirname "`{BASH_SOURCE[0]}")/aliases"

# ===============================
# Source All Alias Files
# ===============================

# Source General Aliases
source "`alias_dir/general_aliases.bash"

# Source Navigation Aliases
source "`alias_dir/navigation_aliases.bash"

# Source Development Aliases
source "`alias_dir/development_aliases.bash"

# Source Git Aliases
source "`alias_dir/git_aliases.bash"
```
</details>

---

This setup ensures a clean and organized shell environment, allowing for easy expansion and maintenance. Feel free to customize and extend it according to your needs.

Much love xxx,

Remco Stoeten

# Docker Management Script

## Overview

This Docker Management Script is a Bash script designed to simplify the management of Docker containers and PostgreSQL databases. It provides an interactive command-line interface that allows users to perform various operations, such as viewing containers, removing containers, reinstalling Docker, and spinning up a new PostgreSQL database.

## Features

- **Interactive Menu**: Navigate through options using arrow keys with fuzzy searching capabilities.
- **Docker Management**: Easily view, remove, and manage Docker containers.
- **PostgreSQL Management**: Spin up a new PostgreSQL database with custom credentials.
- **Backup Functionality**: Automatically backs up existing configuration files before making changes.

## Prerequisites

Before using the script, ensure you have the following installed on your system:

- **Docker**: Make sure Docker is installed and running.
- **xclip**: This utility is used to copy the `DATABASE_URL` to the clipboard.
- **fzf**: A command-line fuzzy finder that enhances the user interface of the script.

## Installation Instructions

### 1. Install Docker

Follow the official Docker installation guide for your operating system: [Docker Installation](https://docs.docker.com/get-docker/)

### 2. Install xclip

On Ubuntu or Debian-based systems, you can install `xclip` using the following command:

# GridGames

GridGames is a compilation of grid based games built using the [LÖVE](https://love2d.org) framework. This is currently an hobby project for learning about game dev and having fun building games

## Getting Started

### Pre-requisites

- [LÖVE 11.4 or above](https://love2d.org)
- [Python 3.7 or above](https://www.python.org/downloads/)
- [Makelove](https://github.com/pfirsich/makelove)

LÖVE, Python, and Makelove should be in your PATH environment variable.

### Building the game

Execute the commands below by substituting `<Game Directory>` with the actual directory of the game you want to build.

```shell
cd <Game Directory>
makelove
```

Now you can navigate to `bin` directory and run the executable for your chosen platform.

## Games

The list of completed and planned games

### Completed

### Planned

- [x] Game of Life (Cellular Automata)
- [ ] Minesweeper
- [ ] Tic-tac-toe + variants
- [ ] Nonograms
- [ ] Voltorb Flip (HG/SS)
- [ ] Sudoku
- [ ] Crossword

## Contributing

> **Important**: Please follow the git config autocrlf setting mentioned for your operating system from [here](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings?platform=windows#global-settings-for-line-endings) to enforce the same line ending for all commits

### Setting up the dev environment

Please install the recommended VS code extensions. The basic configurations for the extensions have already been added to the workspace. Follow the below steps to debug the code.

#### VS Code

1. Open the lua file you want to debug inside the game's root directory
2. Select the "DEBUG" configuration in "Run and Debug" menu
3. Open command palette and select "Debug: Start Debugging" (Shortcut: F5)

#### CLI

1. Change the current working directory to the game's root directory not the project's root directory
2. Execute the command `love . debug`

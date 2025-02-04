# GridGames

GridGames is a compilation of grid based games built using the [LÖVE](https://love2d.org) framework. This is currently an hobby project for learning about game dev and having fun building games

## Getting Started

### Pre-requisites

- [LÖVE 11.4 or above](https://love2d.org)
- [Python 3.7 or above](https://www.python.org/downloads/)
- [Makelove](https://github.com/pfirsich/makelove)

LÖVE and Makelove should be in your PATH environment variable.

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

- [x] Minesweeper
- [ ] Tic-tac-toe + variants
- [ ] Nonograms
- [ ] Voltorb Flip (HG/SS)
- [ ] Sudoku
- [ ] Crossword

## Contributing

> **Warning**: The warning `in the working copy of '[file]', LF will be replaced by CRLF the next time Git touches it` will be seen by Windows OS users due enforcement of '**lf**' line endings. This warning can be ignored. In case, suppression of warning is required set safecrlf git config to false using the command `git config set core.safecrlf false`

### Setting up the dev environment

Please install the recommended VS code extensions. The basic configurations for the extensions have already been added to the workspace. Follow the below steps to debug the code.

#### VS Code

1. Open the lua file you want to debug inside the game's root directory
2. Select the "DEBUG" configuration in "Run and Debug" menu
3. Open command palette and select "Debug: Start Debugging" (Shortcut: F5)

#### CLI

1. Change the current working directory to the game's root directory not the project's root directory
2. Execute the command `love . debug`

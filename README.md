# Command Line Chess

![Alt text](/lib/images/chess.png?raw=true)

Command Line Chess is a chess game made with Ruby and played on your terminal. The game supports two players and as well one player against a computer AI.

## Instructions to Play
- Git clone the folder and navigate to it on your terminal
- Install colorize by typing in: "gem install colorize"
- Run the game with: "ruby game.rb"
- Have fun!

## Functionality
- All valid chess moves including en passant, castling, and pawn promotion are implemented
- Game checks for check, checkmate, and stalemate
- Computer AI features include:
  - captures high valued pieces relative to its piece's value
  - captures low valued pieces when it's safe to do so
  - avoid moving to a position where its piece can be captured

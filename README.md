# Chess

![Alt text](/lib/images/chess.png?raw=true)

Ruby Chess is a chess game made with Ruby and played on your terminal. The game supports two players as well as player against a computer AI.

## Instructions to Play
- Clone the folder and navigate to it on your terminal
- Install colorize gem by typing: "bundle install"
- Run the game with: "ruby game.rb"
- Have fun!

## Functionality
- All valid chess moves including en passant, castling, and pawn promotion are implemented
- Game checks for check, checkmate, and stalemate
- Computer AI features include:
  - captures high valued pieces relative to its piece's value
  - captures low valued pieces when it's safe to do so
  - avoid moving to a position where its piece can be captured

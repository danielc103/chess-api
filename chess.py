from dataclasses import dataclass
from flask import request, jsonify
from typing import Optional, Tuple
import flask

# create the flask app
app = flask.Flask(__name__)

@dataclass
class ChessPiece:
  piece_type: str
  color: str

  def to_dict(self):
    return {
      'pieceType': self.piece_type,
      'color': self.color
    }


class ChessBoard:
  def __init__(self):
    # initialize the board as an
    self.board = {}
    self.start_board()

  def start_board(self):
    """ Set up standard board using chess notation """
    self.board.clear()

    # place pawns
    for column in 'abcdefgh':
      self.board[f"{column}2"] = ChessPiece("Pawn", "White")
      self.board[f"{column}7"] = ChessPiece("Pawn", "Black")

    # place rooks
    self.board["a1"] = ChessPiece("Rook", "White")
    self.board["h1"] = ChessPiece("Rook", "White")
    self.board["a8"] = ChessPiece("Rook", "Black")
    self.board["h8"] = ChessPiece("Rook", "Black")

    # place knights
    self.board["b1"] = ChessPiece("Knight", "White")
    self.board["g1"] = ChessPiece("Knight", "White")
    self.board["b8"] = ChessPiece("Knight", "Black")
    self.board["g8"] = ChessPiece("Knight", "Black")

    # place bishops
    self.board["c1"] = ChessPiece("Bishop", "White")
    self.board["f1"] = ChessPiece("Bishop", "White")
    self.board["c8"] = ChessPiece("Bishop", "Black")
    self.board["f8"] = ChessPiece("Bishop", "Black")

    # place queens
    self.board["d1"] = ChessPiece("Queen", "White")
    self.board["d8"] = ChessPiece("Queen", "Black")

    # place kings
    self.board["e1"] = ChessPiece("King", "White")
    self.board["e8"] = ChessPiece("King", "Black")


  def get_board(self):
    """Get the current state of the board"""
    # return the board as a dictionary
    if not hasattr(self, 'board'):
       self.board = {}
    result = {}
    for position, piece in self.board.items():
      result[position] = piece.to_dict()
    return result
    #return {position: piece.to_dict() for position, piece in self.board.items()}

  def move_piece(self, position: str, new_position: str) -> Tuple[bool, Optional[str]]:
    """
    move a piece from one position to another
    returns a tuple of (success, error)
    """
    # check if the piece is on the board
    if position not in self.board:
      return False, f"No piece at {position}"

    # move piece
    self.board[new_position] = self.board[position]
    del self.board[position]
    return True, None


  def remove_piece(self, position: str) -> Tuple[bool, Optional[str]]:
   """
    removes a piece from the board at a given position
    returns a tuple of (success, error)
   """
   if position not in self.board:
     return False, f"No piece at {position}"

   # remove piece
   del self.board[position]
   return True, None

# initialize the board
board = ChessBoard()

# API endpoints
@app.route('/board', methods=['GET'])
def current_board():
  return jsonify({'board': board.get_board()}), 200


@app.route('/move', methods=['POST'])
def get_board():
  data = request.get_json()

  if not data:
    return jsonify({'error': 'No data provided'}), 400

  if 'from' not in data or 'to' not in data:
    return jsonify({'error': 'Missing from or to position'}), 400

  from_position = data['from']
  to_position = data['to']

  success, error = board.move_piece(from_position, to_position)

  if success:
    return jsonify({'message': 'Piece moved successfully', 'board': board.get_board()}), 200
  else:
    return jsonify({'error': error}), 400

@app.route('/remove', methods=['DELETE'])
def remove_piece():
  data = request.get_json()

  if not data:
    return jsonify({'error': 'No data provided'}), 400

  if 'position' not in data:
    return jsonify({'error': 'Missing position'}), 400

  position = data['position']

  success, error = board.remove_piece(position)

  if success:
    return jsonify({'message': 'Piece removed successfully', 'board': board.get_board()}), 200
  else:
    return jsonify({'error': error}), 400

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=5000)
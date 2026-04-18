from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from usuario import Usuario

usuario_bp = Blueprint("usuario", __name__, url_prefix="/usuario")

@usuario_bp.get("/home")
@jwt_required()
def home_usuario():
    """Rota principal para carregar os dados do usuário com TEA"""
    user_id = get_jwt_identity()
    usuario = Usuario.query.get_or_404(user_id)
    
    return jsonify({
        "mensagem": "Bem-vindo",
        "usuario": usuario.to_dict()
    }), 200
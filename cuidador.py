from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from usuario import Usuario
from auth_utils import requer_cuidador

cuidador_bp = Blueprint("cuidador", __name__, url_prefix="/cuidador")


@cuidador_bp.get("/meus-usuarios")
@jwt_required()
@requer_cuidador
def listar_usuarios_vinculados():
    """Lista todos os usuários vinculados a este cuidador."""
    cuidador_id = get_jwt_identity()
    cuidador = Usuario.query.get_or_404(cuidador_id)
    usuarios = cuidador.vinculados.all()
    return jsonify({
        "cuidador": cuidador.to_dict(),
        "usuarios_vinculados": [u.to_dict() for u in usuarios],
    }), 200


@cuidador_bp.post("/vincular/<int:usuario_id>")
@jwt_required()
@requer_cuidador
def vincular_usuario(usuario_id: int):
    """Vincula um usuário neurodivergente a este cuidador."""
    cuidador_id = get_jwt_identity()
    usuario = Usuario.query.get_or_404(usuario_id)

    if usuario.cuidador_id:
        return jsonify({"erro": "Usuário já possui cuidador vinculado."}), 409

    usuario.cuidador_id = cuidador_id
    from app import db
    db.session.commit()
    return jsonify({"mensagem": "Usuário vinculado com sucesso!", "usuario": usuario.to_dict()}), 200

from functools import wraps
from flask import jsonify
from flask_jwt_extended import get_jwt_identity
from usuario import Usuario, PerfilTipo

def requer_cuidador(fn):
    """
    Decorador para bloquear o acesso de quem não é cuidador.
    """
    @wraps(fn)
    def wrapper(*args, **kwargs):
        user_id = get_jwt_identity()
        usuario = Usuario.query.get(user_id)
        
        # Verifica se o usuário existe e se o perfil é de cuidador
        if not usuario or usuario.perfil != PerfilTipo.CUIDADOR:
            return jsonify({"erro": "Acesso negado. Recurso exclusivo para cuidadores."}), 403
            
        return fn(*args, **kwargs)
    return wrapper
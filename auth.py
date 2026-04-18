from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from app import db
from app.models.usuario import Usuario, PerfilTipo

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")


@auth_bp.post("/registrar")
def registrar():
    """
    Registra um novo usuário.
    Body JSON:
        nome, email, senha, perfil ("usuario" | "cuidador")
    """
    dados = request.get_json()

    campos = ["nome", "email", "senha", "perfil"]
    for campo in campos:
        if not dados.get(campo):
            return jsonify({"erro": f"Campo '{campo}' é obrigatório."}), 400

    if Usuario.query.filter_by(email=dados["email"]).first():
        return jsonify({"erro": "E-mail já cadastrado."}), 409

    try:
        perfil = PerfilTipo(dados["perfil"])
    except ValueError:
        return jsonify({"erro": "Perfil inválido. Use 'usuario' ou 'cuidador'."}), 400

    novo = Usuario(nome=dados["nome"], email=dados["email"], perfil=perfil)
    novo.set_senha(dados["senha"])
    db.session.add(novo)
    db.session.commit()

    token = create_access_token(identity=novo.id)
    return jsonify({"mensagem": "Cadastro realizado!", "token": token, "usuario": novo.to_dict()}), 201


@auth_bp.post("/login")
def login():
    """
    Autentica um usuário existente.
    Body JSON: email, senha
    """
    dados = request.get_json()

    if not dados.get("email") or not dados.get("senha"):
        return jsonify({"erro": "E-mail e senha são obrigatórios."}), 400

    usuario = Usuario.query.filter_by(email=dados["email"]).first()
    if not usuario or not usuario.verificar_senha(dados["senha"]):
        return jsonify({"erro": "Credenciais inválidas."}), 401

    if not usuario.ativo:
        return jsonify({"erro": "Conta desativada. Entre em contato com o suporte."}), 403

    token = create_access_token(identity=usuario.id)
    return jsonify({"token": token, "usuario": usuario.to_dict()}), 200


@auth_bp.get("/perfil")
@jwt_required()
def perfil_atual():
    """Retorna os dados do usuário autenticado."""
    user_id = get_jwt_identity()
    usuario = Usuario.query.get_or_404(user_id)
    return jsonify(usuario.to_dict()), 200

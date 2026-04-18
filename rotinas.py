from flask import Blueprint, request, jsonify

rotinas_bp = Blueprint('rotinas', __name__)

# Mock de banco de dados para testarmos rapidamente
rotinas_db = []

@rotinas_bp.route('/api/rotinas', methods=['GET'])
def get_rotinas():
    # Aqui filtraremos pelo ID do usuário vinculado ao cuidador
    return jsonify({"status": "success", "data": rotinas_db}), 200

@rotinas_bp.route('/api/rotinas', methods=['POST'])
def add_rotina():
    data = request.get_json()
    nova_rotina = {
        "id": len(rotinas_db) + 1,
        "titulo": data.get("titulo"),
        "icone": data.get("icone", "default.png"), # Ícones visuais ajudam muito
        "concluida": False
    }
    rotinas_db.append(nova_rotina)
    return jsonify({"status": "success", "data": nova_rotina}), 201
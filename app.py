from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_bcrypt import Bcrypt
from flask_migrate import Migrate
from dotenv import load_dotenv
import os
from flask import Blueprint, request, jsonify

load_dotenv()

db = SQLAlchemy()
jwt = JWTManager()
bcrypt = Bcrypt()
migrate = Migrate()


from flask import Flask
from flask_cors import CORS 

def create_app():
    app = Flask(__name__)
    CORS(app)

    # ── Configurações ──────────────────────────────────────────
    app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "dev-secret")
    app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "dev-jwt-secret")
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL", "sqlite:///neuroapp.db")
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # ── Extensões ─────────────────────────────────────────────
    db.init_app(app)
    jwt.init_app(app)
    bcrypt.init_app(app)
    migrate.init_app(app, db)

    # ── Blueprints ────────────────────────────────────────────
    from auth import auth_bp
    from cuidador import cuidador_bp
    from usuario_routes import usuario_bp
# E se você já criou o arquivo de rotinas que conversamos:
# from rotinas import rotinas_bp
    app.register_blueprint(auth_bp)
    app.register_blueprint(cuidador_bp)
    app.register_blueprint(usuario_bp)

    # ── Cria tabelas no primeiro uso ──────────────────────────
    with app.app_context():
        from usuario import Usuario  # noqa: garante que o modelo é importado Usuario  # noqa: garante que o modelo é importado
        db.create_all()

    @app.get("/")
    def health():
        return {"status": "ok", "app": "NeuroApp API"}, 200

    return app

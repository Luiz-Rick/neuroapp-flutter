from app import db, bcrypt
import enum
from datetime import datetime


class PerfilTipo(enum.Enum):
    USUARIO = "usuario"          # pessoa neurodivergente
    CUIDADOR = "cuidador"        # familiar ou responsável


class Usuario(db.Model):
    __tablename__ = "usuarios"

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    senha_hash = db.Column(db.String(256), nullable=False)
    perfil = db.Column(db.Enum(PerfilTipo), nullable=False)
    ativo = db.Column(db.Boolean, default=True)
    criado_em = db.Column(db.DateTime, default=datetime.utcnow)

    # Relação cuidador -> usuários vinculados
    cuidador_id = db.Column(db.Integer, db.ForeignKey("usuarios.id"), nullable=True)
    vinculados = db.relationship(
        "Usuario",
        backref=db.backref("cuidador", remote_side=[id]),
        lazy="dynamic",
    )

    def set_senha(self, senha: str):
        self.senha_hash = bcrypt.generate_password_hash(senha).decode("utf-8")

    def verificar_senha(self, senha: str) -> bool:
        return bcrypt.check_password_hash(self.senha_hash, senha)

    def to_dict(self):
        return {
            "id": self.id,
            "nome": self.nome,
            "email": self.email,
            "perfil": self.perfil.value,
            "ativo": self.ativo,
            "criado_em": self.criado_em.isoformat(),
            "cuidador_id": self.cuidador_id,
        }

    def __repr__(self):
        return f"<Usuario {self.email} [{self.perfil.value}]>"

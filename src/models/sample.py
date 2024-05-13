"""モデルのサンプル"""

from sqlalchemy import Column, Integer, String

from src.settings.database import Base


class Sample(Base):
    """サンプルなので実装開始のタイミングでマイグレーションファイルと一緒に削除してください"""

    __tablename__ = "samples"
    id = Column(Integer, primary_key=True, index=True)
    text = Column(String, index=True)

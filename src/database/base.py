"""alembicのmigrationファイルで使用するためのベースモデルを読み込むモジュール"""
from src.models.sample import Sample

# これより上にモデルを読み込んでください
from src.settings.database import Base

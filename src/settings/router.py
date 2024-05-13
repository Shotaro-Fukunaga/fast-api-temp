"""全てのルーティングをアプリケーションに設定するモジュール"""

from fastapi import FastAPI

from src.api.sample.sample_router import router as sample_router


def set_router(app: FastAPI) -> None:
    """ルーティングのセットアップ関数

    Args:
        app (FastAPI): FastAPIインスタンス
    """
    app.include_router(sample_router)

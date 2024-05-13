"""main"""

import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.settings.router import set_router

app = FastAPI()

# CORS設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ここで許可するオリジンを指定
    allow_credentials=True,
    allow_methods=["*"],  # GET, POST, PUT, DELETEなどを許可
    allow_headers=["*"],  # 任意のHTTPヘッダーを許可
)

# logging設定
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ルーターのセット
set_router(app)

@app.get("/")
def check_connection() -> dict:
    """接続チェック用のエンドポイント

    Returns:
        dict: サーバーが動作していることを示すメッセージ
    """
    logger.info("Connection check endpoint was called.")
    return {"status": "ok", "message": "Connection successful"}



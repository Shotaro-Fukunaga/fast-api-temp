"""データベースのセッションを管理するモジュール"""

from typing import Any, AsyncGenerator, Generator

from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Session, sessionmaker

from src.settings.config import ASYNC_DATABASE_URL, DATABASE_URL

# 同期セッションの作成
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)
Base = declarative_base()


# 非同期セッションの作成
async_engine = create_async_engine(ASYNC_DATABASE_URL, echo=True)
AsyncSessionLocal = async_sessionmaker(bind=async_engine, expire_on_commit=False, class_=AsyncSession)
AsyncBase = declarative_base()


def get_db() -> Generator[Session, Any, None]:
    """同期データベースセッションを取得する"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


async def get_async_db() -> AsyncGenerator[AsyncSession, None]:
    """非同期データベースセッションを取得する"""
    async with AsyncSessionLocal() as session:
        yield session

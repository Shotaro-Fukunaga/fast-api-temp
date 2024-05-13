# ベースイメージ
FROM python:3.12

# 作業ディレクトリの設定
WORKDIR /app

# 必要なファイルのコピー
COPY pyproject.toml poetry.lock /app/

# 環境変数の設定
ENV POETRY_HOME="/opt/poetry"
ENV PATH="$POETRY_HOME/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TZ=Asia/Tokyo

# Poetryのインストール
RUN curl -sSL https://install.python-poetry.org | python3 -

# アプリケーションソースのコピー
COPY src /app/src

# 依存関係のインストール
RUN poetry install --no-root

# ポートのエクスポート
EXPOSE 8000

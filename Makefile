# ************************************************
# 環境設定とセットアップコマンド
# ************************************************

# .envファイルの作成コマンド
make-env:
	@if [ -e .env ] ; then \
        echo ".env already exists"; \
    else \
		cp .env.example .env; \
	fi

# プロジェクトのセットアップ
setup:
	@make build
	@make up

# Dockerイメージのビルド
build:
	docker compose build

# Dockerコンテナの起動
up:
	docker compose up -d

# Dockerコンテナの停止
down:
	docker compose down

# Poetryのセットアップと依存関係のインストール
setup-poetry:
	poetry --version || curl -sSL https://install.python-poetry.org | python3 -
	poetry install

# サーバーの開発モード起動（デフォルト8000番）
# ポート8000番だとDockerサーバーのポートと被るので、必要に応じてポートを指定してください。
# 例：make dev 8001
dev:
	$(eval PORT := $(or $(filter-out $@,$(MAKECMDGOALS)), 8000))
	python3 -m uvicorn src.main:app --host 0.0.0.0 --port $(PORT) --reload || poetry run uvicorn src.main:app --host 0.0.0.0 --port $(PORT) --reload
%:
	@:

# 本番モードのデプロイ
deploy:
	@make setup-poetry
	@make migrate

# データベースサーバーの起動待機（5秒のディレイ）
wait-for-db:
	@echo "Waiting for database to be ready..."
	@sleep 5


# 初回セットアップ
init:
	@make make-env
	@make setup-poetry
	@make setup
	@make wait-for-db
	@make migrate

# ************************************************
# データベースマイグレーションコマンド
# ************************************************

# 新しいマイグレーションファイルを作成
migrate-new:
	$(eval NAME := $(filter-out $@,$(MAKECMDGOALS)))
	cd src/database && poetry run alembic revision -m "${NAME}"
%:
	@:

# 自動生成されたマイグレーションファイルを作成
migrate-auto:
	$(eval NAME := $(filter-out $@,$(MAKECMDGOALS)))
	cd src/database && poetry run alembic revision --autogenerate -m "$(NAME)"
%:
	@:

# DBのマイグレーションを実行
migrate:
	cd src/database && poetry run alembic upgrade head

# DB上の全てのテーブルをドロップ
drop:
	cd src/database && poetry run alembic downgrade base

# DBのリセット
fresh:
	cd src/database && poetry run alembic downgrade base && poetry run alembic upgrade head

# マイグレート履歴を表示
history:
	cd src/database && poetry run alembic history

# DBに現在適用されているマイグレートを表示
current:
	cd src/database && poetry run alembic current

# DBのダウングレード
downgrade:
	cd src/database && poetry run alembic downgrade "${ID}"

# シードファイルを実行(ファイル名を指定)
seed:
	$(eval SEED_FILE := $(filter-out $@,$(MAKECMDGOALS)))
	cd src/database/seeds && poetry run python3 "$(SEED_FILE)"
%:
	@:

# ************************************************
# Dockerコンテナ用コマンド
# ************************************************

# パッケージ一覧を表示
app-show:
	docker compose exec app bash -c "poetry show"

# appコンテナのマイグレーション実行
app-migrate:
	docker compose exec app bash -c "cd src/database && poetry run alembic upgrade head"

# appコンテナのシードファイルを実行(ファイル名を指定)
app-seed:
	$(eval SEED_FILE := $(filter-out $@,$(MAKECMDGOALS)))
	docker compose exec app bash -c "cd app/database/seeds && poetry run python3 $(SEED_FILE)"
%:
	@:

# appコンテナの全テーブルドロップ
app-drop:
	docker compose exec app bash -c "cd src/database && poetry run alembic downgrade base"

# appコンテナのDBリセット
app-fresh:
	docker compose exec app bash -c "cd src/database && poetry run alembic downgrade base && poetry run alembic upgrade head"

# appコンテナへの接続
app-exec:
	docker compose exec ${NAME} bash

# appコンテナのログ確認
app-log:
	docker compose logs -f app

# migrationログの確認
app-migrate-history:
	docker compose exec app bash -c "cd src/database && poetry run alembic history"

# appコンテナのセットアップ
app-setup:
	@make build
	@make up
	@make app-migrate
	@make app-seed
	@make app-log

# appコンテナへのシェル接続
shell:
	docker compose exec app bash

# Dockerコンテナとボリュームの削除
destroy:
	docker compose down -v

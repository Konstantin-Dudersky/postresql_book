Книга "PostgreSQL. Основы языка SQL."

Загрузить:

```bash
mkdir -p demo &&
cd demo &&
curl -o demo.zip https://edu.postgrespro.ru/demo-small.zip &&
unzip demo.zip &&
rm -f demo.zip &&
cd ..
```

Другие варианты:
demo-medium.zip
demo-big.zip


Восстановить БД из бекапа:

```bash
psql -h localhost -p 5432 -U postgres -f demo/demo_small.sql
```

Запустить:

```bash
docker compose up -d
```

Подключиться:

```bash
pgcli postgres://postgres:postgres@localhost:5432/demo
```

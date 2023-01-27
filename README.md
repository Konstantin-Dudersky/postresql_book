Книга "PostgreSQL. Основы языка SQL."

Загрузить:

```bash
mkdir -p demo &&
cd demo &&
curl -o demo.zip https://edu.postgrespro.ru/demo-small-20161013.zip &&
unzip demo.zip &&
rm -f demo.zip &&
cd ..
```

Создать БД:

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

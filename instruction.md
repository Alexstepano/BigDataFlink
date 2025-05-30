1. Клонируйте репозиторий и перейдите в каталог проекта:


2. Поднимите все сервисы:

   ```bash
   docker-compose up -d 
   ```


3. Для запуска job в Flink в необходимое вам время используйте команду:
```bash
docker exec -it jobmanager ./bin/sql-client.sh embedded -f /files/flink.sql
   ```
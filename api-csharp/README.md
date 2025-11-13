## Desafio Avine API

### Pré‑requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)

> Não é necessário instalar o .NET SDK/Runtime ou MySQL localmente: tudo roda dentro dos contêineres.

### Como executar

```bash
docker compose up --build
```

Isso irá:

1. Construir a imagem da API com `dockerfile.dev` (multi-stage SDK + runtime).
2. Subir um contêiner `mysql:8.0` com usuário/senha já configurados.
3. Inicializar a aplicação ASP.NET em `http://localhost:8080` com Swagger ativo em ambiente de desenvolvimento.

A API aplica automaticamente o `EnsureCreated` no banco ao iniciar, então a base `tasksdb` é criada na primeira execução. Os dados ficam persistidos no volume `mysql-data` definido no `docker-compose.yml`.

### Comandos úteis

- Encerrar os serviços: `docker compose down`
- Encerrar e limpar volumes (inclui apagar dados do MySQL): `docker compose down -v`
- Consultar logs: `docker compose logs -f api`

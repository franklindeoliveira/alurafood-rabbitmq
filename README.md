# Sobre o Projeto
Este projeto é uma aplicação de delivery de comida utilizando RabbitMQ para mensageria e MySQL como banco de dados.

A aplicação é composta por três serviços principais:
* Um produtor RabbitMQ para registro do pagamento da compra.
* Dois consumidores: um que confirma o pedido após o pagamento e outro que solicita para o cliente a avaliação do pedido.
* Um banco de dados MySQL para armazenar os dados dos pagamentos.

## Como iniciar a aplicação:

### Passo 1: Baixar o projeto
```
git clone https://github.com/franklindeoliveira/alurafood-rabbitmq.git
```
### Passo 2: Iniciar o cluster RabbitMQ e MySQL
```
cd alurafood-rabbitmq
docker compose up -d
```

### Passo 3: Configurar a replicação entre os nós do RabbitMQ
Acessar o console http://localhost:15672, ir em Admin -> Policies -> Add / update a policy e adicionar a seguinte política:
```
Name: ha-all
Pattern: .*
Definition: ha-mode = all
Apply to: Exchanges and Queues
```

### Passo 4: Configurar o MySQL
Criar a tabela pagamentos (informar essa senha: root):

```
docker exec -it alurafood-pagamento mysql -u root -p alurafood-pagamento
```

```
CREATE TABLE pagamentos (
 id bigint(20) NOT NULL AUTO_INCREMENT,
 valor decimal(19,2) NOT NULL,
 nome varchar(100) DEFAULT NULL,
 numero varchar(19) DEFAULT NULL,
 expiracao varchar(7) DEFAULT NULL,
 codigo varchar(3) DEFAULT NULL,
 status varchar(255) NOT NULL,
 forma_de_pagamento_id bigint(20) NOT NULL,
 pedido_id bigint(20) NOT NULL,
PRIMARY KEY (id)
);
```
### Passo 4: Iniciar o microserviço de pagamentos
```
cd pagamentos
mvn spring-boot:run
```

### Passo 5: Iniciar o microserviço de pedidos
```
cd pedidos
mvn spring-boot:run
```

### Passo 6: Iniciar o microserviço de avaliação
```
cd avaliacao
mvn spring-boot:run
```

### Passo 7: Realizar um pagamento
```
curl -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:8080/pagamentos  -d '{"valor":1300.0,"nome":"Carla","numero":"123456","expiracao":"10/2028","codigo":875,"status":"CONFIRMADO","formaDePagamentoId":1,"pedidoId":156}'
```
### Passo 8: Verificar no console dos serviços de pedido e avaliação se foram notificados do pagamento aprovado

### Passo 9: Verificar os dados do pagamento no MySQL (informar essa senha: root)
```
docker exec -it alurafood-pagamento mysql -u root -p alurafood-pagamento
select * from pagamentos;
```

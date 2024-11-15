# Container

## O que é um Container?

Um **container** é um ambiente isolado que compartilha recursos computacionais com o host. Apesar de estar rodando no mesmo hardware, ele mantém a operação independente, ou seja, se um container falhar, os outros não serão afetados. Ele contém todos os elementos necessários para rodar uma aplicação e, geralmente, é projetado para ter **uma responsabilidade única**, que é executar o binário da sua aplicação.

- **LXC (Linux Containers)**: é uma tecnologia nativa para rodar containers no Linux. O **Docker** é uma interface que facilita o gerenciamento e uso dos containers.

### E as Máquinas Virtuais?

- **Máquinas Virtuais** (VMs) executam **seu próprio sistema operacional** completo, o que consome mais recursos.
- Já **os containers** compartilham o kernel do sistema operacional do host, tornando-os mais **leves e portáteis**.
- Se o servidor físico ou a VM falhar, todas as máquinas virtuais ou containers podem ser afetados. No entanto, com containers, a **isolação** é melhor, o que ajuda a minimizar impactos.

## Docker

O **Docker** surgiu há cerca de 15 anos e foi escrito em **Go**. Ele é uma **interface para lidar com containers** e usa recursos do **kernel Linux** para segregar processos e manter a execução independente.

### Vantagens do Docker:
- **Portabilidade**: A aplicação em container funciona em qualquer lugar.
- **Ciclo de entrega facilitado**: Não é necessário configurar o servidor, a imagem Docker já vem com todas as dependências.
- **Leveza e Eficiência**: Containers são mais leves do que VMs e não possuem o overhead de sistemas operacionais completos.

### Princípios de Isolamento

- **Cgroups**: Funcionalidade do Linux que permite controlar e limitar o uso de recursos, como memória, CPU, e I/O, para cada processo. Isso garante que o container não use todos os recursos do host.
- **Namespaces**: Permite o isolamento de recursos, como redes, arquivos e processos.
- **Unshare**: Comando no Linux que cria um novo namespace, proporcionando isolamento completo.

## OCI - Open Container Initiative

### O que é?

A **Open Container Initiative (OCI)** é uma estrutura de governança mantida pela **Linux Foundation** com o objetivo de estabelecer padrões de mercado para containers.

- **Objetivo**: Garantir **interoperabilidade** entre diferentes fornecedores de containers e promover a **portabilidade**.

### Objetivos do OCI

- **Containers agnósticos**: Containers não devem ser associados a um fornecedor específico.
- **Portabilidade**: Garantir que containers criados em uma plataforma possam ser executados em qualquer outra.

## Como Trabalhar com Containers

### Docker

O **Docker** é uma das plataformas mais utilizadas para trabalhar com containers. Ele facilita a criação e gerenciamento de containers.

1. **Imagem**: É o "build" da sua aplicação, um modelo imutável que define como o container será executado.
2. **Container**: É uma instância em execução de uma imagem Docker. Containers são **efêmeros**, ou seja, uma vez que o ciclo de vida deles termina, os arquivos contidos no container são deletados.

### Dockerfile

Um **Dockerfile** é um arquivo de texto que contém os passos para **criar uma imagem Docker**. Ele é um manual declarativo para configurar o ambiente e os passos necessários para executar uma aplicação dentro do container.

#### Passos para Criar um Dockerfile

1. **FROM**: Define a imagem base, geralmente com um sistema operacional e dependências de tecnologia já instalados.
2. **WORKDIR**: Define o diretório de trabalho dentro da imagem.
3. **COPY**: Copia arquivos da máquina local para dentro do container.
4. **RUN**: Executa comandos dentro da imagem (ex: instalar dependências).
5. **EXPOSE**: Exponha as portas que serão usadas pela aplicação.
6. **CMD**: Define o comando padrão que será executado quando o container for iniciado.

### Exemplo de Dockerfile

```dockerfile
# Imagem base
FROM python:3.12

# Definindo o diretório de trabalho
WORKDIR /app

# Copiando o arquivo de dependências e instalando-as
COPY requirements.txt /app/

RUN pip install flask

# Copiando o código da aplicação
COPY app.py /app/app.py

# Expondo a porta
EXPOSE 5001

# Comando para rodar a aplicação
CMD [ "python", "app.py" ]
```

### Construindo e Verificando a Imagem

1. **Construção da Imagem**:
Após criar o Dockerfile, use o comando para construir a imagem:
```bash
docker build -t nome_imagem path_dockerfile
```
2. Verificar a Imagem: Para verificar a imagem construída:
```bash
docker image ls nome_imagem
```
Ou listar todas as imagens:
```bash
docker image ls
```
Para validar os passos do Dockerfile aplicados na imagem:
```bash
docker image history nome_imagem
```

### Rodando o Container

1. Rodando um Container: Para rodar o container baseado em uma imagem criada:
```bash
docker run --rm -p 3000:3000 nome_imagem
```
Onde:
- `--rm`: o container sera removido automaticamente após o ciclo de vida se encerrar
- `-p`: mapeia a porta do seu computador para a porta do container

1. Verificando os Container em Execução:
Para listar os containers em execução:
```bash
docker ps
```
3. Parar um Container:
Para parar um container, primeiro obtenha o ID do container com `docker ps`, depois:
```bash
docker container stop id_container
```
Se tentar reiniciar um container com a flag `--rm`, ele será removido automaticamente:
```bash
docker start id
```
Para verificar que o container não está mais presente:
```bash
docker ps -a
```

4. Rodando em Modo Background (Detached Mode):
Para rodar o container em segundo plano:
```bash
docker run -p 5001:5001 -d nome_imagem
```
O comando `-d` faz com que o container rode em segundo em plano (modo `detached`).

5. Visualizar os Logs do Container:
Para verificar os logs do container:
```bash
docker logs id_container
```

### Boas Práticas e Otimização
1. Utilizar arquivos de gerenciamento de dependências:
Arquivos de gerenciamento de dependências garantem que todas as bibliotecas necessárias sejam instaladas de forma consistente, reduzindo problemas de compatibilidade e otimizando o cache do Docker.

**Crie o arquivo de dependências**  
   Utilize a ferramenta da sua linguagem para gerar um arquivo de dependências. Exemplos:
   - **Python:**  
     ```bash
     pip freeze > requirements.txt
     ```
**Benefícios**
- **Reprodutibilidade:** Garante que as mesmas dependências sejam usadas em qualquer ambiente.
- **Performance:** Aproveita o cache do Docker, reduzindo o tempo de build.
- **Manutenção:** Facilita atualizações e rastreamento de dependências.

---

2. Separar a Cópia de Arquivos:
Se tentar reiniciar um container com a flag --rm, ele será removido automaticamente:

Exemplo:
```dockerfile
COPY requirements.txt /app/
RUN pip install -r requirements.txt
COPY . /app/
```

---

3. Utilizar .dockerignore:
User o `.dockerignore` para evitar que arquivos desnecessários (como `.git`, `node_modules`, etc.) sejam copiados para dentro da imagem.

---

4. Trabalhar com Tags:
Sempre use tags para versionar suas imagens. Isso é essecial, especialmente em ambientes de CI/CD, para garantir que você está utilizando a versão correta da imagem.
Exemplo:
```bash
docker build -t minha_imagem:v1.0 .
```

---

5. Imagem Slim ou Alpine:
Sempre que possível, use imagens slim ou alpine para reduzir o tamanho da imagem e melhorar a segurança e performance.

---

### Dockerfile refatorado
```docckerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py /app/app.py

EXPOSE 5001

CMD [ "python", "app.py" ]
```

### Conclusão

- **Containers** oferecem um ambiente isolado e portátil para rodar suas aplicações.
- O **Docker** é a ferramenta principal para criação e gestão de containers, facilitando a entrega de software.
- Ao criar containers, use **Dockerfiles** para configurar o ambiente e garantir que a aplicação seja executada de forma consistente.
- **Boas práticas**, como usar imagens menores e versionar suas imagens com tags, são essenciais para otimizar o desempenho e segurança.

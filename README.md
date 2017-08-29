# Ambiente para desenvolvimento das aplicações web do projeto SIM

Esse ambiente montado possui dois containers para suprir o backend do projeto:

* Jboss EAP 6 rodando backend do SIM (sin-ear-0.0.3.ear, kie-server.war, sanfom-servicos.ear, h2console.war)
* Redhat Single Sign-On

O desenvolvimento da aplicação web é realizado diretamente na máquina host.

![esquema disposição containers](esquema.png)

### Pré-requisitos
* Acesso ao código fonte dos projetos sin-bpm, ancine-api e sin.
* Configurar hosts da máquina.
* Configurar acesso aos repositórios maven da redhat. [link](https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/6.4/html/Development_Guide/sect-Use_the_Maven_Repository.html#Configure_the_JBoss_Enterprise_Application_Platform_Maven_Repository)
* [docker](https://docs.docker.com/engine/installation/) - Ferramenta para rodar containers. (>=17.06)
* [docker-compose](https://docs.docker.com/compose/install/) - Ferramenta para rodar aplicações multi-container (>= 1.14.0)
* [git](https://git-scm.com/downloads) - Gerenciador de versões (>= 2.13.2)
* [git-flow](https://github.com/nvie/gitflow/wiki/Installation) - Ferramenta para auxiliar a criação de branches de desenvolvimento (=> 0.4.1). 
* [node/npm](https://nodejs.org/en/) - Runtime Javascript para desenvolvimento web (>=6.11.2)


### Configuração arquivos de hosts
Siga as instruções nesse [link](https://support.rackspace.com/how-to/modify-your-hosts-file/) para adicionar uma linha no arquivo hosts da sua máquina.

```
127.0.0.1   sso.ancine.gov.br api.ancine.gov.br
```


### Para rodar ambiente com código fonte (opção 1)
Configure os argumentos SRC_GIT_SERVER e SRC_GIT_BRANCH no arquivo docker-compose.yml e reconstrua a imagem ancine/sim-dev-frontend, comente a linha que mapeia o volume da pasta ./src.
``` 
docker-compose.yml
...
  bpm:
    build: 
      context: ./sim-dev-bpm
      args: 
        - SRC_GIT_REPO=http://usuárioXYZ:senhaXYZ@gitlab.ancine.gov.br/ancine/sin-bpm.git
        - SRC_GIT_BRANCH=feature/regra-planilha-hierarquia-solicitacoes
...
      volumes:
        #- /src:/opt/jboss/src
...
```

```
$ docker-compose up --build
```
    

### Para rodar ambiente com código fonte (opção 2)
Clone os repositórios sin-bpm, ancine-api e sin na pasta ./src. Lembre de mapear o volume no arquivo docker-compose.yml. 
```
docker-compose.yml
...
    volumes:
      - ./src:/opt/jboss/src
...
``` 

```
Exemplo clone repositório
$ mkdir -p src
$ cd src
$ ./download-repositories.sh
$ cd ..
$ docker-composer up
```


### Rodando ambiente de desenvolvimento web
Com os serviços de backend rodando você poderá iniciar o ambiente de desenvolvimento web. Vá para pasta com o código da aplicação web e execute os comandos:
```
cd src/sin/sin/sin-web/sin-web-external/src/main/app
npm install
npm start
```

Visite o endereço http://localhost:3000 no navegador.


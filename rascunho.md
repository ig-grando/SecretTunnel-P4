https://www.youtube.com/watch?v=UEMAvXXNWsY: 
Um dispositivo que vc pode programar com P4 é chamado target
Tipo C, mas sem loop
Duas versões 14 e 16, a mais recente diminuiu a quantidade de keywords para 40 ao invés de 60
Todos os protocolos, por mais que conhecidos devem ser definidos explicitamente
O parser é uma máquina de estados, com estados definidos
Não entendi data plane pipeline, que contem control block, que contem table

Não mexer no arquivo python, ele roda automaticamente

O que fazer( pode estar errado )
Fazer arquivo de teste python (ele fala pra usar o scapy)

Rodar 3 terminais:
Um com o switch seguindo os passos do mano
Um escutando a porta: `sudo tcpdump -i veth16`
Um pra rodar o script de teste python

Comandos docker:
`docker compose up -d`
- cria container e deixa rodando em background

`docker compose down`
- derruba o container

`docker ps`
- Ver se está rodandp o container

`docker exec -ti p4studio bash`
- abre um terminal dentro do container, pode abrir vários


precisei rodar isso pra o switch fazer o forward, pode rodar no terminal do container, antes de estar em ~/project

/home/dev/open-p4studio/install/bin/bfshell -b /home/dev/project/src/secret/setup.py

E resulta em algo assim:
dev@p4studio:~$ /home/dev/open-p4studio/install/bin/bfshell -b /home/dev/project/src/secret/setup.py
bfrt_python /home/dev/project/src/secret/setup.py
exit

        ********************************************
        *      WARNING: Authorised Access Only     *
        ********************************************
    

bfshell> bfrt_python /home/dev/project/src/secret/setup.py
cwd : /home/dev/open-p4studio

We've found 1 p4 programs for device 0:
secret
Creating tree for dev 0 and program secret

Starting setup for secret
Clearing table entries
Clearing table pipe.SwitchIngress.forward               ... (Empty) Done
Populating table entries
Configuring Tofino
Configuring ports
Available symbols:
dump                 - Command
info                 - Command
mirror               - Node
port                 - Node
pre                  - Node
secret               - Node
tf1                  - Node

bfshell> exit

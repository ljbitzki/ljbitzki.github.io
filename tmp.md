
# TrueState-SNA - Experimento

## Sobre a aplicação e o ambiente do experimento

O **TrueState-SNA** é um projeto que visa automatizar a configuração e aplicações de regras de firewall em servidores e dispositivos de segurança, automaticamente a partir do SSoT, em dois cenários:

 1. Monitoramento da disponibilidade um serviço e liberação no firewall local para possibilitar seu acesso;
 2. Mitigação de ataque DoS em tempo real através de monitoramento de acessos e implantação de regras de firewall para o endereço de origem do atacante.

## Opções para o experimento:

 1. Imagem de **VirtualBox** com ambiente auto-contido já preparado para o experimento (testado em SO Microsoft Windows 10 ou superior e Linux).
 2. Baixar todos os artefatos envolvidos e executá-los localmente no computador (testado em SO baseada em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variáveis)


## Opção 1: Requisitos

Antes de iniciar a configuração, certifique-se de que possui os seguintes requisitos de hardware e aplicações instaladas:

* Processador 64 bits com no mínimo 4 núcleos e flag de virtualzação VT-x ativada na BIOS
* 4 GB de RAM livres, para uso exclusivo do laboratório
* VirtualBox 7.1 ou superior [link](https://www.virtualbox.org/wiki/Downloads)
* VirtualBox Extension Pack 7.1 [link](https://www.virtualbox.org/wiki/Downloads)

### Opção 1: Download do Laboratório

Baixe o laboratório do experimento que está disponível através de um Appliance do Virtualbox [aqui](https://drive.google.com/file/d/1MJuQxlu-7Nstxtwwlv9CiOo5vvHcApwm/view?usp=sharing).

### Opção 1: Importação do Laboratório

Importe o arquivo _experimento-sf.ova_ no Virtualbox.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250516_122234.png" alt="Import 01" style="float: left; width: 50%; height: auto;">
<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250516_122409.png" alt="Import 02" style="float: left; width: 50%; height: auto;">


> [!CAUTION]
> É necessário escolher a opção **Incluir todos os endereços MAC em placas de rede** em *Política de endereço MAC*.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250516_122446.png" alt="Import 01" style="float: left; width: 50%; height: auto;">


Clique em *Finalizar* e aguarde o processo de importação.

## Opção 1: O Ambiente do Laboratório

O laboratório é composto por uma VM e depende de endereçamento IP interno para o funcionamento esperado:

* Xubuntu 24.04 (experimento-sf)
* Interface de rede **vboxnet0** (geralmente, esta rede está habilitada por padrão numa instalação típica do VirtualBox)

### Opção 1: Inicializando o ambiente

Selecionar a VM e clicar em *Iniciar*, o Virtualbox poderá emitir um alerta sobre o consumo de recursos, dependendo da disponibilidade atual do host onde o experimento será executado. Clique OK caso ocorra.

> [!NOTE]
> A falta de recursos disponíveis pode ocasionar erros e a VM não inicializar.
> Se isso acontecer em um ambiente linux, tente liberar _cache_ de memória RAM com o comando
> `sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'`

1. A autenticação da VM *experimento-sf* tem como usuário e senha ***net2d/net2d***.

2. Abra um terminal na VM e inicialize o ambiente com o comando:

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250512_153235.png" alt="Import 03" style="float: left;">

```bash
iniciar-ambiente
```
3. A preparação do ambiente poderá levar vários segundos, podendo levar mais de um minuto, dependendo dos recursos do host. Aguarde até uma mensagem informar o término da inicialização do ambiente.

4.  Após a inicialização do ambiente, abra o navegador na VM e acesse o Netbox e o Grafana através dos atalhos salvos na barra de favoritos do navegador.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250512_153927.png" alt="Import 05" style="float: left;">

## Opção 1: O Experimento

O experimento consiste em:

- Inicializar o ambiente (passo descrito anteriormente)

- Verificar a normalidade dos acessos ao contêiner do servidor nginx através do Grafana (navegador) e do iptables do servidor (comando no terminal)

- Iniciar um ataque

- Observar o pico de acessos pelo Grafana (DoS) e a subsequente interrupção dos acesso (implantação da mitigação automatizada)

- Verificar o serviço de bloqueio no SSoT Netbox (navegador) e a regra ativa no iptables do contêiner do servidor do nginx (comando no terminal)

- Remover o serviço de bloqueio no SSoT Netbox (navegador) e acompanhar o restabelecimento dos acessos pelo Grafana (navegador).

Para iniciar o experimento siga os passos a seguir.

### 1. Verificar regra de firewall, serviço e acessos ao servidor

1. No desktop da VM *experimento-sf* abra o navegador *Chromium* e as abas Grafana e Netbox que estão salvas na barra de favoritos do navegador. A autenticação no Netbox é ***admin/admin***

2. Na aba do Grafana, é possível acompanhar os acessos de um cliente ao contêiner do nginx em tempo real. *Há um script simulando de 1 a 9 acessos por segundo, aleatoriamente, para facilitar a visualização do gráfico de acessos no Grafana.*

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250516_120327.png" alt="Import 08" style="float: left;">

3. Na aba do Netbox, ao acessar o menu ***IPAM > Services***, é possível verificar a existência de um serviço **HTTP** para o device **container-nginx**. Este serviço foi ativado tão logo o nginx do referido container ficou disponível após a inicialização do ambiente.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250512_154044.png" alt="Import 07" style="float: left;">

4. Numa nova aba do terminal na VM, digite:
```bash
iptables-server
```
5. Verifique a existência de uma regra de firewall permitindo acessos à porta do 80 TCP de qualquer origem. Esta regra foi implementada automaticamente, através da criação do serviço no SSoT descrito no item anterior.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250516_121416.png" alt="Import 08" style="float: left;">

6.  Neste momento, então, ao ser ligado o contêiner do servidor nginx, houve um deploy de regra de firewall permitindo acesso TCP de porta 80, tão logo o serviço do nginx ficou pronto e ouvindo. Com isto, o servidor web passou a ser acessado normalmente entre 1 e 9 vezes por segundos por um cliente. A implementação da regra liberando a porta 80 em TCP pode ser observada no menu ***IPAM > Services*** do SSoT. Os acessos ao servidor podem ser acompanhados em tempo real em forma de gráfico no Grafana.

### 2. Iniciar um ataque DoS e acompanhar sua mitigação automatizada

1. No terminal, em uma nova aba ou na aba onde se executou anteriormente o comando *iptables-server*, execute o comando:
```bash
iniciar-ataque
```
2. Ainda no terminal, na aba onde se executou o comando de preparação do ambiente, é possível observar a execução das interações da solução com o SSoT. O *debug* está habilitado propositalmente para proporcionar uma análise das chamadas de API e dos deploys de regras de bloqueio.

3. Na aba do Grafana do navegador, é possível verificar no gráfico que houve um aumento repentino no número de acessos ao servidor do nginx. Este aumento foi percebido pelo mecanismo de monitoramento (interno ao container), que disparou a chamada para a API do TrueState-SNA informando sobre o ataque DoS. O TrueState-SNA por sua vez criou um serviço no SSoT do tipo **DROP**, que foi então devolvido ao TrueState-SNA, iniciando um deploy de regra de firewall de bloqueio, específico para o IP do atacante. Entre a detecção do aumento do número de acessos e a efetiva mitigação do ataque, há uma janela de apenas 2-3 segundos.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250512_154356.png" alt="Import 09" style="float: left;">

4. No terminal, ao executar novamente o comando *iptables-server*, é possível verificar a implementação da regra de bloqueio com origem apenas para o endereço IP do atacante.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250512_154213.png" alt="Import 10" style="float: left;">

5.  Na aba do Netbox, ao acessar o menu ***IPAM > Services***, é possível verificar agora a existência de um serviço **DDoS** para o device **container-nginx**. Este serviço foi criado em tempo real, conforme descrito acima, e representa a sinergia das interações do mecanismo de monitoramento do container, do TrueState-SNA e do SSoT.

<img src="https://github.com/ljbitzki/ljbitzki.github.io/blob/master/Screenshot_20250512_154236.png" alt="Import 11" style="float: left;">

6. Caso o serviço **DDoS** no menu ***IPAM > Services*** seja deletado, há um processo imediato de remoção da regra de bloqueio, fazendo o deploy do playbook para remover efetivamente a regra implementada no iptables do servidor. O retorno dos acessos após a liberação do firewall pode ser acompanhada na aba do Grafana no navegador¹.

*¹Note que pode haver alguns segundos entre a remoção do serviço no SSoT e a volta do gráfico do Grafana, tendo em vista que pode haver timeouts pendentes do procedimento que é executado pelo comando* ***iniciar-ataque***.

7. No terminal, ao executar novamente o comando *iptables-server*, é possível verificar a remoção da regra de bloqueio que havia sido implementada para o endereço IP do atacante.

### 3. Outros comandos
1. Para reiniciar o ambiente:
```bash
reiniciar-ambiente
```
2. Para parar todos os elementos do ambiente:
```bash
parar-ambiente
```

## Opção 2: Requisitos

Antes de iniciar o experimento, certifique-se de que possui os seguintes requisitos de hardware e aplicações instaladas:

* Processador 64 bits com no mínimo 4 núcleos
* 4 GB de RAM livres, para uso exclusivo do laboratório
* Sistema Operacional baseado em Ubuntu versão 20.04 ou mais recente (Ubuntu, Kubuntu, Xubuntu e variáveis)
* Ter permissões de *root* através de *sudo*
* Pacotes *curl*, *rsync*, *wget* e *git* instalados
* Docker Engine instalado conforme https://docs.docker.com/engine/install/ubuntu/
* No intuito de evitar quaisquer conflitos entre contêiners existentes no computador, sugere-se parar todos os contêiners que possam estar rodando localmente, para isso, execute em um terminal:
```bash
while read CID; do docker stop "${CID}"; done < <( docker ps -a | grep -v 'CONTAINER ID' | awk '{print $1}' )
```


## Opção 2: Download e execução do Laboratório
No terminal, rodar:
```bash
wget "https://github.com/ljbitzki/ljbitzki.github.io/raw/refs/heads/master/experimento-sf-install.sh" -O "/tmp/experimento-sf-install.sh"
chmod +x "/tmp/experimento-sf-install.sh"
/tmp/experimento-sf-install.sh
```

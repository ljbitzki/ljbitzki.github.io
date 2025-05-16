
# TrueState-SNA - Experimento

## Sobre a aplicação e o ambiente do experimento

O **TrueState-SNA** é um projeto que visa automatizar a configuração e aplicações de regras de firewall em servidores e dispositivos de segurança, automaticamente a partir do SSoT, em dois cenários:

 1. Monitoramento da disponibilidade um serviço e liberação no firewall local para possibilitar seu acesso;
 2. Mitigação de ataque DoS em tempo real através de monitoramento de acessos e implantação de regras de firewall para o endereço de origem do atacante.

## Requisitos

Antes de iniciar a configuração, certifique-se de que possui os seguintes requisitos de hardware e aplicações instaladas:

* Processador 64 bits com no mínimo 4 núcleos e flag de virtualzação VT-x ativada na BIOS
* 4 GB de RAM livres, para uso exclusivo do laboratório
* VirtualBox 7.1 ou superior [link](https://www.virtualbox.org/wiki/Downloads)
* VirtualBox Extension Pack 7.1 [link](https://www.virtualbox.org/wiki/Downloads)

### Download do Laboratório

Baixe o laboratório do experimento que está disponível através de um Appliance do Virtualbox [aqui](https://drive.google.com/file/d/1MJuQxlu-7Nstxtwwlv9CiOo5vvHcApwm/view?usp=sharing).

### Importação do Laboratório

Importe o arquivo _experimento-sf.ova_ no Virtualbox.

<img src="https://github.com/user-attachments/assets/4400ef0c-6d89-46bf-bdae-8ba328c715f9" alt="Import 01" style="float: left; width: 50%; height: auto;">
<img src="https://github.com/user-attachments/assets/57dcb5e8-d64f-4e1f-9d6e-b827553b43ad" alt="Import 02" style="float: left; width: 50%; height: auto;">


> [!CAUTION]
> É necessário escolher a opção **Include all network adapter MAC address** em *MAC Address Policy*.


<img src="https://github.com/user-attachments/assets/9a439af3-153d-4ee8-9d97-eec5919e4cc2" alt="Import 01" style="float: left; width: 50%; height: auto;">


Clique em *Finish* e aguarde o processo de importação.

## O Ambiente do Laboratório

O laboratório é composto por 1 VM e depende de endereçamento IP interno para o funcionamento esperado:

* Xubuntu 24.04 (experimento-sf)
* Interface de rede **vboxnet0** (geralmente, esta rede está habilitada por padrão numa instalação típica do VirtualBox)

### Inicializando o ambiente

Selecionar a VM e clicar em *Start*, o Virtualbox poderá emitir um alerta sobre o consumo de recursos, dependendo da disponibilidade atual do host onde o experimento será executado. Clique OK caso ocorra.

> [!NOTE]
> A falta de recursos disponíveis pode ocasionar erros e a VM não inicializar.
> Se isso acontecer em um ambiente linux, tente liberar _cache_ de memória RAM com o comando
> `sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'`

1. A autenticação da VM *experimento-sf* tem com usuário e senha ***net2d/net2d***.

2. Abra um terminal na VM e inicialize o ambiente com o comando:
```bash
iniciar-ambiente
```
3. A preparação do ambiente poderá levar vários segundos, podendo levar mais de um minuto, dependendo dos recursos do host. Aguarde até uma mensagem informar o término da inicialização do ambiente.

4.  Após a inicialização do ambiente, abra o navegador na VM e acesse o Netbox e o Grafana através dos atalhos salvos na barra de favoritos do navegador.

## O Experimento

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

3. Na aba do Netbox, ao acessar o menu ***IPAM > Services***, é possível verificar a existência de um serviço **HTTP** para o device **container-nginx**. Este serviço foi ativado tão logo o nginx do referido container ficou disponível após a inicialização do ambiente.

4. Numa nova aba do terminal na VM, digite **iptables-servidor** e verifique a existência de uma regra de firewall permitindo acessos à porta do 80 TCP de qualquer origem. Esta regra foi implementada automaticamente, através da criação do serviço no SSoT descrito no item anterior.

5.  Neste momento, então, ao ser ligado o contêiner do servidor nginx, houve um deploy de regra de firewall permitindo acesso TCP de porta 80, tão logo o serviço do nginx ficou pronto e ouvindo. Com isto, o servidor web passou a ser acessado normalmente entre 1 e 9 vezes por segundos por um cliente. A implementação da regra liberando a porta 80 em TCP pode ser observada no menu ***IPAM > Services*** do SSoT. Os acessos ao servidor podem ser acompanhados em tempo real em forma de gráfico no Grafana.

### 2. Iniciar um ataque DoS e acompanhar sua mitigação automatizada

1. No terminal, em uma nova aba ou na aba onde se executou anteriormente o comando *iptables-servidor*, execute o comando **iniciar-ataque**.

2. Ainda no terminal, na aba onde se executou o comando de preparação do ambiente, é possível observar a execução das interações da solução com o SSoT. O *debug* está habilitado propositalmente para proporcionar uma análise das chamadas de API e dos deploys de regras de bloqueio.

3. Na aba do Grafana do navegador, é possível verificar no gráfico que houve um aumento repentino no número de acessos ao servidor do nginx. Este aumento foi percebido pelo mecanismo de monitoramento (interno ao container), que disparou a chamada para a API do TrueState-SNA informando sobre o ataque DoS. O TrueState-SNA por sua vez criou um serviço no SSoT do tipo **DROP**, que foi então devolvido ao TrueState-SNA, iniciando um deploy de regra de firewall de bloqueio, específico para o IP do atacante. Entre a detecção do aumento do número de acessos e a efetiva mitigação do ataque, há uma janela de apenas 2-3 segundos.

4. No terminal, ao executar novamente o comando *iptables-servidor*, é possível verificar a implementação da regra de bloqueio com origem apenas para o endereço IP do atacante.

5.  Na aba do Netbox, ao acessar o menu ***IPAM > Services***, é possível verificar agora a existência de um serviço **DDoS** para o device **container-nginx**. Este serviço foi criado em tempo real, conforme descrito acima, e representa a sinergia das interações do mecanismo de monitoramento do container, do TrueState-SNA e do SSoT.

6. Caso o serviço **DDoS** no menu ***IPAM > Services*** seja deletado, há um processo imediato de remoção da regra de bloqueio, fazendo o deploy do playbook para remover efetivamente a regra implementada no iptables do servidor. O retorno dos acessos após a liberação do firewall pode ser acompanhada na aba do Grafana no navegador¹.

*¹Note que pode haver alguns segundos entre a remoção do serviço no SSoT e a volta do gráfico do Grafana, tendo em vista que pode haver timeouts pendentes do procedimento que é executado pelo comando* ***iniciar-ataque***.

7. No terminal, ao executar novamente o comando *iptables-servidor*, é possível verificar a remoção da regra de bloqueio que havia sido implementada para o endereço IP do atacante.


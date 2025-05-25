# TrueState-SNA: Orquestração Segura e Declarativa de Firewalls Baseada em Fonte Única de Verdade
[![Licença](https://img.shields.io/badge/License-GNU%20GPL-blue)](https://opensource.org/licenses/GNU)
### Objetivo do Artefato:
Este artefato tem como objetivo exemplificar o funcionamento prático de um cenário real de aplicação do **TrueState-SNA**, em que dois cenários são simulados e a execução das funcionalidades são demonstradas.

**No primeiro cenário**, quando um servidor web é iniciado e fica pronto para aceitar requisições, um mecanismo interno no servidor aciona a API do **TrueState-SNA**, que processa a informação e cria um serviço do tipo ACCEPT na SSoT, que por sua vez aciona de volta a API e desencadeia a criação de uma regra de **iptables** para liberação de porta 80 no servidor, permitindo que ele seja acessado.

**No segundo cenário**, o servidor web possui um monitor de acessos por segundo e, ao detectar uma anomalia no número de requisições, um mecanismo interno no servidor aciona a API do **TrueState-SNA**, que processa a informação e cria um serviço do tipo DROP na SSoT com _source_ sendo o endereço IP do atacante, que por sua vez aciona de volta a API e desencadeia a criação de uma regra de **iptables** para o imediato bloqueio do IP do atacante, interrompendo o ataque.

### Resumo do Artigo:
_A crescente complexidade dos ambientes de rede e a diversidade de dispositivos de seguran¸ca tornam o gerenciamento consistente de políticas de firewall uma tarefa desafiadora. Este trabalho apresenta a ferramenta TrueState-SNA, que propõe uma abordagem centralizada, segura e auditável para a gestão de firewalls baseada em uma Fonte Unica de Verdade (SSoT). A solução suporta múltiplos vendors, integra pipelines de automação e permite a adaptação automática de políticas com base em eventos
e estados de rede. O artigo descreve a arquitetura da ferramenta, seus diferenciais técnicos e apresenta uma comparação com soluções relacionadas._

---

# Estrutura do README.md

Este README.md está organizado nas seguintes seções:

1.  **Título, Objetivo e Resumo:** Título do projeto, objetivo do artefato e resumo do artigo.
2.  **Estrutura do README.md:** A presente estrutura.
3.  **Selos considerados:** Lista dos Selos a serem considerados no processo de avaliação.
4.  **Informações básicas:** Descrição dos componentes e requisitos mínimos para a execução do experimento.
5.  **Dependências:** Informação sobre as dependências necessárias.
6.  **Preocupações com segurança:** Lista das considerações e preocupações com a segurança.
7.  **Instalação:** Relação opções para a realização do experimento, bem como as instruções individuais de cada opção.
8.  **Teste mínimo:** Instruções para a execução das simulações.
9.  **Experimentos:** Informações de replicação das reivindicações.
10.  **Licença:** Informações sobre a licença do projeto.

---

# Selos considerados

Os selos considerados são:
- Artefatos Disponíveis (SeloD)
- Artefatos Funcionais (SeloF)
- Artefatos Sustentáveis (SeloS)
- Experimentos Reprodutíveis (SeloR)

---

# Informações básicas

### O experimento possui três opções disponíveis para execução, sendo:

 1. **Opção 1:** Imagem de **VirtualBox** com ambiente auto-contido já preparado para o experimento (testado em Sistema Operacional Microsoft Windows 10 ou superior e distribuições Linux baseada em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variantes);
 2. **Opção 2:** Download  de todos os contêineres envolvidos e execução destes, localmente em um desktop ou laptop (testado em SO baseada em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variantes); ou
 3. **Opção 3:** Acesso, através de Remote Desktop utilizando VPN Wireguard, a uma máquina virtual rodando o ambiente auto-contido já preparado para o experimento. Esta opção é **idêntica** à Opção 1, porém, encontra-se disponível, em execução, em servidor remoto, sendo disponibilizada apenas no intuito de facilitar a reprodução do experimento com o mínimo de setup necessário por parte da comiisão avaliadora.

#### Requisitos de software e hardware para cada Opção de execução são:

 1. **Opção 1:** Nesta opção, deve ser feito o download e importação de um Appliance Virtual (arquivo .ova) e execução do ambiente virtualizado utilizando VirtualBox. Para tanto, são necessários: Sistema Operacional Microsoft Windows 10 ou superior e distribuições Linux baseada em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variantes), processador 64 bits com no mínimo 4 núcleos e flag de virtualzação VT-x ativada na BIOS, 4GB de memória RAM para uso exclusivo no experimento, VirtualBox 7.1 ou superior com Extension Pack correspondente à versão do VirtualBox.
 2. **Opção 2:** Nesta opção, todo experimento será executado em ambiente local através do download e execução automatizada de todos os componentes utilizando Docker. Para isto, são necessários: Sistema Operacional Linux baseado em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variantes), processador 64 bits com no mínimo 4 núcleos, 4GB de memória RAM para uso exclusivo no experimento, Docker Engine versão 26 ou superior e alguns pacotes disponíveis no repositório oficial (ver dependências); ou
 3. **Opção 3:** Nesta opção, o ambiente do experimento estará em execução em servidor remoto, em que apenas será necessário o acesso ao desktop virtual deste servidor para sua a execução. Esta opção requer: Sistema Operacional Microsoft Windows 10 ou superior e distribuições Linux baseada em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variantes, aplicação de remote desktop e cliente de VPN Wireguard.

---

# Dependências

### O experimento possui três opções disponíveis para execução, tendo cada um deles as seguintes dependências:

 1. **Opção 1:** Cumpridos os requisitos descritos na seção anterior, referentes a **Opção 1**, esta opção não possui dependências.
 2. **Opção 2:** Cumpridos os requisitos descritos na seção anterior, referentes a **Opção 2**, é necessário certificar-se que o Docker Engine versão 26 ou superior esteja instalado conforme descrito na [página oficial da ferramenta] (https://docs.docker.com/engine/install/ubuntu/), bem como a seção [postinstall](https://docs.docker.com/engine/install/linux-postinstall/), além dos pacotes __curl__, __rsync__, __wget__ e __git__ instalados.
 3. **Opção 3:** Em Sistema Operacional Linux baseado em Ubuntu versão 20.04 ou mais recente: Ubuntu, Kubuntu, Xubuntu e variantes, é necessário a instalação de aplicação com capacidade de execução RDP (sugere-se xrdp, vinagre ou remmina). Em Sistema Operacional Microsoft Windows 10 ou superior a aplicação RDP é nativa. Em ambos sistemas operacionais, é requisito a instalação de [cliente de VPN Wireguard](https://www.wireguard.com/install/)

---

# Preocupações com segurança

### O experimento possui três opções disponíveis para execução, tendo cada um deles as seguintes preocupações com segurança:

 1. **Opção 1:** Por tratar-se de execução de Appliance pronta e virtualizada em ambiente auto contido, não há considerações quanto a preocupações de segurança nesta opção.
 2. **Opção 2:** Durante a execução do conjunto de contêineres envolvidos, dependendo das configurações do dispositivo que estiver hospedando o experimento, as portas **3000**, **8000** e **8080** poderão estar abertas para a rede local, dependendo das configurações de firewall, encaminhamento de portas e perfil de segurança das interfaces de rede. 
 3. **Opção 3:** Por tratar-se de ambiente auto contido e sendo executado em servidor remoto, as implicações de segurança são inerente ao vazamento das credenciais da VPN e do acesso ao servidor. As ações de contenção do ambiente para a proteção do sistema operacional remoto foram tratadas em nível de redução de privilégios, restrição do uso da rede para acesso somente à rede local exclusiva do host e mecanismo de auto destruição e recuperação para o estado anterior, caso necessário.

#### Preocupações com segurança adicionais

Cabe ressaltar que todas as senhas, chaves de API e outros elementos secretos dos componentes foram gerados para o propósito da demonstração do experimento, de tal forma que sua força de segurança foram propositalmente baixadas para facilitar o experimento. As senhas, chaves de API e chaves RSA do SSH utilizada são descartáveis e servem apenas ao propósito do experimento.

---

# Instalação

O processo de baixar e instalar a aplicação deve ser descrito nesta seção. Ao final deste processo já é esperado que a aplicação/benchmark/ferramenta consiga ser executada.

---

# Teste mínimo

Esta seção deve apresentar um passo a passo para a execução de um teste mínimo.
Um teste mínimo de execução permite que os revisores consigam observar algumas funcionalidades do artefato. 
Este teste é útil para a identificação de problemas durante o processo de instalação.

---

# Experimentos

Esta seção deve descrever um passo a passo para a execução e obtenção dos resultados do artigo. Permitindo que os revisores consigam alcançar as reivindicações apresentadas no artigo. 
Cada reivindicações deve ser apresentada em uma subseção, com detalhes de arquivos de configurações a serem alterados, comandos a serem executados, flags a serem utilizadas, tempo esperado de execução, expectativa de recursos a serem utilizados como 1GB RAM/Disk e resultado esperado. 

Caso o processo para a reprodução de todos os experimento não seja possível em tempo viável. Os autores devem escolher as principais reivindicações apresentadas no artigo e apresentar o respectivo processo para reprodução.

---

## Reivindicações: Cenário 1 - Liberação automatizada de porta quando serviço estiver pronto

## Reivindicações: Cenário 2 - Mitigação automatizada de ataque DoS

---

# LICENCE

Este projeto está licenciado sob a Licença GNU - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

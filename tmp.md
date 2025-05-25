# TrueState-SNA: Orquestração Segura e Declarativa de Firewalls Baseada em Fonte Única de Verdade

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
4.  **Informações básicas:**
5.  **Dependências:**
6.  **Preocupações com segurança:** Lista das preocupações com a segurança.
7.  **Instalação:** Instruções passo a passo para instalar a ferramenta.
8.  **Teste mínimo:** Instruções para construir e executar a ferramenta usando Docker.
9.  **Experimentos:** Instruções para configurar as chaves de API.
10.  **Licença:** Informações sobre a licença do projeto.

---

# Selos considerados

Os autores devem descrever quais selos devem ser considerados no processo de avaliação. Como por exemplo: ``Os selos considerados são: Disponíveis e Funcionais.''

---

# Informações básicas

Esta seção deve apresentar informações básicas de todos os componentes necessários para a execução e replicação dos experimentos. 
Descrevendo todo o ambiente de execução, com requisitos de hardware e software.

---

# Dependências

Informações relacionadas a benchmarks utilizados e dependências para a execução devem ser descritas nesta seção. 
Busque deixar o mais claro possível, apresentando informações como versões de dependências e processos para acessar recursos de terceiros caso necessário.

---

# Preocupações com segurança

Caso a execução do artefato ofereça algum tipo de risco para os avaliadores. Este risco deve ser descrito e o processo adequado para garantir a segurança dos revisores deve ser apresentado.

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

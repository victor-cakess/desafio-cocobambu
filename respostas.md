# Perguntas

## Desafio 1, pergunta 1

### Descrição do esquema JSON

O JSON fornecido apresenta as seguintes características:

1. **Estrutura geral**:
   - O JSON é hierárquico e contém objetos aninhados e arrays.
   - É composto por dois elementos principais no nível superior:
     - `curUTC`: Representa a data e hora no formato UTC.
     - `locRef`: Identifica o local associado às transações.
     - `guestChecks`: Um array que contém os dados detalhados dos pedidos realizados.

2. **Características dos arrays**:
   - `guestChecks`:
     - É um array de objetos, cada um representando um pedido.
     - Contém atributos como `guestCheckId`, `chkNum`, `clsdFlag` e totais relacionados ao pedido (`subTtl`, `chkTtl`, etc.).
     - Inclui subestruturas importantes:
       - `taxes`: um array de objetos, representando os impostos aplicados ao pedido.
       - `detailLines`: um array de objetos, contendo itens detalhados do pedido.

3. **Objetos aninhados**:
   - Dentro de cada `detailLine`, existe um objeto `menuItem`.

4. **Tipos de dados**:
   - Strings: `locRef`, `curUTC`.
   - Números: `guestCheckId`, `chkNum`, `subTtl`.
   - Booleanos: `clsdFlag`, `modFlag`.
   - Datas: `opnBusDt`, `detailUTC`.

### Relações no esquema

- `guestChecks` é a entidade principal, representando os pedidos.
- `taxes` e `detailLines` são entidades associadas diretamente a cada pedido, detalhando os impostos e os itens consumidos.
- `menuItem` está aninhado dentro de cada `detailLine`, detalhando os atributos específicos de cada item.

---

## Desafio 1, pergunta 3

### Justificativa da abordagem

#### 1. Estruturação do problema

A tarefa exigiu transformar um arquivo JSON, contendo informações de pedidos de um restaurante, em um modelo relacional eficiente. A motivação central para essa transformação baseia-se nos princípios de escalabilidade e engenharia de dados descritos nos dois livros de referência:

- *Foundations of Scalable Systems*, Ian Gorton:
  - Sistemas escaláveis devem ser projetados para crescer continuamente sem comprometer desempenho ou consistência.

- *Fundamentals of Data Engineering*, Joe Reis e Matt Housley:
  - Importância de modelar dados de maneira que sejam úteis para consumidores finais e facilmente manipuláveis para análise e relatórios.

Esses conceitos orientaram a criação de um banco de dados relacional que atende aos requisitos de eficiência, escalabilidade e usabilidade.

#### 2. Entendimento do JSON

O JSON analisado possui uma estrutura hierárquica, com os seguintes componentes principais:

- **Raiz**: inclui informações do local e timestamp.
- **`guestChecks`**: representa os pedidos realizados, contendo subtotais, totais, itens e impostos.
- **`detailLines`**: descreve os itens consumidos em cada pedido.
- **`taxes`**: detalha os impostos aplicados ao pedido.

De acordo com *Fundamentals of Data Engineering*, a normalização dessas estruturas é importante para criar um pipeline de dados eficiente e reduzir redundâncias, garantindo consistência ao longo do ciclo de vida dos dados.

#### 3. Transformação para o modelo relacional

Com base nas características do JSON e nos princípios descritos em *Foundations of Scalable Systems*, foi desenvolvido um modelo relacional composto por quatro tabelas principais:

1. **guestChecks (Pedidos)**: centraliza informações gerais do pedido.
2. **detailLines (Itens)**: descreve os itens específicos consumidos.
3. **menuItem (Cardápio)**: detalha características adicionais de cada item.
4. **taxes (Impostos)**: registra os impostos associados ao pedido.

##### 3.1. Justificativa para o modelo relacional

- Sistemas escaláveis devem priorizar a modularidade para facilitar a manutenção e evolução futura (*Foundations of Scalable Systems*).
- Divisão dos dados do JSON em tabelas específicas minimiza redundâncias e promove eficiência nas consultas.

#### 4. Abordagem técnica

##### 4.1. Processo de extração e carga

O JSON foi carregado para o banco de dados usando uma abordagem estruturada:

1. **Mapeamento de dados**: as chaves do JSON foram mapeadas diretamente para colunas das tabelas relacionais.
2. **Inserções incrementais**: dados foram inseridos garantindo consistência referencial entre as tabelas.

##### 4.2. Normalização dos dados

- Modelo normalizado para eliminar redundâncias e garantir integridade.
- Normalização é uma prática fundamental para otimizar o desempenho de consultas e reduzir o custo de armazenamento (*Fundamentals of Data Engineering*).

#### 5. Planejamento para escalabilidade

- **Separação de preocupações**: cada aspecto do pedido foi isolado em tabelas separadas.
- **Escalabilidade horizontal**: design suporta replicação de tabelas e distribuição de dados.

#### 6. Impacto prático

- **Consultas otimizadas**: redução no tempo de execução para relatórios e análises.
- **Manutenção simplificada**: alterações futuras no JSON podem ser incorporadas sem reestruturar todo o banco.
- **Escalabilidade**: sistema preparado para lidar com aumento de volume sem comprometer o desempenho.

#### 7. Justificativa para a criação de tabelas adicionais

A decisão de criar tabelas separadas para objetos como `discount`, `serviceCharge`, `tenderMedia` e `errorCode` foi baseada nos seguintes princípios:

- **Facilidade de manutenção**: alterações futuras podem ser feitas sem impactar a tabela principal.
- **Escalabilidade**: separação dos dados garante performance mesmo com aumento de volume.
- **Integridade referencial**: uso de chaves estrangeiras mantém a integridade lógica dos dados.
- **Flexibilidade e extensibilidade**: permite maior liberdade para adições de novos campos.
- **Eficiência nas consultas**: operações em tabelas especializadas são mais rápidas.

#### 8. Comparação com a alternativa

A alternativa de adicionar `discount`, `serviceCharge`, `tenderMedia` e `errorCode` como colunas na tabela `detailLines` apresenta as seguintes desvantagens:

1. Tabela densa e ineficiente devido a colunas opcionais.
2. Risco de inconsistências com repetição de informações comuns.
3. Limitações em análises futuras.

---

## Desafio 2, pergunta 1

### Justificativa para armazenagem das respostas das APIs no Data Lake

1. **Preservação de histórico**
   - Armazenar dados das APIs garante histórico completo para auditorias, investigações e comparações sazonais.

2. **Centralização e integração**
   - Reduz a complexidade de integração e melhora análises unificadas e redução de latência.

3. **Escalabilidade**
   - Suporta grandes volumes de dados e integra-se a ferramentas analíticas.

4. **Reutilização e transformação**
   - Permite otimização de pipelines ETL e redução de custos.

5. **Preparação para Machine Learning**
   - Facilita armazenamento de dados brutos e criação de pipelines para modelos preditivos.

6. **Desafios e mitigações**
   - Monitorar custos, implementar validações e garantir segurança no bucket do Data Lake.

---

## Desafio 2, pergunta 2

### Estrutura sugerida para o Data Lake

- `restaurante-datalake/`
  - **raw/**: Dados brutos extraídos diretamente das APIs.
    - **guest-checks/**: Dados referentes aos pedidos dos clientes.
    - **fiscal-invoice/**: Dados fiscais.
    - **transactions/**: Dados de transações financeiras.
    - **chargeback/**: Dados de estornos.
    - **cash-management/**: Dados de gerenciamento de caixa.
  - **processed/**: Dados processados e transformados.
    - **daily-revenue/**: Dados consolidados de receitas diárias.
    - **errors/**: Logs de erros processados.
  - **consolidated/**: Dados consolidados prontos para análise.
  - **logs/**: Logs de execução.
    - **api-requests/**: Logs de requisições das APIs.
    - **etl/**: Logs de execução do pipeline ETL.

### Justificativa

1. **Divisão lógica**: cada subdiretório dentro de raw/ corresponde a um endpoint ou tipo de
dado fornecido pelas APIs. Isso facilita localizar e manipular os dados brutos
individualmente.
2. **Facilidade de manipulação**: a separação em pastas permite processar cada conjunto de
dados (como guest-checks ou fiscal-invoice) de forma independente, mantendo a
flexibilidade para atualizações ou alterações específicas.
3. **Verificação e logs**: a separação em pastas permite processar cada conjunto de
dados (como guest-checks ou fiscal-invoice) de forma independente, mantendo a
flexibilidade para atualizações ou alterações específicas.
4. **Processamento gradual**: o diretório processed/ armazena dados intermediários,
permitindo validações após cada etapa do pipeline (ex.: verificar receitas diárias antes
da consolidação).
5. **Consolidação**: o diretório consolidated/ armazena dados refinados, prontos para
análises ou consumo por outros sistemas. Isso pode incluir tabelas SQL ou arquivos
organizados para dashboards.
6. **Escalabilidade e organização**: a estrutura suporta crescimento, seja por inclusão de
novos endpoints ou por aumento no volume de dados, sem comprometer a
organização.

---

## Desafio 2, pergunta 3

### Impacto de renomear `guestChecks.taxes` para `guestChecks.taxation`

1. **Falhas no pipeline existente**
   - Scripts Python, tabelas SQL e dashboards que dependem do campo antigo falharão.

2. **Atualização necessária no código**
   - Substituir referências ao campo antigo nos scripts de ETL e mapeamento SQL.

3. **Necessidade de retestar o pipeline**
   - Garantir que o novo campo é lido, armazenado e utilizado corretamente em relatórios.



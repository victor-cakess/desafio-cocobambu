# Projeto de Engenharia de Dados - Restaurante Coco Bambu

Este projeto consiste na criação de um Data Lake para armazenar dados brutos de APIs, sua transformação para um banco de dados relacional no MySQL e a análise de dados estruturados. Todas as etapas, desde a configuração do Google Cloud Storage até a inserção de dados no MySQL via Python, são explicadas abaixo.

---

## Estrutura do Projeto

### Estrutura do Data Lake no Google Cloud Storage

O Data Lake foi configurado com a seguinte estrutura de pastas:

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

## Como Executar

### Passo 1: Acessar o Data Lake no Google Cloud Storage
1. O Data Lake está hospedado no Google Cloud Storage. Você pode acessá-lo através do seguinte link:
   [Restaurante Data Lake](https://console.cloud.google.com/storage/browser/restaurante-datalake;tab=objects?forceOnBucketsSortingFiltering=true&hl=pt-BR&inv=1&invt=AbinJw&project=cohesive-gadget-442920-k2&prefix=&forceOnObjectsSortingFiltering=false).
2. Verifique que o arquivo `ERP.json` está localizado no caminho `raw/guest-checks/`.

### Passo 2: Configuração do Banco de Dados MySQL
1. Crie o banco de dados e as tabelas no MySQL utilizando o script SQL disponível no arquivo `desafio_cocobambu.sql`.
2. O script cria o databse e as tabelas relacionadas aos dados extraídos, como `guestChecks`, `taxes`, `detailLines`, entre outras.

### Passo 3: População com Python

1. No arquivo Jupyter Notebook `desafio_coco_bambu.ipynb`, configure a conexão com o MySQL utilizando as credenciais apropriadas.
2. O script Python faz a leitura do arquivo `ERP.json` diretamente do Data Lake e realiza a transformação dos dados.
3. Após transformar os dados, o script insere as informações nas tabelas do MySQL utilizando conexões via `pymysql`.

---

## Fluxo Operacional

1. **Extração**: os dados são extraídos das APIs e armazenados no Data Lake na pasta `raw/`.
2. **Transformação**: no notebook Python, os dados são transformados e adequados ao modelo relacional.
3. **Carga**: os dados transformados são inseridos no MySQL utilizando comandos SQL.

---

## Referências dos Arquivos

- **Data Lake**: estrutura disponível no Google Cloud Storage no caminho mencionado acima.
- **Script SQL**: `desafio_cocobambu.sql` - cria todas as tabelas no banco de dados.
- **Notebook Python**: `desafio_coco_bambu.ipynb` - realiza a transformação e carga dos dados.
- **Arquivo JSON**: localizado em `raw/guest-checks/ERP.json` no Data Lake.

## Decisões Arquiteturais e Justificativa

### 1. Estrutura do Data Lake
O **data lake** foi estruturado com base nos princípios de organização modular para permitir:
- **Escalabilidade:** a separação entre `raw`, `processed`, `consolidated` e `logs` facilita o crescimento do volume de dados sem impactar a performance. Cada etapa do pipeline ETL tem uma pasta dedicada, permitindo que diferentes times acessem partes específicas do processo sem sobrecarga.
- **Integridade dos Dados:** os dados brutos são armazenados no diretório `raw` sem qualquer transformação, garantindo que informações originais estejam sempre disponíveis para auditorias ou retrabalhos.
- **Eficiência em Consultas:** dados consolidados (`consolidated`) são otimizados para análises frequentes, reduzindo o custo e o tempo de processamento.

### 2. Escolha de MySQL como Data Warehouse
Optou-se pelo **MySQL** para o armazenamento relacional devido:
- **Compatibilidade e Simplicidade:** MySQL é amplamente utilizado e facilmente integrado ao Python para automação de cargas e consultas.
- **Estrutura Relacional:** a modelagem das tabelas reflete as dependências e chaves primárias/estrangeiras presentes no JSON, permitindo consultas SQL otimizadas para análise de relacionamento entre diferentes entidades.
- **Manutenibilidade:** caso ocorra alteração no schema, apenas atualizações pontuais no modelo serão necessárias, como no exemplo de `guestChecks.taxes` renomeado para `guestChecks.taxation`.

### 3. Uso do Python no Pipeline ETL
A escolha do **Python** como linguagem para o pipeline foi feita com base em:
- **Flexibilidade:** bibliotecas como `json` permitem leitura, transformação e validação dos dados de forma rápida e eficaz.
- **Automação e Escalabilidade:** scripts automatizados podem ser escalados com a integração de bibliotecas como `Airflow` ou ferramentas nativas do GCP para orquestração no futuro.
- **Integridade de Dados:** validações foram realizadas para garantir que os dados seguem o formato esperado no MySQL.

### 4. Escalabilidade e Preparação para Crescimento
O pipeline e o data lake foram configurados para suportar aumento no volume de dados por meio de:
- **Design Modular:** diretórios separados por etapas (`raw`, `processed`, `consolidated`) e por entidade (`guest-checks`, `transactions`, etc.).
- **Uso de GCP:** a escolha do Google Cloud Platform possibilita que o armazenamento e o processamento cresçam automaticamente com a demanda.

### 5. Logs e Monitoramento
A criação de logs em `logs/api-requests` e `logs/etl` foi projetada para:
- **Rastreabilidade:** registrar todas as interações com APIs e etapas do pipeline.
- **Detecção de Erros:** logs de erros armazenados em `logs/errors` permitem depuração rápida e eficiente.

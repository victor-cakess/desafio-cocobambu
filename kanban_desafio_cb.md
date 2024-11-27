## **Kanban Board - Projeto JSON para SQL**

### **Backlog** (Tarefas pendentes de priorização)
- [x] Analisar o JSON para entender todas as entidades e seus relacionamentos.
- [x] Estudar boas práticas de modelagem de dados relacionais.
- [x] Verificar o suporte para tipos de dados grandes no MySQL (`BIGINT`, `JSON`).
- [x] Planejar testes para validar a inserção e consultas.

---

### **To Do** (Tarefas prontas para começar)

#### **1. Criação do Data Lake**
- [x] Estruturar pastas no Google Cloud Storage:
  - [x] Criar a camada `raw` para dados brutos das APIs.
  - [x] Criar a camada `processed` para dados transformados.
  - [x] Criar a camada `consolidated` para dados finais consolidados.
- [x] Configurar o acesso público ao bucket para facilitar testes com o JSON.

#### **2. Modelagem do Banco de Dados**
- [x] Criar a tabela `guestChecks`:
  - [x] Definir os campos principais (`guestCheckId`, `chkNum`, etc.).
  - [x] Configurar a chave primária.
- [x] Criar a tabela `detailLines`:
  - [x] Adicionar chave estrangeira para `guestChecks`.
  - [x] Definir campos como `guestCheckLineItemId` e `dspTtl`.
- [x] Criar tabelas adicionais:
  - [x] `menuItem` com relação a `detailLines`.
  - [x] `taxes` com relação a `guestChecks`.
  - [x] `discount` com relação a `detailLines`.
  - [x] `serviceCharge` com relação a `detailLines`.

#### **3. Inserção de dados**
- [x] Criar script Python para processar o JSON:
  - [x] Ler os dados diretamente do Data Lake (`raw/guest-check/ERP.json`).
  - [x] Inserir registros em `guestChecks`.
  - [x] Inserir registros em `detailLines`.
  - [x] Inserir registros em tabelas relacionadas (`menuItem`, `taxes`, etc.).
- [x] Validar o script com um subconjunto do JSON.

#### **4. Consultas SQL**
- [x] Planejar JOINs básicos para validar relacionamentos.
- [x] Criar consultas para somar totais e comparar com os valores do JSON.

---

### **In Progress** (Tarefas em andamento)
- [x] Configurando Data Lake no Google Cloud Storage.
- [x] Testando acesso público ao JSON no bucket.
- [x] Criando tabelas SQL:
  - [x] `guestChecks`
  - [x] `detailLines`
- [x] Desenvolvendo script Python:
  - [x] Testando leitura do JSON diretamente do bucket.
  - [x] Inserindo registros na tabela `guestChecks`.
- [x] Validando consultas:
  - [x] JOIN entre `guestChecks` e `detailLines`.

---

### **Done** (Tarefas concluídas)
- [x] Planejamento inicial do projeto.
- [x] Estruturação do JSON para identificação de entidades e atributos.
- [x] Definição das tabelas e relacionamentos principais.
- [x] Teste inicial do script Python com registros pequenos.
- [x] Validação dos JOINs entre `guestChecks` e `detailLines`.
- [x] Configuração completa do Data Lake no GCP, seguindo a estrutura:
  - `raw/`: dados brutos das APIs.
  - `processed/`: dados transformados.
  - `consolidated/`: dados consolidados.
- [x] Utilização do Data Lake como fonte para povoar o banco de dados MySQL.

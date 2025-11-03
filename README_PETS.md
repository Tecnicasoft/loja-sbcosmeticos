# Sistema de Gerenciamento de Pets

## 📁 Estrutura Criada

```
lib/src/pets/
├── models/
│   ├── model_pet.dart           # Modelo do Pet (atualizado)
│   ├── model_especie.dart       # Modelo de Espécie
│   ├── model_raca.dart          # Modelo de Raça
│   ├── model_cor.dart           # Modelo de Cor
│   └── model_porte.dart         # Modelo de Porte
├── controller/
│   └── controller_pets.dart     # Controller principal com todas as APIs
├── view/
│   ├── page_pets.dart           # Tela principal - lista pets
│   └── page_adicionar_pet.dart  # Tela para adicionar/editar pets
└── exemplo_uso_pets.dart        # Exemplos de como usar
```

## 🚀 Funcionalidades Implementadas

### ✅ Tela Principal (PagePets)
- Lista todos os pets ou pets de um cliente específico
- Botões para **Editar** e **Excluir** cada pet
- Botão **Adicionar** novo pet (FloatingActionButton + AppBar)
- Campo de pesquisa (quando não filtrado por cliente)
- Confirmação antes de excluir
- Formatação de data de nascimento (DD/MM/AAAA)
- Loading states e tratamento de erros

### ✅ Tela de Adicionar/Editar Pet (PageAdicionarPet)
- Formulário completo com validação
- **Campos obrigatórios**:
  - Nome do pet
  - Data de nascimento (seletor de data)
  - Sexo (dropdown: Macho/Fêmea)
  - Espécie (dropdown carregado da API)
  - Raça (dropdown filtrado pela espécie selecionada)
  - Cor (dropdown carregado da API)
  - Porte (dropdown carregado da API)
- Modo **Adicionar** e **Editar** no mesmo componente
- Loading states individuais para cada combo
- Tratamento de erros e validações

### ✅ Controller (PetsController)
- **Gerenciamento de Pets**:
  - `getPetsByCliente(idCliente)` - Buscar pets por cliente
  - `getPets(filter)` - Buscar todos com filtro
  - `salvarPet(pet)` - Salvar novo pet
  - `atualizarPet(pet)` - Atualizar pet existente
  - `excluirPet(idPet)` - Excluir pet
- **Carregamento de Combos**:
  - `getEspecies()` - Buscar espécies
  - `getRacasByEspecie(idEspecie)` - Buscar raças por espécie
  - `getRacas()` - Buscar todas as raças
  - `getCores()` - Buscar cores
  - `getPortes()` - Buscar portes
- Tratamento de token de autenticação
- Parse automático das respostas JSON

### ✅ Modelos de Dados
- **Pet**: modelo principal com todos os campos
- **Especie, Raca, Cor, Porte**: modelos para os combos
- Métodos `fromJson()` e `toJson()` 
- Método `copyWith()` no modelo Pet

## 📋 Como Usar

### 1. Para Lista Geral de Pets:
```dart
Get.to(() => const PagePets());
```

### 2. Para Pets de um Cliente:
```dart
Get.to(() => PagePets(idCliente: 123));
```

### 3. Para Adicionar Pet:
```dart
Get.to(() => const PageAdicionarPet());
// ou com cliente específico:
Get.to(() => PageAdicionarPet(idCliente: 123));
```

## 🌐 Endpoints da API Necessários

```
GET    /especies/buscar                  # Buscar espécies
GET    /racas/buscar                     # Buscar todas as raças  
POST   /racas/buscarPorEspecie          # Buscar raças por espécie
GET    /cores/buscar                     # Buscar cores
GET    /portes/buscar                    # Buscar portes
POST   /pets/buscar                      # Buscar pets com filtro
POST   /pets/buscarPorCliente           # Buscar pets por cliente
POST   /pets/salvar                      # Salvar novo pet
PUT    /pets/atualizar/:id              # Atualizar pet
DELETE /pets/excluir/:id                # Excluir pet
```

## 📦 Dependências Utilizadas
- `get` - Gerenciamento de estado e navegação
- `http` - Requisições HTTP
- `shared_preferences` - Armazenamento do token
- `flutter/material.dart` - Componentes UI

## 🎨 Características da UI
- Seguindo padrão visual do projeto (CustomColors)
- Design responsivo e intuitivo
- Loading states e feedback visual
- Validações em tempo real
- Confirmações para ações destrutivas
- Seletor de data nativo
- Dropdowns com loading individual

## ⚙️ Próximos Passos
1. Adicionar as rotas no sistema de rotas
2. Implementar os endpoints na API
3. Testar integração completa
4. Adicionar imagens dos pets (opcional)
5. Implementar filtros avançados (opcional)
# Nome: João Pedro Cerchiari
## RA: 202410096
### Ciência da Computação: 6º Semestre

## Executar

Na pasta deste projeto:

```bash
flutter pub get
flutter run -d chrome --web-port=8080
```

## Prévia, salvar e remover

- **Alterar a prévia:** o interruptor e o slider mudam as variáveis em memória
  com `setState`. A tela muda na hora, mas nada é gravado.
- **Salvar preferências:** grava o tema com `setBool('leitura.temaEscuro', ...)`
  e a fonte com `setDouble('leitura.tamanhoFonte', ...)`. Ao abrir o aplicativo,
  `getBool()` e `getDouble()` recuperam essas escolhas no `initState`.
- **Restaurar padrão:** usa `remove()` somente nessas duas chaves e atualiza a
  tela para claro e 18. Outras preferências permanecem. Ao abrir novamente,
  os valores ausentes usam `?? false` e `?? 18`.

## Demonstração

Para reabrir no navegador, recarregue a página. Hot reload não reinicia o estado.

1. Ative **Tema escuro**, escolha fonte **24** e clique em **Salvar preferências**.
   Recarregue: deve continuar escuro e 24.
2. Escolha fonte **28**, sem salvar. Recarregue: deve voltar para escuro e 24.
3. Clique em **Restaurar padrão**. Recarregue: deve continuar claro e 18.

## Verificação automática

```bash
flutter analyze
flutter test
```

Os testes usam o armazenamento de teste do `shared_preferences`, recriam a
tela e conferem os três cenários, os limites do slider e a preservação de
uma preferência de outro exercício.

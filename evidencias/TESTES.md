# Verificação em 20/10/2026

- `flutter analyze`: sem problemas.
- `flutter test`: quatro testes passaram.
- Navegador: aplicativo renderizado e controles acionados em 127.0.0.1:8080.
  1. Tema escuro e fonte 24 salvos: mantidos depois de recarregar.
  2. Fonte 28 alterada sem salvar: voltou para 24 depois de recarregar.
  3. Restaurar padrão: tema claro e fonte 18 mantidos depois de recarregar.
- Os testes automatizados também verificam os passos de 2 entre 14 e 28
  e que restaurar não remove a chave de outro exercício.
- Texto da prévia e título alterados para Lorem ipsum; testes repetidos e
  tela final conferida no navegador.

`tela-final.jpg` mostra o estado inicial após restaurar e reabrir.
Android e iOS não foram executados em dispositivo ou emulador.

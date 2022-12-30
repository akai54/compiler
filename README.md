<h1 align="center">Simple Compiler in Ocaml</h1>

<div align="center">Simple Compilateur écrit en Ocaml.</div>

## Compiler

```python
ocamlbuild -r -use-menhir -no-hygiene main.byte
```

## Usage

```python
./main.byte tests/[any_test]
```

## Problèmes rencontrés

Lorsque j'ai commencer ce projet, je suis parti des fichiers du TP7, car c'était le dernier TP que j'ai réussi a faire et j'ignorais complètement l'existence des fichiers prêts que les autres avaient ou il y a deja un compilateur complet avec les types, calls et Var. Alors que moi j'ai du tout implementer de 0 et j'ai du refaire le TP5 pour avoir un compilateur avec les types de bases seulement. J'ai perdu mon temps sur des choses que vous avez deja donner car j'ai pas fait attention. Voilà pourquoi mon compilateur manque des fonctionnalités.

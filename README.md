# marvel


## Scripts

### SwiftLint

Es una herramienta para impotner el estilo y convenciones de Swift. SwiftLint aplica las reglas de la guia de estilo aceptadas por la comunidad de Swift. Dichas reglas están bien definidas en la guía de estilos [Guia de estilos de Swift de Ray Wenderlich](https://github.com/raywenderlich/swift-style-guide).

El script es el siguiente:


```bash

if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

```
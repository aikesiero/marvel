# MARVEL

[![Build Status](https://app.bitrise.io/app/5535191b39398335/status.svg?token=ZL9s6vIO5SbhMu6J18x31Q&branch=develop)](https://app.bitrise.io/app/5535191b39398335)

## Caracteristicas
* Capas de presentación, lógica empresarial y acceso a datos desacopladas
* Test Unitarios
* Persistencia de datos con CoreData (usado para cachear las respuestas)
* Desarrollado teniendo en mente SOLID, DRY, KISS en mente
* Diseñador pensando en la escalibilidad

## Scripts usados

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


# Clean Architecture con MVVM

**Más información sobre Clean Architecture**: <a href="https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html">Clean Architecture</a>

## Regla de la Dependencia

![Alt text](README/Dependency Rule.png?raw=true "Clean Architecture Layers")

La regla primordial que hace que esta arquitectura funcione es la **regla de dependencia**. Esta regla dice que las dependencias del código fuente solo pueden apuntar hacia adentro. Nada en un círculo interno puede saber nada sobre algo en un círculo externo. En particular, el nombre de algo declarado en un círculo exterior no debe ser mencionado por el código en un círculo interior. Eso incluye funciones, clases. variables, o cualquier otra entidad de software nombrada.



## Capas

Tras agrupar todas las capas podemos diferenciar entre tres capas:

* **Presentacion** (MVVM)
* **Dominio** (Lógica de negocio)
* **Datos** (Repositorios de datos, BBDD, APIs)

![Alt text](README/Layers.png?raw=true "Clean Architecture Layers")


### Dominio (Lógica de negocio)

**La capa de Dominio** (Domain Layer) es la capa mas interna de la cebolla (sin dependencia con otras capas, está totalmente *aislada*). Contiende las **Entities** (Business Models), **Use Cases**, y **Repository Interfaces**. Esta capa puede ser reutilizada por diferentes proyectos


> NOTA: La capa de Dominio no debe incluir nada de otras capas (por ejemplo de Presentación, UIKit, SwiftUI, ...)



La razón por la que las buenas arquitecutras estén centradas en Casos de Uso es que así la arquitectos puedan describir de manera segura las estructuras que respaldan esos casos de uso sin comprometerse con los frameworks, las herramientas y el entorno. Es llamado <a href="https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html">Screaming Architecture</a>

### Presentación (MVVM)

**La capa de Presentación** (Presentation Layer) contiene la UI (UIViewControllers o SwiftUI Views). Las Vistas son coordinadas por *ViewModels* (Presenters) que ejecuta uno o varios Casos de Uso.

La capa de presentación depende sólo de la capa de dominio.

### Datos (Repositorios de datos, BBDD, APIs)
**La capa de Datos** (Data Layer) contiene la implementación de los Repositorios y uno o más Data Sources. Los Repositorios son responsables de coordinar datos de difernte Data Sources.

Data Source puede se remoto o local (por ejemplo una base de datos persistente).

La capa de Datos dpenede sólo de la capa de Dominio. En esta capa también podemos mapear los Network JSON (REspuestas de la API) Data a Modelos del Dominio (Entities)

En la gráfica de debajo vemos como cada componente de cada capa es representado junto con la Dirección de Dependencia y también el Flujo de Datos (Request/Response). También podemos ver el punto de Inversión de Dependencias dónde usamos las Interfaces de Repositorio (protocolos).

![Alt text](README/Dependencies.png?raw=true "Clean Architecture Data Flow")

## Flujo de Datos
Es importante diferenciar la **regla de la dependiencia** del **flujo real de datos** representado por la siguiente gráfica:

![Alt text](README/DataFlow.png?raw=true "Clean Architecture Data Flow")

Flujo de datos:

1. **Vista(UI)** llama métodos del **ViewModel** (Presenter).
2. **ViewModel** ejecuta **Caso de Uso**.
3. El **Caso de Uso** combina los datos del Usuario y los **Repositorios**.
4. Cada **Repositorio** devuelve datos de una Fuente Remota (**Network**), Persistent **BBDD** o Datos en memoria (Remota o Cacheada).
5. La información viaja de vuelta a la **Vista(UI)** donde se muestra el listado de items.

## Dirección de Dependencias

**Presentation Layer -> Domain Layer <- Data Repositories Layer**

**Presentation Layer (MVVM)** = ViewModels(Presenters) + Views(UI)

**Domain Layer** = Entities + Use Cases + Repositories Interfaces

**Data Repositories Layer** = Repositories Implementations + API(Network) + Persistence DB

![Alt text](README/LayersDependency.png?raw=true "Clean Architecture Layers")
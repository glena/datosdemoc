datosdemoc
==========

Trabajamos para lograr la centralización, normalización y distribución de Open Data. ¡Para que Open Data y Open Gov sea más abierto y democrático que nunca!

Datos democráticos - http://datosdemocraticos.com.ar
==========

Es un proyecto que buscar centralizar los datos abiertos por las instituciones, normalizarlos y facilitar el acceso mediante un API Rest para que cualquiera pueda integrar OpenData en su proyecto.

Arquitectura
==========

El proyecto esta desarrollado con RoR 4.
Los datos relacionales (manejo de usuarios, información de los datasets y campos de los mismos) se almacenan en una base de datos relacional, actualmente usamos MySQL aunque estando totalmente abstraidos de la misma es posible usar el motor que se desee.
El almacenamiento de OpenData se realiza en MongoDB. Originalmente pensamos en implementarlo sobre Redis pero con mongo tenemos muchas más posibilidades para expandir las funcionalidades del API. Se eligio una base de datos no relacionales por su flexibilidad a la hora de almacenar diversas estructuras de datos.

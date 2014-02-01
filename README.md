datosdemoc
==========

Trabajamos para lograr la centralización, normalización y distribución de Open Data. ¡Para que Open Data y Open Gov sea más abierto y democrático que nunca!

Es un proyecto que buscar centralizar los datos abiertos por las instituciones, normalizarlos y facilitar el acceso mediante un API Rest para que cualquiera pueda integrar OpenData en su proyecto.



Datos democráticos - http://datosdemocraticos.com.ar

En twitter: @datosdemoc http://twitter.com/datosdemoc

En facebook: https://facebook.com/datosdemoc

Arquitectura
------

El proyecto esta desarrollado con RoR 4.
Los datos relacionales (manejo de usuarios, información de los datasets y campos de los mismos) se almacenan en una base de datos relacional, actualmente usamos MySQL aunque estando totalmente abstraidos de la misma es posible usar el motor que se desee.
El almacenamiento de OpenData se realiza en MongoDB. Originalmente pensamos en implementarlo sobre Redis pero con mongo tenemos muchas más posibilidades para expandir las funcionalidades del API. Se eligio una base de datos no relacionales por su flexibilidad a la hora de almacenar diversas estructuras de datos.


Próximos pasos
------

- [ ] Implementar una interfaz de administración de usuarios
- [ ] Implementar una visualización de estadísticas de accesos
- [ ] Implementar una capa de cache sobre mongo (redis o memcached)
- [ ] Implementar cache "Dalli & Cache Digests" de RoR4 (memcached)
- [ ] Implementar filtros sobre los campos de los datasets para consumirse desde el API
- [ ] Implementar una interfaz más "amigable" para acceder los datos desde la WEB


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/glena/datosdemoc/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[![Analytics](https://ga-beacon.appspot.com/UA-32429094-1/glena/datosdemoc)](https://github.com/glena/datosdemoc)

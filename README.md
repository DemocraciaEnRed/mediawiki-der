# mediawiki-der

### Infraestructura general de servicios
Este software está basado en [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki/es). Por ende, cuenta con un servidor web, Apache+PHP, y una base de datos MySql. Además, al utilizar la extensión [VisualEditor](https://www.mediawiki.org/wiki/Extension:VisualEditor) para habilitar un editor visual tipo *office* en los artículos, también requiere de un servidor Node.js con [Parsoid](https://www.mediawiki.org/wiki/Parsoid). Esto resulta sumamente simple de implementar utilizando Docker. Afortunadamente MediaWiki tiene una [imagen oficial en DockerHub](https://hub.docker.com/_/mediawiki). Debido a compatibilidades con las extensiones que utilizamos, usamos la versión **1.32.2** de MediaWiki, como se puede apreciar en nuestro [`Dockerfile`](Dockerfile). Para Parsoid utilizamos la imagen [thenets/parsoid](https://hub.docker.com/r/thenets/parsoid/) versión **0.10**.

### Configuración de MediaWiki
Si bien la aplicación de MediaWiki está en PHP, es muy poco lo que se programa en este lenguage. Donde más se usa es en el archivo de configuración [`LocalSettings.php`](LocalSettings.php). Este archivo se genera automáticamente al utilizar el asistente de instalación de MediaWiki. Posteriormente le agregamos configuración personalizada, a partir de la línea *142* del mismo archivo. Las extensiones que vienen instaladas en esta MediaWiki son:
- [VisualEditor](https://www.mediawiki.org/wiki/Extension:VisualEditor): editor tipo *office* para los artículos
- [TemplateStyles](https://www.mediawiki.org/wiki/Extension:TemplateStyles): permite estilos css incrustados dentro de las [plantillas](https://www.mediawiki.org/wiki/Help:Templates) (que son básicamente componentes html reutilizables)
- [Flow](https://www.mediawiki.org/wiki/Extension:Flow): para tener páginas de discusión más amigables, tipo foro.
- [Echo](https://www.mediawiki.org/wiki/Extension:Echo): una dependencia de Flow.
- [EditNotify](https://www.mediawiki.org/wiki/Extension:EditNotify): para notificar por mensaje interno a otrxs usuarixs cuando se hacen modificaciones en artículos.

Todas estas extensiones tienen sus propias instrucciones de configuración dentro de `LocalSettings.php`, y algunas unos comandos dentro del `Dockerfile`. Si desean utilizar más extensiones, recuerden siempre utilizar las versiones **1.32** de las mismas.

### Pruebas preliminares
Para probar MediaWiki en su estado más puro podemos levantar un contenedor de Docker haciendo:   
`docker run --name prueba-mediawiki -p 8080:80 mediawiki:1.32`   
y navegar a [http://localhost:8080/](http://localhost:8080/) (van a tener que elegir SQLite como base de datos).

Una vez completado el asistente de instalación deben bajarse el archivo `LocalSetting.php` generado y copiarlo al contenedor. Por ejemplo si el archivo se descargó en `~/Downloads/`, haríamos:   
`docker cp ~/Downloads/LocalSettings.php prueba-mediawiki:/var/www/html/`


-----
-----
-----
*docu vieja*


Para usar simplemente hacer `docker-compose up` dentro de la carpeta del proyecto.

Asegurarse de tener el puerto `8080` libre o cambiar la configuración de `ports` y la variable de entorno `MW_SITE_SERVER` en `docker-compose.yml`. Para cambiar la ip/dominio de la wiki es necesario rebuildear.

Credenciales por defecto del admin: `admin` `123123123`.


Si en algún momento desean debugear un error agregar la siguiente línea a `LocalSettings.php` del contenedor:
`$wgShowExceptionDetails = true; $wgDebugToolbar = true; $wgShowDebug = true; $wgDevelopmentWarnings = true; $wgDebugLogFile = "/tmp/{$wgSitename}-debug.log";`
